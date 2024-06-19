--- Micro enhancements using Lua
--------------------------------
--  This is gopherLua a Lua 5.1 VM built in Go there are key differences
--      https://github.com/yuin/gopher-lua
--      New functions from this file will be added to initlua namespace
--      New functions 'required' from this file will also be added to initlua namespace
--      You cannot load binary extensions
--  Accessing micro editor functionality
--      Commands - for the command line can be triggered from Lua with Current.HandleCommand("command")
--      Actions - for binding can be triggered from Lua with Current["action"](Current)
--      Methods and properties - all in userdata and difficult to discover!
--  Calling utilities and other files
--      Functions requiring external tools include a link for downloading
--      Some functions expect to load files from specific locations - sorry
--      Specifically fzf.exe will fail if the required history file is missing
--  Micro.bat
--      In the same directory as micro.exe
--      Launch with local settings files
--      start  "micro.exe" %~dp0micro.exe --config-dir %~dp0confMicro %*
--  Directory structure - for a portable installation
--      editor - contains micro.exe and micro.bat
--          confMicro
--             buffers
--             colorschemes
--             favorites
--             help
--             history
--             syntax
--             zBackup
--          ctags
--          dictionary
--          hunspell
--          insertions
--          keyboard
--          snippets
--             html
--             md
--             mmd
--          templates
--  Contents - best reviewed with a folding editor :)
--      **Load the Go code**
--      **A few Lua extensions**
--      **External Commands**
--      **Events**
--      **Editor functions**
--      **Bindable functions**
--      **fzf actions**
--      **Dialog boxes**
--      **init function**

--------------------------------------------------------
--- **Load the Go code** avoid these reserved namespaces
--------------------------------------------------------
local micro         = import("micro")
local util          = import("micro/util")
local config        = import("micro/config")
local shell         = import("micro/shell")
local buffer        = import("micro/buffer")
local utf8          = import("utf8")
local stringutils   = import("strings")
local pathutils     = import("path/filepath")
local ioutil        = import("io/ioutil")
local osutil        = import("os")
local regexp        = import("regexp")

----------------------------------------------------------------
--- **A few Lua extensions** some made with gopherLua libraries
----------------------------------------------------------------
function print(...)
-- Redirect print to buffer log
    local text = {...}
    for i,v in pairs(text) do
        text[i] = tostring(v)
    end
    local text = table.concat(text,"\t")
    buffer.Log(tostring(text).."\n")
end
function string.trim(s)
-- Full trim of whitespaces
    return s:match('^%s*(.-)%s*$')
end
function string.split(inputstr, sep)
-- Splits for a single character e.g. , or /
-- https://stackoverflow.com/questions/1426954/split-string-in-lua
    if sep == nil then
        sep = "%s"
    end

    local t={}
    local i=1

    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end

    if i>1 then
        return t
    else
        return inputstr
    end
end
function string.wrap(text,left,right)
-- Not called  - future plans
    return text:gsub("^.",left.."%1"):gsub(".$","%1"..right)
end
function table.stash(t,level,output)
-- My recursive serialization function from extensions.lua
-- with great help from http://lua-users.org/lists/lua-l/2009-11/msg00533.html
    if type(t)~="table" then
    return "Error not a table: "..tostring(t)
    end

-- Define output variable
    output = output or {}

-- Define level
    level = level or 1

-- Define tab command
    local function tab(level)
        level = level or 1
        return string.rep("\t",level)
    end

-- Define functions for all data types
    local function stash_string(i,v)
        table.insert(output,tab(level)..'["'..tostring(i)..'"] = '..string.format("%q", v))
        return
    end

    local function stash_number(i,v)
        table.insert(output,tab(level)..'["'..tostring(i)..'"] = '..tostring(v))
        return
    end

    local function stash_boolean(i,v)
        table.insert(output,tab(level)..'["'..tostring(i)..'"] = '..tostring(v))
        return
    end

    local function stash_nil(i,v)
        table.insert(output,tab(level)..'["'..tostring(i)..'"] = nil')
        return
    end

    local function stash_table(i,v) -- Recurse function
        table.insert(output,tab(level)..'["'..tostring(i)..'"] = {')
        level = level+1
            table.stash(v,level,output)
        level    = level-1
        return
    end

    local function stash_function(i,v)              -- TODO:  error handler to catch [C] functions
        table.insert(output,tab(level)..'["'..tostring(i)..'"] = loadstring('..string.format("%q", tostring(v))..")")
    end

    local function stash_userdata(i,v)
        table.insert(output,tab(level)..'["'..tostring(i)..'"] = userdata('..i..")")
    end

    -- Prime the output tables
    if level==1 then
        table.insert(output," return {")
    end

    -- Loop through table using the correct stash function
    for i,v in pairs(t) do
        local item = type(v)
        if item=="string"     then stash_string(i,v) end
        if item=="number"     then stash_number(i,v) end
        if item=="boolean"     then stash_boolean(i,v) end
        if item=="nil"         then stash_nil(i,v) end
        if item=="table"     then stash_table(i,v) end
        if item=="function"    then stash_function(i,v) end
        if item=="userdata" then stash_userdata(i,v) end
    end

    -- Close the current table
    table.insert(output,tab(level).."}")

    -- Close and stringify the final table
    if level==1 then
        -- Concatenate
        output =  table.concat(output,",\n")
        -- Correct errors
        output = string.gsub(output,"{,","{")
    end
    -- Returns table or string depending upon level
    return output
end
function io.exists(filename)                        -- TODO: Check more for valid filename
-- See if a file exists
    -- Check it's a string
    if type(filename)~="string" then return false end
    -- Check for unacceptable characters
    if filename:match("[\n<|>$]") then return false end

    -- Convert to unix directory separators - for Go
    filename = filename:gsub([[/]],[[\]])

    local fileinfo, err = osutil.Stat(filename)
    if osutil.IsNotExist(err) then
        return false
    else
        return true
    end
end
function io.filepath(filename)
-- This strips the last \ unless in the root
    if filename then
        local dir  = pathutils.Dir(filename)
        if dir=="." then
            return nil
        else
            return dir
        end
    else
        return nil
    end
end
function io.filename(filename)
    if filename then
        local name  = pathutils.Base(filename)
        if #name<2 then
            return nil
        else
            return name
        end
    else
        return nil
    end
end
function io.cd(Current)
    local path = io.filepath(Current.Buf.AbsPath)
    Current.CdCmd(Current,{path})
end
function io.stash(t,filename)                       -- TODO: Check for valid filename
-- Store a table as a text file                     -- TODO: Process both separators
                                                    -- TODO: and relative paths
    -- Serialize to file , dependent upon table.stash()
    if type(t)~="table" then
        return "Error not a table: "..tostring(t)
    end

    -- Serialize
    t = table.stash(t)

    -- Write to disc
    local f = io.open(filename,"w+")
    f:write(t)
    f:flush()
    f:close()
end
function os.setenv2(var,new_string)
 -- GopherLua has a function to set an environment variable : ``os.setenv(name, value)``
end

-------------------------
--- **External Commands**
-------------------------
function msgbox(text,title)
-- Spawns a modal gui message box - for debugging!
-- Requires msgbox.exe in your path (http://claudiosoft.online.fr/msgbox.html)
    if not text then return end
    if not title then title = "Message" end
    shell.RunCommand([[MSGBOX.EXE ]]..[["]]..text..[[" "]]..title..[["]])
    -- msgbox("hello World")
end
function fzf(source, options)
-- Fuzzy selector for file contents or newline separated list
-- Requires fzf.exe in your path (https://github.com/junegunn/fzf/releases)
-- Requires cat.exe in your path (http://gnuwin32.sourceforge.net/packages/coreutils.htm)

    if not source then return end
    if not io.exists(source) then
        -- Make a temp file - overwrite contents
        local file = io.open(config.ConfigDir..[[/history/fzf.fzf]], "w+")
        file:write(source)
        file:close()
        source = config.ConfigDir..[[/history/fzf.fzf]]
    end

    local options = options or "--prompt='> select '"
    local sel, err = shell.RunInteractiveShell('cmd.exe /c cat.exe "'..source..'" | fzf.exe '..options, false, true)
    return sel
end

------------------------------------
--- **Events**  - possibly expensive
------------------------------------
function onBufferOpen(Current)
end
function OnSwap(Current)
 -- This is called from recognised event functions below
    micro.InfoBar():Message(" ")
end
function prePreviousTab(Current)
    OnSwap(Current)
end
function preNextTab(Current)
    OnSwap(Current)
end
function prePreviousSplit(Current)
    OnSwap(Current)
end
function preNextSplit(Current)
    OnSwap(Current)
end
function preAddTab(Current)
    OnSwap(Current)
end
function onRune(Current, r)
    -- Create a shortcut for each distinct line, fails if multiple instances of micro write
    if io.exists(Current.Buf.Path) then
        editor.History[tostring(Current.Buf.AbsPath):gsub([[\]],[[/]])..":"..editor.GetLineNumber(Current)] = 1
    end
end
function onSave(Current)
    -- Save filename to /favorites/recent.txt
    local filename = Current.Buf.AbsPath
    local recent = config.ConfigDir..[[/favorites/recent.txt]]
    if io.exists(filename) then
        if io.exists(recent) then
            shell.RunCommand([[cmd.exe /c (echo ]]..filename..[[ & type ]]..recent..[[) | sort.exe -T %TEMP% | uniq.exe > ]]..recent..[[.tmp & copy ]]..recent..[[.tmp ]]..recent ..[[ & del ]]..recent..[[.tmp >nul 2>&1]])
        else
            shell.RunCommand([[cmd.exe /c echo ]]..filename..[[ > ]]..recent)
        end
    end
    -- Make all files have dos endings i.e. CRLF
    Current.Buf.Settings["fileformat"] = "dos"
    return false
end
function preQuit(Current)
    -- Make all files have dos endings i.e. CRLF
    Current.Buf.Settings["fileformat"] = "dos"
    -- Save History - overwrites lines.lua
    editor.SaveHistory()
end
function preQuitAll(Current)
    -- Just call preQuit
--     preQuit(Current)
end
function preAutocomplete(Current)
end

------------------------
--- **Editor functions**
------------------------
-- Don't bind directly to these functions
-- I want to build an interface of pure Lua functions and data types i.e Not userdata!
-- Naming things is difficult:
--  Get - reads into a variable
--  Set - writes from a variable
--  Select - changes cursor selection
--  Copy - copies to clipboard
--  Cut  - copies to clipboard and removes
--  Del  - removes without clipboard
--  Append - adds to clipboard

editor = {}
editor.History = {}

function editor.NewTab(Current,filename)
-- New tab with buffer
-- Thanks to dmaluka
-- https://github.com/zyedidia/micro/issues/2034
    if io.exists(filename) then
        Current:NewTabCmd({filename})
    else
        Current:NewTabCmd({})
    end
end
function editor.NewTabReadOnly(Current,filename)
-- For opening help files in tabs
    if io.exists(filename) then
        Current:NewTabCmd({filename})
        Current.Buf.Settings["readonly"] = true
    end
end
function editor.NewBuf(Current,filename)
-- New tab
    if not filename then
        local buf, err = buffer.NewBufferFromString("")
        if err == nil then
            return buf
        else
            return nil
        end
    elseif io.exists(filename) then
        local buf, err = buffer.NewBufferFromFile(filename)
        if err == nil then
            return buf
        else
            return nil
        end
    elseif filename then                                -- TODO: Check for valid file name
        local buf, err = buffer.NewBufferFromString(tostring(filename))
        if err == nil then
            return buf
        else
            return nil
        end
    else
        return nil
    end
end
function editor.Save(Current)
-- Save file
    -- Make all files have dos endings i.e. CRFL
    Current.Buf.Settings["fileformat"] = "dos"
    -- Do the save
    Current.Buf:Save()
end
function editor.Reopen(Current)                     -- TODO: Wait for fix https://github.com/zyedidia/micro/issues/3303
-- Reopen an file from disc
    if io.exists(Current.Buf.AbsPath) then
        -- Current.Buf:ReOpen()
        -- micro.InfoBar():Message("Reopened: "..Current.Buf.AbsPath)

        -- I am having problems with mangled files therefore
        micro.InfoBar():Message("Buffer Reopen is not reliable - it mangles the contents")
    end
end
function editor.ShowLog(Current)                    -- TODO: Cehck if already open and use one log pane
-- View log buffer
    Current:OpenLogBuf()
end
function editor.Panes(Current)
-- Iterate open panes for switching Alt-W
    local t = {}
    local tabs = micro.Tabs()
    for i = 1,#tabs.List do
        tab = tabs.List[i]
        for j = 1,#tab.Panes do
            table.insert(t,i.."."..j.." = "..tab.Panes[j].Buf.AbsPath)
        end
    end
    return t or nil
end
function editor.SaveHistory()                       -- TODO: As we don't have single instance this can get corrupted
-- Save a trail of file/line numbers for GoPrvious Alt-P
    io.stash(editor.History,config.ConfigDir.."/history/lines.lua")
end
function editor.LoadHistory()
-- Get saved trail of file/line numbers for GoPrvious Alt-P
    if io.exists(config.ConfigDir.."/history/lines.lua") then
        editor.History = dofile(config.ConfigDir.."/history/lines.lua") or {}
        if #editor.History>1000 then
            msgbox("lines.lua is getting rather large!")
        end
    end
end
function editor.HasSelection(Current)
    return Current.Cursor:HasSelection()
end
function editor.GetSelection(Current)
    return util.String(Current.Cursor:GetSelection()) or nil
end
function editor.GetWord(Current)
    Current.Cursor:SelectWord()
    return util.String(Current.Cursor:GetSelection()) or nil
end
function editor.GetWordLeft(Current)
    Current:SelectWordLeft()
    return util.String(Current.Cursor:GetSelection()) or nil
end
function editor.GetLineNumber(Current)
    return (Current.Cursor.Y)+1 or nil
end
function editor.GetLine(Current)
    return Current.Buf:Line(Current.Cursor.Y) or nil
end
function editor.GetBlock(Current)
-- Get all part selected lines, including bottom up selections
    if Current.Cursor:HasSelection() then
        local block  =  ""
        local top    = math.min(Current.Cursor.CurSelection[1].Y,Current.Cursor.CurSelection[2].Y)
        local bottom = math.max(Current.Cursor.CurSelection[1].Y,Current.Cursor.CurSelection[2].Y)
        for i=top, bottom,1 do
            block = block..Current.Buf:Line(i).."\n"    -- TODO: Shoulduse system EOL character
        end
        return block
    else
        return nil
    end
end
function editor.SwapAnchor(Current)
-- Move active insertion point to the other end of the selection
-- Allow me to extend selection from either end
-- Many thanks https://github.com/zyedidia/micro/issues/2583
    if editor.HasSelection(Current)  then
        local a, b = -Current.Cursor.CurSelection[1], -Current.Cursor.CurSelection[2]
        if -Current.Cursor.Loc == a then
            -- backward -> forward
            Current.Cursor:GotoLoc(b)
            Current.Cursor.OrigSelection = -Current.Cursor.CurSelection
        else
            -- forward -> backward
            Current:Deselect()
            Current.Cursor:GotoLoc(b)
            Current.Cursor.OrigSelection[1] = -Current.Cursor.Loc
            Current.Cursor:GotoLoc(a)
            Current.Cursor:SelectTo(a)
        end
    end
end
function editor.Goto(Current,linenumber)
-- Focus and scroll to a specific line
    if linenumber and tonumber(linenumber)>0 then
        Current:GotoCmd({linenumber})
        return true
    else
        return false
    end
end
function editor.GetTextLoc(Current)
-- Returns Loc-tuple w/ current marked text or whole line (begin, end)
-- https://github.com/NicolaiSoeborg/manipulator-plugin/blob/master/manipulator.lua
    local a, b = nil, nil
    if editor.HasSelection(Current) then
        if Current.Cursor.CurSelection[1]:GreaterThan(-Current.Cursor.CurSelection[2]) then
            a, b = Current.Cursor.CurSelection[2], Current.Cursor.CurSelection[1]
        else
            a, b = Current.Cursor.CurSelection[1], Current.Cursor.CurSelection[2]
        end
    else
        local eol = string.len(Current.Buf:Line(Current.Cursor.Loc.Y))
        a, b = Current.Cursor.Loc, buffer.Loc(eol, Current.Cursor.Y)
    end
    return buffer.Loc(a.X, a.Y), buffer.Loc(b.X, b.Y)
end
function editor.Insert(Current,item)                -- TODO: At every cursor
    if type(item)=="string" then
        Current.Cursor:DeleteSelection()
        Current.Buf:Insert(editor.GetTextLoc(Current), item)
    end
end
function editor.InsertFile(Current,item)
    if type(item)=="string" then
        if io.exists(item) then
            -- insert file contents
            local filename,err = ioutil.ReadFile(item)
            if not err then
                Current.Cursor:DeleteSelection()
                Current.Buf:Insert(editor.GetTextLoc(Current), filename)
            end
        end
    end
end
function editor.FindSel(Current)
    if not editor.HasSelection(Current) then return end
    local sel = Current.Cursor:GetSelection() -- BYTES
    Current.Cursor.Loc = -Current.Cursor.OrigSelection[1]
    Current:Search(sel, false, true)
end
function editor.DoCommand(Current,command)
-- This will run commands, but not bindable actions!
    Current:HandleCommand(command)
end
function editor.DoAction(current,action)
-- This will activate actions
    Current[action](Current)
end

----------------------------------------------------
--- **Bindable functions** -- single word lower case
----------------------------------------------------
-- These should all really return true or false for chaining!

function delsel(Current)
-- Used to delete all partly selected lines or current line if no selection
-- This avoids deleting EOL when deleting partially selected lines
-- "YourKey": "lua:initlua.delsel,SelectLine,Delete",
    if editor.HasSelection(Current) then
        Current.Cursor:DeleteSelection()
    end
end
function duplicate(Current)
-- Duplicate depending upon what is selected
    if Current.Cursor:HasSelection() then
        if Current.Cursor.CurSelection[1].Y == Current.Cursor.CurSelection[2].Y then
            -- Selection on a single line - therefore:
                -- Duplicate selection with padding
                -- Insert after last character
                -- Maintain original selection
            local sel = Current.Cursor:GetSelection()   -- BYTES
            sel = util.String(sel)                      -- String
            sel = sel.." "                              -- Add left padding as likely a word
            local nextcharLOC = buffer.Loc(Current.Cursor.CurSelection[2].X+1, Current.Cursor.CurSelection[2].Y)
            Current.Buf:Insert(nextcharLOC, sel)
            return true
        else
            -- Multiline selection - therefore:
                -- Get all part selected lines
                -- Insert after last line
                -- Maintain original selection
            local block  =  ""
            local top    = math.min(Current.Cursor.CurSelection[1].Y,Current.Cursor.CurSelection[2].Y)
            local bottom = math.max(Current.Cursor.CurSelection[1].Y,Current.Cursor.CurSelection[2].Y)
            for i=top, bottom,1 do
                block = block..Current.Buf:Line(i).."\n"
            end
            local nextlineLOC = buffer.Loc(0,bottom+1)
            Current.Buf:Insert(nextlineLOC, block)
            return true
        end
    else
            -- Nil selection  - therefore:
                -- Duplicate current line
                -- Insert after current line
                -- Maintain cursor position
            local sel = Current.Buf:Line(Current.Cursor.Y).."\n"
            local nextlineLOC = buffer.Loc(0,Current.Cursor.Y+1)
            Current.Buf:Insert(nextlineLOC, sel)
            return true
    end
end
function toupper(Current)
-- Change case to upper
    if editor.HasSelection(Current) then
        local sel = editor.GetSelection(Current)
        sel = string.upper(sel)
        editor.Insert(Current,sel)
    end
end
function tolower(Current)
-- Change case to lower
    if editor.HasSelection(Current) then
        local sel = editor.GetSelection(Current)
        sel = string.lower(sel)
        editor.Insert(Current,sel)
    end
end
function findselected(Current)
-- Highlights all matches for the current selection
-- Use with selectword to highlight all instances of the word under cursor Ctrl+*
-- "YourKey": "lua:initlua.selectword,lua:initlua.findselected",
    editor.FindSel(Current)
end
function findword(Current)                          -- Not called
-- Highlights all matches for the current word
    if editor.HasSelection(Current) then
        editor.FindSel(Current)
    else
        editor.GetWord(Current)
        editor.FindSel(Current)
    end
end
function swapanchor(Current)
-- Allow extending the selection from either end
    editor.SwapAnchor(Current)
end
function selectword(Current)
-- Quickly select the word containing the cursor L>R
    if editor.HasSelection(Current) then
        Current:SelectWordLeft()
    end
    editor.GetWord(Current)
end
function selectwordback(Current)
-- Quickly select the word containing the cursor R>L
    if editor.HasSelection(Current) then
        Current:SelectWordLeft()
    end
    editor.GetWord(Current)
    editor.SwapAnchor(Current)
end
function selectline(Current)
-- Quickly select the line or line below or unselect
    -- This is different from the built-in action "SelectLine"
    if not editor.HasSelection(Current) then
        Current.Cursor:SelectLine()
        return
    end
    -- Check for newline
    if string.match(editor.GetSelection(Current),"([\r\n])") then
    -- Extend the selection to the next line
        Current:SelectDown()
        return
    else
    -- Select the line
        Current.Cursor:SelectLine()
        return
    end
end
function selectlineback(Current)
-- Quickly select the line or line above or unselect
    -- Check for selection
    if not editor.HasSelection(Current) then
    -- Select the line
        Current.Cursor:SelectLine()
        editor.SwapAnchor(Current)
        return
    end
    -- Check for newline
    if string.match(editor.GetSelection(Current),"([\r\n])") then
    -- Extend the selection to the next line
        Current:SelectUp()
        return
    else
    -- Select the line
        Current.Cursor:SelectLine()
        editor.SwapAnchor(Current)
        return
    end
end
function selectforwards(Current)
-- Select forwards from cursor using regex (set to ungreedy and case sensitive)
    -- this does require escaping of regex metacharacter
    -- this does not pollute the find history
    -- this does not highlight all matches
    local prompt = "SelectUntil : "
    local seed = "(?sU-i).*"
    local history = "SelectUntil"
    micro.InfoBar():Prompt(prompt, seed, history,
        function(input)
            return
        end,
        function(input, canceled)
            if input and not canceled then
                local top = Current.Buf:Start()
                local bottom = Current.Buf:End()
                local searchLoc = -Current.Cursor.Loc
                local down = true
                local useRegex = true
                local res, found = Current.Buf:FindNext(input, top, bottom, searchLoc, down, useRegex)
                if found then
                    Current.Cursor:SetSelectionStart(searchLoc)
                    Current.Cursor:SetSelectionEnd(res[2])
                    Current.Cursor.OrigSelection[1] = -Current.Cursor.CurSelection[1]
                    Current.Cursor.OrigSelection[2] = -Current.Cursor.CurSelection[2]
                    Current.Cursor:GotoLoc(res[2])
                    Current:Relocate()
                end
            end
        end
    )
end
function selectbackwards(Current)
-- Select backwards from cursor using regex (set to ungreedy and case sensitive)
    -- this does require escaping of regex metacharacter
    -- this does not pollute the find history
    -- this does not highlight all matches
    local prompt = "SelectBack : "
    local seed = "(?sU-i)"
    local history = "SelectBack"
    micro.InfoBar():Prompt(prompt, seed, history,
        function(input)
            return
        end,
        function(input, canceled)
            if input and not canceled then
                local top = Current.Buf:Start()
                local bottom = Current.Buf:End()
                local searchLoc = -Current.Cursor.Loc
                local down = false
                local useRegex = true
                local res, found = Current.Buf:FindNext(input, top, bottom, searchLoc, down, useRegex)
                if found then
                    Current.Cursor:SetSelectionStart(searchLoc)
                    Current.Cursor:SetSelectionEnd(res[1])
                    Current.Cursor.OrigSelection[1] = -Current.Cursor.CurSelection[1]
                    Current.Cursor.OrigSelection[2] = searchLoc
                    Current.Cursor:GotoLoc(res[1])
                    Current:Relocate()
                end
            end
        end
    )
end
function goforwards(Current)
-- Move forwards from cursor using regex (set to ungreedy and case sensitive)
    -- this does require escaping of regex metacharacter
    -- this does not pollute the find history
    -- this does not highlight all matches
    -- this will alight at the beginning of a multicharacter search
    local prompt = "Go forwards : "
    local seed = "(?sU-i)"
    local history = "Goforwards"
    micro.InfoBar():Prompt(prompt, seed, history,
        function(input)
            return
        end,
        function(input, canceled)
            if input and not canceled then
                local top = Current.Buf:Start()
                local bottom = Current.Buf:End()
                local searchLoc = -Current.Cursor.Loc
                local down = true
                local useRegex = true
                local res, found = Current.Buf:FindNext(input, top, bottom, searchLoc, down, useRegex)
                if found then
                    Current.Cursor:SetSelectionStart(res[1])
                    Current.Cursor:SetSelectionEnd(res[2])
                    Current.Cursor.OrigSelection[1] = -Current.Cursor.CurSelection[1]
                    Current.Cursor.OrigSelection[2] = -Current.Cursor.CurSelection[2]
                    Current.Cursor:GotoLoc(res[2])
                    Current:Relocate()
                    Current.Cursor:Deselect(true)
                end
            end
        end
    )
end
function gobackwards(Current)
-- Move backwards from cursor using regex (set to ungreedy and case sensitive)
    -- this does require escaping of regex metacharacter
    -- this does not pollute the find history
    -- this does not highlight all matches
    -- this will alight at the beginning of a multicharacter search
    local prompt = "Go backwards : "
    local seed = "(?sU-i)"
    local history = "Gobackwards"
    micro.InfoBar():Prompt(prompt, seed, history,
        function(input)
            return
        end,
        function(input, canceled)
            if input and not canceled then
                local top = Current.Buf:Start()
                local bottom = Current.Buf:End()
                local searchLoc = -Current.Cursor.Loc
                local down = false
                local useRegex = true
                local res, found = Current.Buf:FindNext(input, top, bottom, searchLoc, down, useRegex)
                if found then
                    Current.Cursor:SetSelectionStart(res[1])
                    Current.Cursor:SetSelectionEnd(res[2])
                    Current.Cursor.OrigSelection[1] = -Current.Cursor.CurSelection[1]
                    Current.Cursor.OrigSelection[2] = -Current.Cursor.CurSelection[2]
                    Current.Cursor:GotoLoc(res[2])
                    Current:Relocate()
                    Current.Cursor:Deselect(true)
                end
            end
        end
    )
end
function retab(Current)
-- Replaces all leading tabs with spaces or leading spaces with tabs
    -- depending on the value of `tabstospaces`
    editor.DoCommand(Current,"retab")
end
function SpawnMultiCursorAll(Current)
-- I want to edit like a god!
    -- https://github.com/zyedidia/micro/issues/2920
    micro.InfoBar():Message("Still waiting for SpawnMultiCursorAll!")
end
function unmark(Current)
-- Hides all the found string highlighting
    Current:UnhighlightSearch()
end
function pasteplain(Current)
-- Requires GetPlainText.exe in your path (http://clipdiary.com/getplaintext)
    shell.RunCommand("GetPlainText.exe ")
end
function runfile(Current)
-- Attempts to open the current file with the windows default application.
    -- Requires shelexec.exe in your path (http://www.naughter.com/shelexe.html)
    -- added some extra processing for my multimarkdown and markdown files
    local ext  = Current.Buf.Path:match("^.+(%..+)$") or "unknown"
    if ext=="unknown" then return end

    -- Save the current file
    editor.Save(Current)

    if ext==".mmd" then
        shell.RunCommand(config.ConfigDir..[[\..\..\open\]].."mmd.bat " .. Current.Buf.Path)
    elseif ext==".md" then
        shell.RunCommand(config.ConfigDir..[[\..\..\open\]].."md.bat " .. Current.Buf.Path)
    else -- Windows default
        shell.RunCommand("shelexec.exe " .. Current.Buf.Path)
    end
end
function joinlines(v)
-- Joins lines condensing whitespace
    --https://github.com/Lisiadito/join-lines-plugin
    local a, b, c = nil, nil, v.Cursor
    local selection = c:GetSelection()

    if c:HasSelection() then
        if c.CurSelection[1]:GreaterThan(-c.CurSelection[2]) then
            a, b = c.CurSelection[2], c.CurSelection[1]
        else
            a, b = c.CurSelection[1], c.CurSelection[2]
        end
        a = buffer.Loc(a.X, a.Y)
        b = buffer.Loc(b.X, b.Y)
        selection = c:GetSelection()
    else
        -- get beginning of curent line
        c:StartOfText()
        local startLoc = buffer.Loc(c.Loc.X, c.Loc.Y)
        -- get the last position of the next line
        -- I use the go function because Lua string.len counts bytes which leads
        -- to wrong results with some unicode characters
        local xNext = util.CharacterCountInString(v.Buf:Line(c.Loc.Y+1))

        a = startLoc
        b = buffer.Loc(xNext, c.Loc.Y+1)
        c:SetSelectionStart(startLoc)
        c:SetSelectionEnd(b)
        selection = c:GetSelection()
    end

    selection = util.String(selection)

    -- swap all whitespaces with a single space
    local modifiedSelection = string.gsub(selection, "%s+", " ")

    if util.CharacterCountInString(selection) > 0 then
        -- write modified selection to buffer
        v.Buf:Replace(a, b, modifiedSelection)
    else
        c:ResetSelection()
    end
end
function smarthome(Current)                     -- Not called
-- Alter home key to hit indent, then hit column 1
    -- https://github.com/deusnefum/micro-bounce
    local Cursor = Current.Buf:GetActiveCursor()
    local origX = Cursor.Loc.X
    Cursor:StartOfText()
    if origX == Cursor.Loc.X then
        Cursor:Start()
    end
    Current:Relocate()
end
function findmatchingbrace(Current)
-- Move between matcihg braces
    return Current["JumpToMatchingBrace"](Current)
end
function jumpToExactMatchingBrace(Current)
-- Always select the actual brace
  -- https://github.com/zyedidia/micro/issues/3308
    local mb, left, found = Current.Buf:FindMatchingBrace(-Current.Cursor.Loc)
    if found and not left then
        Current.Cursor:GotoLoc(mb)
        Current:Relocate()
        return true
    end
    return false
end
function findNextUnpairedBraceLeft(Current)
-- Jump to start of current enclosure
    -- https://github.com/zyedidia/micro/issues/3308
    local countPar  = 0
    local countCurl = 0
    local countSq   = 0

    local loc = -Current.Cursor.Loc
    local bufStart = Current.Buf:Start()

    while loc:GreaterThan(bufStart) do
        loc = loc:Move(-1, Current.Buf)
        local curLine = Current.Buf:Line(loc.Y)

        local r = util.RuneAt(curLine, loc.X)
        if r == "(" then
            countPar = countPar + 1
            if countPar > 0 then
                return loc
            end
        elseif r == "{" then
            countCurl = countCurl + 1
            if countCurl > 0 then
                return loc
            end
        elseif r == "[" then
            countSq = countSq + 1
            if countSq > 0 then
                return loc
            end
        elseif r == ")" then
            countPar = countPar - 1
        elseif r == "}" then
            countCurl = countCurl - 1
        elseif r == "]" then
            countSq = countSq - 1
        end
    end
    return nil
end
function findNextUnpairedBraceRight(bp)
-- Jump to end of current enclosure
    -- https://github.com/zyedidia/micro/issues/3308
    local countPar  = 0
    local countCurl = 0
    local countSq   = 0

    local loc = -bp.Cursor.Loc
    local bufEnd = bp.Buf:End()

    while loc:LessThan(bufEnd) do
        loc = loc:Move(1, bp.Buf)
        local curLine = bp.Buf:Line(loc.Y)

        local r = util.RuneAt(curLine, loc.X)
        if r == ")" then
            countPar = countPar + 1
            if countPar > 0 then
                return loc
            end
        elseif r == "}" then
            countCurl = countCurl + 1
            if countCurl > 0 then
                return loc
            end
        elseif r == "]" then
            countSq = countSq + 1
            if countSq > 0 then
                return loc
            end
        elseif r == "(" then
            countPar = countPar - 1
        elseif r == "{" then
            countCurl = countCurl - 1
        elseif r == "[" then
            countSq = countSq - 1
        end
    end
    return nil
end
function jumpToNextUnpairedBraceLeft(bp)
-- https://github.com/zyedidia/micro/issues/3308
    local loc = findNextUnpairedBraceLeft(bp)
    if loc ~= nil then
        bp.Cursor:GotoLoc(loc)
        bp:Relocate()
        return true
    end
    return false
end
function jumpToNextUnpairedBraceRight(bp)
-- https://github.com/zyedidia/micro/issues/3308
    local loc = findNextUnpairedBraceRight(bp)
    if loc ~= nil then
        bp.Cursor:GotoLoc(loc)
        bp:Relocate()
        return true
    end
    return false
end
function selectinner(bp)
-- Select inner contents of current enclosure
    -- https://github.com/zyedidia/micro/issues/3308
    local braceStart = findNextUnpairedBraceLeft(bp)
    if braceStart ~= nil then
        local braceEnd, left, found = bp.Buf:FindMatchingBrace(braceStart)
        if found and not left then
            braceStart = braceStart:Move(1, bp.Buf)
            if braceStart:LessThan(braceEnd) then
                bp.Cursor:SetSelectionStart(braceStart)
                bp.Cursor:SetSelectionEnd(braceEnd)
                bp.Cursor.OrigSelection = -bp.Cursor.CurSelection
                bp.Cursor:GotoLoc(braceEnd)
                bp:Relocate()
                return true
            end
        end
    end
    return false
end
function selectouter(bp)
-- Select braces and contents of current enclosure
    -- https://github.com/zyedidia/micro/issues/3308
    local braceStart = findNextUnpairedBraceLeft(bp)
    if braceStart ~= nil then
        local braceEnd, left, found = bp.Buf:FindMatchingBrace(braceStart)
        if found and not left then
            braceEnd = braceEnd:Move(1, bp.Buf)
            if braceStart:LessThan(braceEnd) then
                bp.Cursor:SetSelectionStart(braceStart)
                bp.Cursor:SetSelectionEnd(braceEnd)
                bp.Cursor.OrigSelection = -bp.Cursor.CurSelection
                bp.Cursor:GotoLoc(braceEnd)
                bp:Relocate()
                return true
            end
        end
    end
    return false
end
function opensel(Current)
-- Attempts to use the current selection as a filename for editing in micro,
    -- or as a url to be opened with the windows default application.
    -- Requires shelexec.exe in your path (http://www.naughter.com/shelexe.html)
    sel = editor.GetSelection(Current)

    -- Remove newline and leading/trailing whitespace - allow lazy selection
    sel = sel:gsub("\n",""):trim()
    if not sel or sel=="" then return end

    -- Check for valid filename and open
    if io.exists(sel) then
        editor.NewTab(Current,sel)
        return
    end

    -- Check for url and try to open
    if sel:match("http://%S+") or sel:match("https://%S+") or sel:match("ftp://%S+") or sel:match("mailto://%S+") then
        shell.RunCommand("shelexec.exe " .. sel)
    end

end
function reopen(Current)
-- Revert to disc copy
    editor.Reopen(Current)
end
function backupfile(Current)
-- I like local date stamped backups
    -- Requires xcopy.exe in your path
    -- Don't try to backup none-existent files
    if not io.exists(Current.Buf.AbsPath) then return end
    -- Make backup folder
    local zbackfolder = io.filepath(Current.Buf.AbsPath)..[[\zBackup]]
    if not io.exists(zbackfolder) then
        shell.RunCommand([[cmd.exe /c mkdir ]] .. zbackfolder)
    end
    if not io.exists(zbackfolder) then
        micro.InfoBar():Message("Can't make directory: "..zbackfolder)
        return
    end
    -- Make datestamp
    local t = os.date("*t")
    local sec = ((t.hour*60*60)+(t.min*60)+(t.sec))
    local datestamp = os.date("%Y_%m_%d_")..sec.."_"
    -- Make backup filename
    local mypath, myfile, myext = string.match(Current.Buf.AbsPath, "(.-)([^\\]-([^%.]+))$")
    local sel = zbackfolder.."\\"..datestamp..myfile
    -- Copy file copy to backup
    shell.RunCommand([[cmd.exe /c xcopy.exe ]]..Current.Buf.AbsPath..' '..sel.."* >nul 2>nul && exit")
    -- Send a message
    micro.InfoBar():Message("Backup @ "..sel)
end
function wordcount(Current)
-- Count words in selection or whole buffer
    -- https://github.com/micro-editor/updated-plugins/blob/master/micro-wc-plugin/wc.lua
    --Get active cursor (to get selection)
    local Cursor = Current.Buf:GetActiveCursor()
    --If cursor exists and there is selection, convert selection byte[] to string
    if Cursor and Cursor:HasSelection() then
        text = util.String(Cursor:GetSelection())
    else
    --no selection, convert whole buffer byte[] to string
        text = util.String(Current.Buf:Bytes())
    end
    --length of the buffer/selection (string), utf8 friendly
    charCount = utf8.RuneCountInString(text)
    --Get word/line count using gsub's number of substitutions
    -- number of substitutions, pattern: %S+ (more than one non-whitespace characters)
    local _ , wordCount = text:gsub("%S+","")
    -- number of substitutions, pattern: \n (number of newline characters)
    local _, lineCount = text:gsub("\n", "")
    --add one to line count (since we're counting separators not lines above)
    lineCount = lineCount + 1
    --display the message
    micro.InfoBar():Message("Lines:" .. lineCount .. "  Words:"..wordCount.."  Characters:"..charCount)
end
function cutappend(Current)                        -- TODO:
-- Apend current selection to clipboard and delete
end
function copyappend(Current)                        -- TODO:
-- Apend current selection to clipboard
end
function wraptoggle(Current)
-- Wrap text
    Current.Buf.Settings["softwrap"] = not Current.Buf.Settings["softwrap"]
end
function hdual(Current)
-- Split view horizontal
   editor.DoCommand(Current,"hsplit \""..Current.Buf.Path.."\"")
end
function vdual(Current)
-- Split view verticle
   editor.DoCommand(Current,"vsplit \""..Current.Buf.Path.."\"")
end
function comspec(Current)
-- Bypass "access disallowed" for cmd.exe
    shell.RunCommand([[shelexec.exe /Params:-Command cmd.exe /EXE powershell.exe]])
end
function makeit(Current)
-- Call local makeit.bat if exists
    local filename = Current.Buf:GetName()
    local folder = io.filepath(filename)
    local target = folder .."\\" .. "makeit.bat"
    if io.exists(target) then
        shell.RunCommand(target)
        micro.InfoBar():Message("Makeit.bat finished @ "..folder)
    end
end
function todo(Current)
-- Edit local todo.txt if exists
    local filename = Current.Buf:GetName()
    local folder = io.filepath(filename)
    local target = folder .."\\" .. "todo.txt"
    if io.exists(target) then
        -- Open for editing
        editor.NewTab(Current,target)
    end
end
function cheat(Current)
-- Open cheat sheet micro-cheat
    -- https://github.com/terokarvinen/micro-cheat/tree/main/cheatsheets
    -- Cheatsheets are copyrighted by their original authors
    -- Cheatsheets from Devhints.io are copyright 2021
    -- Rico Sta. Cruz and contributors, received under the MIT license
    local filename = Current.Buf:GetName()
    local filetype = Current.Buf:FileType()
    local cheatdir = config.ConfigDir.."/../../help/sheets/"

    if filetype == "unknown" then
        micro.InfoBar():Message("Cheatsheet not found for type '"..filetype.."', filename '"..filename.."'")
        return
    end

    local cmd = "tab " .. cheatdir .. filetype .. ".md"
    editor.DoCommand(Current,cmd)
end
function clearcursors(Current)
-- Provide a return value for keybinding parser
    -- https://github.com/zyedidia/micro/issues/2755
    if Current.Buf:NumCursors() > 1 then
        Current:RemoveAllMultiCursors()
        return true
    else
        return false
    end
end
function luaexec(Current)
-- Insert returned value of selected Lua code within Micro Ctrl+Alt+=
    -- type(string.split)
    -- 21^6
    -- for i,v in pairs(_G) do if type(v)=="table" then print(i) end end -- FAILS no return to print

    local function print(...)
        local text = {...}
        if not text then return end
        for i,v in pairs(text) do
            text[i] = tostring(v)
        end
        local text = table.concat(text,"\t")
        Current.Buf:Insert(editor.GetTextLoc(Current),tostring(text))
    end
    if not editor.HasSelection(Current) then return end
    local sel = editor.GetSelection(Current)
    local f = loadstring("return "..sel)
    local r = f()
    if r then
        Current.Cursor:DeleteSelection()
        print(r)
    end
end
function luamode(Current)
-- Lua command line Ctrl+=
    -- print is redirected to Log
    local prompt = "Lua> "
    local seed = editor.GetSelection(Current) or ""
    local history = "Lua"
    micro.InfoBar():Prompt(prompt, seed, history,
        function(input)
            return
        end,
        function(input, canceled)
            if input and not canceled then
                local f = loadstring(input)
                local r = f()
                if r then
                    print(tostring(r))
                end
                editor.ShowLog(Current)
            end
        end
    )
end
function editAHK(Current)
-- Load my main autohotkey script
    local file = [[O:\MyProfile\cmd\Autocorrect.ahk]]
    editor.DoCommand(Current,"tab \"" .. file .. "\"")
end
function pwd(Current)
    micro.InfoBar():Message("Current Directory : "..pathutils.Dir(Current.Buf.AbsPath))
end

-------------------
--- **fzf actions**
-------------------
-- Fails if no history file in the correct folder - read the code
-- Fails if accessory files not in the  correct folder - read the code


function fzfkeys(Current)                           -- Display current bindings
-- Search keybindings and then execute
    -- Requires fzf.exe in your path (https://github.com/junegunn/fzf/releases)
    -- Requires cat.exe in your path (http://gnuwin32.sourceforge.net/packages/coreutils.htm)
    -- Requires tr.exe in your path (http://gnuwin32.sourceforge.net/packages/coreutils.htm)
    -- Requires awk.exe in your path (https://gnuwin32.sourceforge.net/packages/gawk.htm)
    local target1 = config.ConfigDir..[[/bindings.json]]
    -- NB bindings.json includes duplicates of keys that my terminal can't send.
    if not io.exists(target1) then return end


    -- Run fzf (fails if history file does not exist)
    local sel, err = shell.RunInteractiveShell("cmd.exe /c cat.exe "..target1.." | tr.exe -d '\t' | tr.exe -d ' ' | tr.exe -s '\\n' | awk '{$1=$1};1' | fzf.exe --no-sort --tac  --history='"..config.ConfigDir.."/history/key.fzf' --prompt='> Key ' --color='dark' ", false, true)

    -- Check for selection
    if not sel or sel == ""  then return end
    local msg = sel

    -- Split at " - string.split is an extension
    local t = string.split(sel,'"')
    sel = t[#t-1]

    -- Check for selection
    if not sel or sel == ""  then return end

    -- Trim - string.trim is an extension
    sel = sel:trim()

    -- Run the command message doesn't work as Lua can access the parser
    -- https://github.com/zyedidia/micro/issues/2938

    -- Display the result
    micro.InfoBar():Message(msg)
end
function fzfkeysedit(Current)                       -- Edit key bindings
-- Edit key bindings.json
    local target2 = config.ConfigDir..[[/bindings.json]]
    if io.exists(target2) then
        editor.NewTab(Current,target2)
    end
end
function fzfcmd(Current)                            -- Display/run saved commands
-- Select a command from a saved list
    -- Requires fzf.exe in your path (https://github.com/junegunn/fzf/releases)
    -- Requires cat.exe in your path (http://gnuwin32.sourceforge.net/packages/coreutils.htm)

    -- Locate completions - a list of commands (manual update)
    local target = config.ConfigDir..[[/favorites/commands.txt]]
    if not io.exists(target) then return end

    -- Run fzf (fails if history file does not exist)
    local sel, err = shell.RunInteractiveShell("cmd.exe /c cat.exe "..target.. " | fzf.exe --history='"..config.ConfigDir.."/history/cmd.fzf' --prompt='> ' --color='dark' --tac", false, true)

    -- Check for selection
    if not sel or sel == ""  then return end

    -- Remove variable markers
    sel = sel:gsub("%$","")

    -- Run the command
    editor.DoCommand(Current,sel)

end
function fzfcmdedit(Current)                        -- Edit command list
-- Edit saved command list
    local target = config.ConfigDir..[[/favorites/commands.txt]]
    if io.exists(target) then
        editor.NewTab(Current,target)
    end
end
function fzfopen(Current)                           -- Display/open project+favourite files
-- Use fzf to select and open a file in a new tab
    -- Will search down subdirectories from current location i.e. The project
    local path = pathutils.Dir(Current.Buf.AbsPath)
    local filelist = [[dir /s/b ]]..path..[[\*.* ]]                                 -- Needs dos separators
    filelist = filelist..[[& type ]]..config.ConfigDir..[[\favorites\files.txt ]]   -- Needs dos separators
    filelist = filelist..[[& type ]]..config.ConfigDir..[[\favorites\recent.txt ]]  -- Needs dos separators
    local sel, err = shell.RunInteractiveShell([[cmd.exe /c (]]..filelist..[[) |  cat.exe | sort.exe -T %TEMP% | uniq.exe | fzf.exe --history=']]..config.ConfigDir..[[/history/open.fzf' --prompt='> open '  --color prompt:110 ]], false, true)
    sel = sel:trim()
    if io.exists(sel) then
        editor.NewTab(Current,sel)
    end
end
function fzfopenedit(Current)                       -- Edit favourite files
-- Edit saved list of favourite files
    -- these always appear in the fzfopen list
    local target = config.ConfigDir..[[/favorites/files.txt ]]
    if io.exists(target) then
        editor.NewTab(Current,target)
    end
end
function fzfunique(Current)                         -- Display/complete current word from unique words
-- Complete current word using list from the current file
    -- After https://github.com/wettoast4/micro-editor_wordCompletion/blob/main/wordCompletion.lua
    -- Requires fzf.exe, cat,exe, tr.exe, uniq.exe in your path
    -- Get filename
    local filename = Current.Buf:GetName()
    -- Get primary cursor selection
    local seed = editor.GetWordLeft(Current)

    -- Exit if any control codes
    if seed:match("%c") then
        editor.Insert(Current,seed) -- i.e. Restore
        return true
    end

    -- Run fzf
    local sel, err = shell.RunInteractiveShell("cmd.exe /c cat.exe "..filename..[[ | tr.exe ' ' '\n' | sort.exe -T %TEMP% | uniq.exe -u | fzf.exe --prompt='> complete ' --color prompt:110 --query=']]..seed.."' --color='dark'", false, true)

    -- Check for selection sel
    if not sel or sel == ""  then
        editor.Insert(Current,seed) -- i.e. Restore
        return true
    end

    -- Trim whitespaces
    sel = sel:trim()

    -- Insert
    editor.Insert(Current,sel)      -- i.e Change TODO: for EACH cursor

end
function fzfsnippet(Current)                        -- Display/insert snippet
-- Select and insert file from snippets folder, with preview
    -- Requires fzf.exe and bat.exe in your path (https://github.com/junegunn/fzf/releases)
    -- Requires bat.exe in your path (https://github.com/sharkdp/bat)
    local snipfolder = config.ConfigDir..[[/../snippets]]
    Current.CdCmd(Current,{snipfolder})
    local sel, err = shell.RunInteractiveShell("fzf.exe --history='"..config.ConfigDir.."/history/snip.fzf'  --preview 'bat.exe --style=numbers --color=always --line-range :500 {}' --prompt='> snippet '   --color prompt:110 ", false, true)
    local folder = pathutils.Dir(Current.Buf.AbsPath)
    Current.CdCmd(Current,{folder})

    if not sel or sel=="" then return end
    sel = snipfolder.."/"..sel:trim()
    if io.exists(sel) then
        -- Parsing/evaluating snips would go here - need eval function
        editor.InsertFile(Current,sel)
    end
end
function fzfsnippetedit(Current)                    -- Edit snippet
-- Edit files in snippet folder
    -- Requires fzf.exe and bat.exe in your path (https://github.com/junegunn/fzf/releases)
    -- Requires bat.exe in your path (https://github.com/sharkdp/bat)
    local snipfolder = config.ConfigDir..[[/../snippets]]
    Current.CdCmd(Current,{snipfolder})
    local sel, err = shell.RunInteractiveShell("fzf.exe --history='"..config.ConfigDir.."/history/snip.fzf'  --preview 'bat.exe --style=numbers --color=always --line-range :500 {}' --prompt='> edit snippet '   --color prompt:110 ", false, true)
    local folder = pathutils.Dir(Current.Buf.AbsPath)
    Current.CdCmd(Current,{folder})

    if not sel or sel=="" then return end
    sel = snipfolder.."/"..sel:trim()
    if io.exists(sel) then
        editor.NewTab(Current,sel)
    end
end
function fzfline(Current)                           -- Display/insert line from a saved list - by file type
-- Select and insert line from saved file - by file type
    -- Requires fzf.exe in your path (https://github.com/junegunn/fzf/releases)
    -- Check for unknown file type
    local filetype = Current.Buf:FileType()
    if filetype=="batch" then filetype="bat" end
    if filetype=="markdown" then filetype="md" end
    if filetype=="unknown" then
        -- Check for txt which are reported as unknown
        local mypath, myfile, myext = string.match(Current.Buf.AbsPath, "(.-)([^\\]-([^%.]+))$")
        if myext=="txt" then
            filetype="txt"
        else
            return
        end
    end
    -- Locate completions for file type
    local target = config.ConfigDir..[[/../insertions/api.]]..filetype
    if not io.exists(target) then return end

    -- Get primary cursor selection
    local seed = editor.GetWord(Current) or ""

    -- Exit if any control codes
    if seed:match("%c") then return end

    -- Run fzf
    local sel, err = shell.RunInteractiveShell("cmd.exe /c cat.exe "..target.. " | fzf.exe --history='"..config.ConfigDir.."/history/com.fzf' --prompt='> insert ' --color prompt:110  --query='"..seed.."' --color='dark'", false, true)

    -- Check for selection
    if not sel or sel == ""  then return end

    -- Get comment delimiter
    local commenttype = Current.Buf.Settings["commenttype"]

    -- Comment plugin seems broken
    --  it is not setting Current.Buf.Settings["commenttype"] for known types
    --  (commenttype from settings.json is found)
    if commenttype then
        commenttype = commenttype:match("(.*) %%s")
    else
        commenttype = "--"
    end

    -- Trim comments
    if commenttype=="--"then
        -- Lua comments are magic characters and must be escaped
        -- https://stackoverflow.com/questions/6705872/how-to-escape-a-variable-in-lua
        -- Other magic characters include ( ) % . + - * [ ? ^ $
        sel = sel:match("(.*)%-%-") or sel
    else
        sel = sel:match("(.*)"..commenttype) or sel
    end

    -- Trim whitespaces
    sel = sel:trim()

    -- Insert
    editor.Insert(Current,sel)                      -- TODO: for EACH cursor
end
function fzflineedit(Current)                       -- Edit saved lines
-- Edit saved lines of code for current filetype
    -- Check for unknown file type
    local filetype = Current.Buf:FileType()
    if filetype=="batch" then filetype="bat" end
    if filetype=="markdown" then filetype="md" end
    if filetype=="unknown" then return end

    -- Locate completions for file type
    local target = config.ConfigDir..[[/../insertions/api.]]..filetype
    if not io.exists(target) then return end

    -- Open for editing
    editor.NewTab(Current,target)
end
function fzfinsertfile(Current)                     -- Display/insert file from project
-- Use fzf to select and insert a file from your project
    -- Requires fzf.exe in your path (https://github.com/junegunn/fzf/releases)
    -- Requires bat.exe in your path (https://github.com/sharkdp/bat)
    local projfolder = pathutils.Dir(Current.Buf.AbsPath)
    Current.CdCmd(Current,{projfolder})
    local sel, err = shell.RunInteractiveShell("fzf.exe --history='"..config.ConfigDir.."/history/ins.fzf'   --preview 'bat.exe --style=numbers --color=always --line-range :500 {}' --prompt='> insert '    --color prompt:110", false, true)
    if not sel or sel=="" then return end
    local folder = pathutils.Dir(Current.Buf.AbsPath)
    Current.CdCmd(Current,{folder})

    if not sel or sel=="" then return end
    sel = projfolder.."/"..sel:trim()
    if io.exists(sel) then
        -- Parsing/evaluating templates would go here - need Lua eval function or external parser
        -- Insert template contents
        editor.InsertFile(Current,sel)
    end
end
function fzfinsertfilename(Current)                 -- Display/insert filename from project
-- Use fzf to select and insert a filename from your project
    -- Requires fzf.exe in your path (https://github.com/junegunn/fzf/releases)
    -- Requires bat.exe in your path (https://github.com/sharkdp/bat)
    local projfolder = pathutils.Dir(Current.Buf.AbsPath)
    Current.CdCmd(Current,{projfolder})
    local sel, err = shell.RunInteractiveShell("fzf.exe --history='"..config.ConfigDir.."/history/ins.fzf'   --preview 'bat.exe --style=numbers --color=always --line-range :500 {}' --prompt='> insert filename '    --color prompt:110", false, true)
    if not sel or sel=="" then return end

    sel = projfolder.."\\"..sel:trim()
    if io.exists(sel) then
        -- Insert as text
        editor.Insert(Current,sel)
    end
end
function fzftemplate(Current)                       -- Display/insert template
-- Use fzf to select and insert a file from template folder, with preview
    -- Requires fzf.exe in your path (https://github.com/junegunn/fzf/releases)
    -- Requires bat.exe in your path (https://github.com/sharkdp/bat)
    local temfolder = config.ConfigDir..[[/../templates]]
    Current.CdCmd(Current,{temfolder})
    local sel, err = shell.RunInteractiveShell("fzf.exe --history='"..config.ConfigDir.."/history/tem.fzf'   --preview 'bat.exe --style=numbers --color=always --line-range :500 {}' --prompt='> template '  --color prompt:110", false, true)
    if not sel or sel=="" then return end
    local folder = pathutils.Dir(Current.Buf.AbsPath)
    Current.CdCmd(Current,{folder})

    if not sel or sel=="" then return end
    sel = temfolder.."/"..sel:trim()
    if io.exists(sel) then
        -- Parsing/evaluating templates would go here - need Lua eval function or external parser
        -- Insert template contents
        editor.InsertFile(Current,sel)
    end
end
function fzftemplateedit(Current)                   -- Edit template
-- Use fzf to select and edit a file from template folder
    -- Requires fzf.exe and bat.exe in your path (https://github.com/junegunn/fzf/releases)
    -- Requires bat.exe in your path (https://github.com/sharkdp/bat)
    local temfolder = config.ConfigDir..[[/../templates]]
    Current.CdCmd(Current,{temfolder})
    local sel, err = shell.RunInteractiveShell("fzf.exe --history='"..config.ConfigDir.."/history/tem.fzf'  --preview 'bat.exe --style=numbers --color=always --line-range :500 {}' --prompt='> edit template '   --color prompt:110 ", false, true)
    local folder = pathutils.Dir(Current.Buf.AbsPath)
    Current.CdCmd(Current,{folder})

    if not sel or sel=="" then return end
    sel = temfolder.."/"..sel:trim()
    if io.exists(sel) then
        editor.NewTab(Current,sel)
    end
end
function fzfloadbackup(Current)                     -- Display/open backup from .\zBackup
-- Select and load a backup from .\zBackup
    -- Requires fzf.exe in your path (https://github.com/junegunn/fzf/releases)
    -- Requires bat.exe in your path (https://github.com/sharkdp/bat)
    -- Require xcopy.exe in your path
    local zbackfolder = pathutils.Dir(Current.Buf.AbsPath)..[[\zBackup]]
    if not io.exists(zbackfolder) then return end

    Current.CdCmd(Current,{zbackfolder})
    local file = pathutils.Base(Current.Buf.AbsPath)
    local sel, err = shell.RunInteractiveShell("fzf.exe --history='"..config.ConfigDir.."/history/zback.fzf' --preview 'bat.exe --style=numbers --color=always --line-range :500 {}' --prompt='> versions '  --color prompt:110 --tac --query='"..file.."' ", false, true)
    local path = pathutils.Dir(Current.Buf.AbsPath)
    Current.CdCmd(Current,{path})

    if not sel or sel=="" then return end
    sel = zbackfolder.."\\"..sel:trim()
    if io.exists(sel) then
        editor.NewTab(Current,sel)
    end
end
function fzfexplorebackupfile(Current)              -- Explore backup files, to delete them
-- Explore backup files, to delete them
    local zbackfolder = pathutils.Dir(Current.Buf.AbsPath)..[[\zBackup]]
    if not io.exists(zbackfolder) then return end

    shell.RunCommand("shelexec.exe "..zbackfolder)
end
function fzfgoprev(Current)                         -- Goto previous editing location
-- Goto previous editing location
    -- See onRune function which automatically saves new line numbers
    -- Requires cat.exe in your path (http://gnuwin32.sourceforge.net/packages/coreutils.htm)
    -- Requires fzf.exe in your path (https://github.com/junegunn/fzf/releases)

    -- Convert editor.History to a file
    local list = {}
    for i,v in pairs(editor.History) do
        table.insert(list,i)
    end
    local file = io.open(config.ConfigDir.."/history/lines.fzf","w+")
    file:write(table.concat(list,"\n"))
    file:close()

    -- Load into fuzzyfind
    local filename = config.ConfigDir.."/history/lines.fzf"
    local fzfhistory = config.ConfigDir.."/history/lines.fzf"

    local options =    "--prompt='> GoPrev: ' "         -- User directions
    options = options.."--color prompt:110 "            -- Set prompt color
    options = options.."--no-sort --tac "               -- Display lines in order
    options = options.."--history='"..fzfhistory.."' "  -- Save fzf history (comment out by preference)
    -- Ctrl+p and Ctrl+n to use fzf history

    local sel, err = shell.RunInteractiveShell('cmd.exe /c cat.exe '..filename..' | fzf.exe '..options, false, true)
    if not sel or sel=="" then return end
    local text = string.split(sel,":")
    local filename = text[1]..":"..text[2]
    local linenumber = text[3]:match("%d+")

    -- Check if open                                    -- TODO: Check if open

    -- Check the file still exists, open and goto
    if io.exists(filename) then
        editor.NewTab(Current,filename)
        editor.Goto(micro.CurPane(),linenumber)
    end
end
function fzfgoto(Current)                           -- Goto simple text find
-- Fuzzy search the current file and jump to the selected line
    -- Requires cat.exe in your path (http://gnuwin32.sourceforge.net/packages/coreutils.htm)
    -- Requires fzf.exe in your path (https://github.com/junegunn/fzf/releases)

    local filename = Current.Buf.AbsPath:gsub([[\]],[[/]]) -- fzf needs unix paths
    local seed = editor.GetSelection(Current)
    local fzfhistory = config.ConfigDir.."/history/goto.fzf"
    -- Fails if no history file

    local options =    "--prompt='> Fuzzy goto: ' "     -- User directions
    options = options.."--color prompt:110 "            -- Set prompt color
    options = options.."--no-sort --tac "               -- Display lines in order
    options = options.."--query='"..seed.."' "          -- Use selection if present
    options = options.."--history='"..fzfhistory.."' "  -- Save fzf history (comment out by preference)
    -- Ctrl+p and Ctrl+n to use fzf history
    -- local sel, err = shell.RunInteractiveShell('cmd.exe /c cat.exe -n '..filename..' | fzf.exe '..options, false, true)
    local sel, err = shell.RunInteractiveShell('cmd.exe /c cat.exe -n '..filename..' | fzf.exe '..options, false, true)

    if not sel or sel=="" then return end
    local linenumber = sel:match("%d+")             -- Extract line number (i.e. First match)
    editor.Goto(Current,linenumber)
end
function fzfgotags(Current)                         -- TODO: Jump to CTAGS
end
function maketags(Current)                          -- TODO: Make/refresh TAGS
end
function fzfhelp(Current)                           -- Display/read help files
-- Select and view a help file - from various locations
    -- Requires fzf.exe in your path (https://github.com/junegunn/fzf/releases)
    local filelist = [[dir /s/b/a-d ]]..config.ConfigDir..[[\help\*.md ]]
    filelist = filelist..[[& dir /s/b/a-d  ]]..config.ConfigDir..[[\runtime\help\*.md ]]
    filelist = filelist..[[& dir /s/b/a-d  ]]..config.ConfigDir..[[\..\..\help\*.md ]]
    local sel, err = shell.RunInteractiveShell([[cmd.exe /c (]]..filelist..[[) | cat.exe | fzf.exe --history=']]..config.ConfigDir..[[/history/help.fzf' --prompt='> view help '  --color prompt:110 ]], false, true)
    sel = sel:trim()
    if io.exists(sel) then
        editor.NewTabReadOnly(Current,sel)
    end
end
function fzfhelpedit(Current)                       -- Edit help file
-- Select and edit a help file - from various locations
    -- Requires fzf.exe in your path (https://github.com/junegunn/fzf/releases)
    local filelist = [[dir /s/b/a-d ]]..config.ConfigDir..[[\help\*.md ]]
    filelist = filelist..[[& dir /s/b/a-d  ]]..config.ConfigDir..[[\runtime\help\*.md ]]
    filelist = filelist..[[& dir /s/b/a-d  ]]..config.ConfigDir..[[\..\..\help\*.md ]]
    local sel, err = shell.RunInteractiveShell([[cmd.exe /c (]]..filelist..[[) | cat.exe | fzf.exe --history=']]..config.ConfigDir..[[/history/help.fzf' --prompt='> edit help '  --color prompt:110 ]], false, true)
    sel = sel:trim()
    if io.exists(sel) then
        editor.NewTab(Current,sel)
    end
end
function fzffindinfile(Current)                     -- Goto filtered list of lines
-- Select from a pre-filtered list of lines from current file
    -- Requires fzf.exe in your path (https://github.com/junegunn/fzf/releases)
    -- Requires findstr.exe as this is universal in WindowsTM,
    -- prefix your search with /s for a recursive search
    -- prefix your search with /l for a simple for a literal search
    -- default below is /npi (Line numbers, Path, case Insensitive)
    -- placing string in quotes causes phrase search (non-quoted strings are matched separately "OR")
    -- other grep tools are available :)
    local path = pathutils.Dir(Current.Buf.AbsPath)
    Current.CdCmd(Current,{path})

    local file = pathutils.Base(Current.Buf.AbsPath)

    local prompt = "Find matches: "
    local seed = editor.GetSelection(Current)
    local history = "Find"
    micro.InfoBar():Prompt(prompt, seed, history,
        function(input)
            return
        end,
        function(input, canceled)
            if input and not canceled then
                local fzfhistory = config.ConfigDir.."/history/find.fzf"
                -- Fails if no history file

                local options =    "--prompt='> goto ' "            -- User directions
                options = options.."--color prompt:110 "            -- Set prompt color
                options = options.."--no-sort --tac "               -- Display the file lines inorder
                options = options.."--query='"..seed.."' "          -- Use selection if present
                options = options.."--history='"..fzfhistory.."' "  -- Save fzf history (comment out by preference)

                local sel, err = shell.RunInteractiveShell('cmd.exe /c findstr.exe /npi "'..input..'" '..file..'* | fzf.exe '..options, false, true)
                -- Note the extra * making a glob - forces findstr to prefix with filename
                if not sel or sel=="" then return end
                local linenumber = sel:match("%d+")
                editor.Goto(Current,linenumber)
            end
    end)
end
function fzffindinfileregex(Current)                -- Goto regex filitered lines
-- Select from a regex filtered list of lines from current file
    -- Requires fzf.exe in your path (https://github.com/junegunn/fzf/releases)
    -- Requires findstr.exe as this is universal in WindowsTM,
    -- prefix your search with /s for a recursive search
    -- prefix your search with /l for a simple for a literal search
    -- default below is /npi (Line numbers, Path, case Insensitive)
    -- placing string in quotes causes phrase search ( non-quoted strings are matched separately "OR")
    -- other grep tools are available :)
    local path = pathutils.Dir(Current.Buf.AbsPath)
    Current.CdCmd(Current,{path})

    local file = pathutils.Base(Current.Buf.AbsPath)

    local prompt = "Find matches: "
    local seed = editor.GetSelection(Current)
    local history = "Find"
    micro.InfoBar():Prompt(prompt, seed, history,
        function(input)
            return
        end,
        function(input, canceled)
            if input and not canceled then
                local fzfhistory = config.ConfigDir.."/history/find.fzf"
                -- Fails if no history file

                local options =    "--prompt='> goto ' "            -- User directions
                options = options.."--color prompt:110 "            -- Set prompt color
                options = options.."--no-sort --tac "               -- Display the file lines inorder
                options = options.."--query='"..seed.."' "          -- Use selection if present
                options = options.."--history='"..fzfhistory.."' "  -- Save fzf history (comment out by preference)

                local sel, err = shell.RunInteractiveShell('cmd.exe /c findstr.exe /npir "'..input..'" '..file..'* | fzf.exe '..options, false, true)
                -- Note the extra * making a glob - forces findstr to prefix with filename
                if not sel or sel=="" then return end
                local linenumber = sel:match("%d+")
                editor.Goto(Current,linenumber)
            end
    end)
end
function fzffindinfiles(Current)                    -- Open file containing search term
-- Select from a pre-filtered list of lines from current project
    -- Requires fzf.exe in your path (https://github.com/junegunn/fzf/releases)
    -- Requires findstr.exe as this is universal in WindowsTM,
    -- prefix your search with /s for a recursive search
    -- prefix your search with /l for a simple for a literal search
    -- default below is /npi (Line numbers, Path, case Insensitive)
    -- placing string in quotes causes phrase search ( non-quoted strings are matched separately "OR")
    -- other grep tools are available :)
    local prompt = "Find in Files: "
    local seed =  editor.GetSelection(Current) or ""
    local history = "Find"
    micro.InfoBar():Prompt(prompt, seed, history,
        function(input)
            return
        end,
        function(input, canceled)
            if input and not canceled then
                io.cd(Current)   -- This should avoid long prefixes and problems when paths have spaces :(

                local fzfhistory = config.ConfigDir.."/history/find.fzf"
                -- Fails if no history file

                local options =    "--prompt='> open ' "            -- User directions
                options = options.."--color prompt:110 "            -- Set prompt color
                options = options.."--no-sort --tac "               -- Display the file lines inorder
                options = options.."--query='"..seed.."' "          -- Use selection if present
                options = options.."--history='"..fzfhistory.."' "  -- Save fzf history (comment out by preference)

                local sel, err = shell.RunInteractiveShell('cmd.exe /c findstr /npi "'..input..'" *.* | fzf.exe '..options, false, true)
                if not sel or sel=="" then return end
                local filename = sel:match("([^:]+)")
                local linenumber = sel:match("%d+")
                if linenumber and filename then
                    editor.NewTab(Current,filename)
                    Current = micro.CurPane()
                    Current:GotoCmd({linenumber})
                end
            end
    end)
end
function fzfshell(Current)                          -- Display/run saved shell commands
-- Select and execute saved shell commands
    -- Requires fzf.exe in your path (https://github.com/junegunn/fzf/releases)
    -- Requires cat.exe in your path (http://gnuwin32.sourceforge.net/packages/coreutils.htm)

    -- Locate completions - a list of commands (manual update)
    local target = config.ConfigDir..[[/favorites/shell.txt]]
    if not io.exists(target) then return end

    local options =    "--prompt='$ ' "             -- User directions
    options = options.."--color prompt:110 "        -- Set prompt color
    options = options.."--tac "                     -- Reverse
    options = options.."--history='"..config.ConfigDir.."/history/shell.fzf' "

    -- Run fzf (fails if history file does not exist)
    local sel, err = shell.RunInteractiveShell("cmd.exe /c cat.exe "..target.. " | fzf.exe "..options, false, true)

    -- Check for selection
    if not sel or sel == ""  then return end

    -- Use lua comment delimiter
    commenttype = "--"

    -- Trim comments
    if commenttype=="--"then
        -- Lua comments are magic characters and must be escaped
        -- https://stackoverflow.com/questions/6705872/how-to-escape-a-variable-in-lua
        -- Other magic characters include ( ) % . + - * [ ? ^ $
        sel = sel:match("(.*)%-%-") or sel
    else
        sel = sel:match("(.*)"..commenttype) or sel
    end

    -- Run in the shell
    shell.RunInteractiveShell(sel, true, false)
end
function fzfshelledit(Current)                      -- Edit saved shell commands
-- Edit saved shell commands
    local target = config.ConfigDir..[[/favorites/shell.txt]]
    if not io.exists(target) then return end

    -- Open for editing
    editor.NewTab(Current,target)
end
function fzflua(Current)                            -- Display/run saved Lua commands
-- Select and execute saved Lua commands
    -- Requires fzf.exe in your path  (https://github.com/junegunn/fzf/releases)
    -- Requires cat.exe in your path  (http://gnuwin32.sourceforge.net/packages/coreutils.htm)

    -- Locate completions - a list of commands (manual update)
    local target = config.ConfigDir..[[/favorites/lua.txt]]
    if not io.exists(target) then return end

    local options =    "--prompt='Lua> ' "          -- User directions
    options = options.."--color prompt:110 "        -- Set prompt color
    options = options.."--tac "                     -- Reverse
    options = options.."--history='"..config.ConfigDir.."/history/lua.fzf' "

    -- Run fzf (fails if history file does not exist)
    local sel, err = shell.RunInteractiveShell("cmd.exe /c cat.exe "..target.. " | fzf.exe "..options, false, true)

    -- Check for selection
    if not sel or sel == ""  then return end

    -- Use lua comment delimiter
    commenttype = "--"

    -- Trim comments
    if commenttype=="--"then
        -- Lua comments are magic characters and must be escaped
        -- https://stackoverflow.com/questions/6705872/how-to-escape-a-variable-in-lua
        -- Other magic characters include ( ) % . + - * [ ? ^ $
        sel = sel:match("(.*)%-%-") or sel
    else
        sel = sel:match("(.*)"..commenttype) or sel
    end

    -- Run the code
    local f = loadstring(sel)
    -- Modified print will write to Log
    local r = f()
    -- Write any return to Log
    if r then
        print(tostring(r))
    end

    -- Open the log, it woud be nice to check if its open first
    Current:OpenLogBuf()
end
function fzfluaedit(Current)                        -- Edit saved Lua commands
-- Edit saved Lua commands
    local target = config.ConfigDir..[[/favorites/lua.txt]]
    if not io.exists(target) then return end

    -- Open for editing
    editor.NewTab(Current,target)
end
function fzftextfilter(Current)                     -- Display/run saved textfilter commands
-- Select and execute saved textfilter commands
    -- Requires fzf.exe in your path (https://github.com/junegunn/fzf/releases)
    -- Requires cat.exe in your path (http://gnuwin32.sourceforge.net/packages/coreutils.htm)

    -- Locate completions - a list of commands (manual update)
    local target = config.ConfigDir..[[/favorites/textfilter.txt]]
    if not io.exists(target) then return end

    local options =    "--prompt='> textfilter ' "             -- User directions
    options = options.."--color prompt:110 "        -- Set prompt color
    options = options.."--tac "                     -- Reverse
    options = options.."--history='"..config.ConfigDir.."/history/textfilter.fzf' "

    -- Run fzf (fails if history file does not exist)
    local sel, err = shell.RunInteractiveShell("cmd.exe /c cat.exe "..target.. " | fzf.exe "..options, false, true)

    -- Check for selection
    if not sel or sel == ""  then return end

    -- Use lua comment delimiter
    commenttype = "--"

    -- Trim comments
    if commenttype=="--"then
        -- Lua comments are magic characters and must be escaped
        -- https://stackoverflow.com/questions/6705872/how-to-escape-a-variable-in-lua
        -- Other magic characters include ( ) % . + - * [ ? ^ $
        sel = sel:match("(.*)%-%-") or sel
    else
        sel = sel:match("(.*)"..commenttype) or sel
    end

    -- Run at the command mode prompt
    editor.DoCommand(Current,"textfilter "..sel)
end
function fzftextfilteredit(Current)                 -- Edit saved list of textfilter commands
-- Edit saved textfilter commands
    local target = config.ConfigDir..[[/favorites/textfilter.txt]]
    if not io.exists(target) then return end

    -- Open for editing
    editor.NewTab(Current,target)
end
function fzfmacro(current)                          -- TODO: Run a macro

end
function fzfeditmacro(current)                      -- TODO: Edit a macro

end
function fzfreference(Current)                      -- TODO: Display/insert reference as markdown
-- Select and insert reference from refs folder, with preview
    -- Requires fzf.exe and bat.exe in your path (https://github.com/junegunn/fzf/releases)
    -- Requires bat.exe in your path (https://github.com/sharkdp/bat)
    local reffolder = [[O:/MyProfile/user/citations]]
    Current.CdCmd(Current,{reffolder})
    local sel, err = shell.RunInteractiveShell("fzf.exe --history='"..config.ConfigDir.."/history/ref.fzf'  --preview 'bat.exe -p  --color=always --line-range :500 {}' --prompt='> ref '   --color prompt:110 ", false, true)
    local folder = pathutils.Dir(Current.Buf.AbsPath)
    Current.CdCmd(Current,{folder})

    if not sel or sel=="" then return end
    sel = reffolder.."/"..sel:trim()
    if io.exists(sel) then
        -- Refromatting citations from these files goes here!
        editor.InsertFile(Current,sel)
    end
end
function fzfreferenceedit(Current)                  -- TODO: Edit reference
-- Edit files in citations folder
    -- Requires fzf.exe and bat.exe in your path (https://github.com/junegunn/fzf/releases)
    -- Requires bat.exe in your path (https://github.com/sharkdp/bat)
    local reffolder = [[O:/MyProfile/user/citations]]
    Current.CdCmd(Current,{reffolder})
    local sel, err = shell.RunInteractiveShell("fzf.exe --history='"..config.ConfigDir.."/history/ref.fzf'  --preview 'bat.exe -p --color=always --line-range :500 {}' --prompt='> edit ref '   --color prompt:110 ", false, true)
    local folder = pathutils.Dir(Current.Buf.AbsPath)
    Current.CdCmd(Current,{folder})

    if not sel or sel=="" then return end
    sel = reffolder.."/"..sel:trim()
    if io.exists(sel) then
        editor.NewTab(Current,sel)
    end
end
function fzfswitchbuffer(Current)                   -- Switch windows
-- Seleect and switch to another open tab
    -- Requires fzf.exe in your path (https://github.com/junegunn/fzf/releases)
    local tabs = micro.Tabs()
    if #tabs.List < 2 then return end
    local sel = fzf(table.concat(editor.Panes(Current),"\n")," --tac --prompt='> switch '")
    if not sel or sel=="" then return end
    Current.TabSwitchCmd(Current,{ sel:match("^%d+") })
    local path = pathutils.Dir(Current.Buf.AbsPath)
    Current.CdCmd(Current,{path})
--  How to set focus to the nth pane of a tab ? sel:match("^%d+%.%d+"):match("%d+$")
end
function fzfdiff(Current)                           -- Select a diff to compare
-- Select a diff to compare from anywhere
    -- Requires openfilebox.exe in your path (https://www.robvanderwoude.com/dialogboxes.php#OpenFileBox)
    -- Requires TextDiff.exe in your path (http://www.angusj.com/delphi/textdiff.html
    io.cd(Current)
    local filename = shell.RunCommand([[openfilebox.exe "*.*" "." "Diff File"]])
    filename = filename:trim()

    if io.exists(filename) then
        shell.RunCommand('TextDiff.exe '..Current.Buf.AbsPath..' '..filename)
    end
end
function fzfexplorediff(Current)                    -- Explore to find or delete backup files
-- Explore to find or delete backup files
    -- Requires shelexec.exe in your path (http://www.naughter.com/shelexe.h
    local zdifffolder = pathutils.Dir(Current.Buf.AbsPath)..[[\zBackup]]
    if not io.exists(zdifffolder) then return end
    shell.RunCommand("shelexec.exe "..zdifffolder)
end

-------------------------------------------------
--- **Dialog boxes** - to access arbitrary folders
-------------------------------------------------
function openfiledlg(Current)
-- Requires openfilebox.exe in your path (https://www.robvanderwoude.com/dialogboxes.php#OpenFileBox)
    io.cd(Current)
    local filename = shell.RunCommand([[openfilebox.exe "*.*" "." "Open File"]])
    filename = filename:trim()

    if io.exists(filename) then
        editor.NewTab(Current,filename)
    end
end
function insertfiledlg(Current)
-- Requires openfilebox.exe in your path (https://www.robvanderwoude.com/dialogboxes.php#OpenFileBox)
    io.cd(Current)

    local sel = shell.RunCommand([[openfilebox.exe "*.*" "." "Insert File"]])
    sel = sel:trim()

    if io.exists(sel) then
        editor.InsertFile(Current,sel)
    end
end
function saveselectiondlg(Current)                  -- Not called
-- Requires SaveFileBox.exe in your path (https://www.robvanderwoude.com/dialogboxes.php#SaveFileBox)
    if not editor.HasSelection(Current) then return end

    io.cd(Current)

    local sel = shell.RunCommand([[SaveFileBox.exe "*.*" "." "Selection Save As.."]])
    sel = sel:trim()
    if not sel or sel=="" then return end

    local file = io.open(sel, "w+") -- This is Lua
    file:write(editor.GetSelection(Current))
    file:close()

    micro.InfoBar():Message("Selection saved @ "..sel)
end
function filesaveasdlg(Current)
-- Requires saveFileBox in your path (https://www.robvanderwoude.com/dialogboxes.php#SaveFileBox)
    io.cd(Current)

    local sel = shell.RunCommand([[SaveFileBox.exe "*.*" "." "File Save As.."]])
    sel = sel:trim()

    if not sel or sel=="" then return end
    -- Write the file
    editor.DoCommand(Current, "save \""..sel.."\"")
end
function replaceinfilesdlg(Current)
-- Requires GrepWin.exe in your path, I'm using Version 1.6.1.519 (https://tools.stefankueng.com/grepWin_cmd.html)
    -- This utility is unique in accepting multiple command line parameters
    editor.Save(Current)

    -- Variables
    local path = io.filepath(Current.Buf.AbsPath) or "."
    local filemask = "*.*"
    local seed = editor.GetSelection(Current) or ""
    shell.RunCommand("GrepWin.exe /portable /searchpath:"..path.." /filemask:"..filemask.."  /searchfor:"..seed.." /size:-1 /s:yes /h:yes,")

    editor.Reopen(Current)
end
function spellCheckdlg(Current)
-- Requires Hunspell.exe in a set location, with dictionaries in a set location. (https://sourceforge.net/projects/ezwinports/files/hunspell-1.3.2-3-w32-bin.zip)
    local filetype = Current.Buf:FileType()
    if not filetype then
        -- Need a file on disc to spell check
        -- Insist upon a filetype!
        return
    else
        -- Save the file os the disc image is current
        editor.Save(Current)
    end

    local hunspellpath = config.ConfigDir..[[\..\hunspell\]]
    if filetype=="html" then
        local SpellCommand = [[@hunspell.exe -H -d @en_GB,@en_med_glut -p @USER_DICT.dic ]]
        SpellCommand = SpellCommand:gsub("@",hunspellpath)
        shell.RunInteractiveShell(SpellCommand..Current.Buf.AbsPath, true, false)
    else
        local SpellCommand = [[@hunspell.exe -d @en_GB,@en_med_glut -p @USER_DICT.dic ]]
        SpellCommand = SpellCommand:gsub("@",hunspellpath)
        shell.RunInteractiveShell(SpellCommand..Current.Buf.AbsPath, true, false)
    end
    -- After e(X)iting Hunspell.exe you will be prompted to reload the new file
end

---------------------
--- **init function**
---------------------
function init()
    -- Check paths
    local p = os.getenv("PATH")
    if not string.match(p,[[MyProfile]]) then
        p = p .. [[O:\MyProfile;O:\MyProfile\bat;O:\MyProfile\cmd;O:\MyProfile\editor;]]
        os.setenv("PATH",p)
    end

    -- Set console colours in Windows console
    -- shell.RunInteractiveShell([[colortool.exe -q O:\MyProfile\editor\confMicro\colours.ini]])

    -- Load History
    editor.LoadHistory()

    -- Make commands
    config.MakeCommand("ahk", editAHK, config.NoComplete)
    config.MakeCommand("cheat", cheat, config.NoComplete)
    config.MakeCommand("join", joinlines, config.NoComplete)
    config.MakeCommand("pwd", pwd, config.NoComplete)
    config.MakeCommand("tolower", tolower, config.NoComplete)
    config.MakeCommand("toupper", toupper, config.NoComplete)
    config.MakeCommand("wc", wordcount, config.NoComplete)

    -- Add help files
    -- Not sure why this one need declaring, others placed in the help folder appear by magic!
    config.AddRuntimeFile("keys", config.RTHelp, "help/keys.md")

    -- Make linters
        -- linter.makeLinter("luacheck", "lua", "luacheck", {"--no-color -qq", "%f"}, "%f:%l:%c: %m")
        -- linter.makeLinter("eslint", "javascript", "eslint",{"-f","compact","%f"}, "%f: line %l, col %c, %m")

    -- Lua environment - not sure why this has to be called from elsewhere!!
    -- lua.lua is just a copy of the ***Lua extensions*** above
    dofile(config.ConfigDir.."\\lua.lua")

    -- msgbox("All compiled")
end


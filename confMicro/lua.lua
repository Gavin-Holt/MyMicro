-- Environment for internal Lua calls
-- see init.lua:init()

-- **Load the Go code** avoid these reserved namespaces
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

-- **A few Lua extensions made with gopherLua libraries**
function print(...)
    local text = {...}
    for i,v in pairs(text) do
        text[i] = tostring(v)
    end
    local text = table.concat(text,"\t")
    buffer.Log(tostring(text).."\n")
end
function string.trim(s)
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
    return text:gsub("^.",left.."%1"):gsub(".$","%1"..right)
end
function table.stash(t,level,output)
-- My recursive serialization function from extensions.lua
--    with great help from http://lua-users.org/lists/lua-l/2009-11/msg00533.html
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
                                                    -- TODO: Process both separators
                                                    -- TODO: and relative paths
-- Serialize to file , dependent upon table.stash()
    if type(t)~="table" then
        return "Error not a table: "..tostring(t)
    end

    -- Serialize
    local t = table.stash(t)

    -- Write to disc
    local f = io.open(filename,"w")
    f:write(t)
    f:flush()
    f:close()
end

-- **External Commands**
-- DON'T USE EXTERNAL COMMANDS - I guess spawn is missing!

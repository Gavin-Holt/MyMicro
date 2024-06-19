# Introduction

There does not seem to be a simple introduction to using Lua in micro.
Coming to GoLua from regular Lua/LuaJIT there are some significant differences:

* There are some "extra" functions.
* Go libraries are imported to extend the Lua environment.
* There is no eval function!
* Don't use os.execute(), it kills the mouse
* You cannot load binary libraries.
* [See source](https://github.com/yuin/gopher-lua#differences-between-lua-and-gopherlua)

## Lua Environment

ver:

    _VERSION=Lua 5.1
    _GOPHER_LUA_VERSION=GopherLua 0.1

package.path:

    .\?.lua
    <exe>\lua\?.lua
    <exe>\lua\?\init.lua
    %LUA_PATH%lua\lua\?.lua
    %LUA_PATH%lua\lua\?\init.lua 5

package.cpath: BLANK

init.lua:

    The init.lua file is automatically called when the application loads.
    Any errors will crash micro.exe!
    Upgrading may overwrite this file!
    I would recommend requiring to Lua files, rather than adding much code to the init file.

## Standard Lua functions

excluded:
    dostring

included:
    Everything else

## Additional Lua functions

import([exposed_go_library])
    Returns a userdata blob with all the library contents. Not iterable using Lua.

curbuf()
    Returns an handle to the current buffer pane. Not iterable using Lua.

## Micro API

local micro = import("micro"):

    micro.CurPane()
    micro.CurTab()
    micro.InfoBar()
    micro.Lock=userdata
    micro.Log()
    micro.SetStatusInfoFn()
    micro.Tabs()
    micro.TermError()
    micro.TermMessage()

local config = import("micro/config"):

    config.AddRuntimeFile()
    config.AddRuntimeFileFromMemory()
    config.AddRuntimeFilesFromDirectory()
    config.ConfigDir=string
    config.FileComplete()
    config.GetGlobalOption()
    config.HelpComplete()
    config.ListRuntimeFiles()
    config.MakeCommand()
    config.NewRTFiletype()
    config.OptionComplete()
    config.OptionValueComplete()
    config.RTColorscheme=number
    config.RTHelp=number
    config.RTPlugin=number
    config.RTSyntax=number
    config.ReadRuntimeFile()
    config.RegisterCommonOption()
    config.RegisterGlobalOption()
    config.Reload()
    config.SetGlobalOption()
    config.SetGlobalOptionNative()
    config.TryBindKey()

local buffer = import("micro/buffer"):

    buffer.BTDefault=number
    buffer.BTHelp=number
    buffer.BTInfo=number
    buffer.BTLog=number
    buffer.BTRaw=number
    buffer.BTScratch=number
    buffer.ByteOffset()
    buffer.Loc()
    buffer.Log()
    buffer.LogBuf()
    buffer.MTError=number
    buffer.MTInfo=number
    buffer.MTWarning=number
    buffer.NewBuffer()
    buffer.NewBufferFromFile()
    buffer.NewMessage()
    buffer.NewMessageAtLine()

local shell = import("micro/shell"):

    shell.ExecCommand()
    shell.JobSend()
    shell.JobSpawn()
    shell.JobStart()
    shell.JobStop()
    shell.RunBackgroundShell()
    shell.RunCommand()
    shell.RunInteractiveShell()
    shell.RunTermEmulator()
    shell.TermEmuSupported=boolean

## Imported Go code

This is the power of micro! Nearly all functions from these packages are supported. For an exact list of which functions are supported you can look through:

P:\MyPrograms\EDITORS\micro\src\micro-master\internal\lua\lua.go

libraries:

    archive/zip
    bytes
    errors
    fmt
    io
    io/ioutil
    math
    math/rand
    net
    net/http
    os
    path
    path/filepath
    regexp
    runtime
    strings
    sync
    time
    unicode/utf8

    humanize

## Event call backs

* `init()`: this function should be used for your plugin initialization.
This function is called after buffers have been initialized.

* `preinit()`: initialization function called before buffers have been
initialized.

* `postinit()`: initialization function called after `init()`.

* `onBufferOpen(buf)`: runs when a buffer is opened. The input contains
the buffer object.

* `onBufPaneOpen(bufpane)`: runs when a bufpane is opened. The input
contains the bufpane object.

* `onAction(bufpane)`: runs when `Action` is triggered by the user, where
`Action` is a bindable action (see `> help keybindings`). A bufpane
is passed as input and the function should return a boolean defining
whether the view should be relocated after this action is performed.

* `preAction(bufpane)`: runs immediately before `Action` is triggered
by the user. Returns a boolean which defines whether the action should
be cancelled.

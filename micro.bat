@echo off
REM Run Micro as a portable application from terminal

REM Set Lua path to use pure Lua libraries
set LUA_PATH=;;O:\MyProfile\lua\lua\?.lua;O:\MyProfile\lua\lua\?\init.lua         >nul 2>nul

REM Launch micro.ahk
start autohotkey.exe micro.ahk

REM Make VERSION.txt
micro.exe -version > VERSION.txt
ver >> VERSION.txt

REM Launch Micro with a title "Micro.exe" and use local config directory
start  "micro.exe" /MAX  %~dp0micro.exe --config-dir %~dp0confMicro %*
cls

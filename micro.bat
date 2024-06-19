@echo off
REM Run Micro as a portable application from terminal
REM See autohotkey for extra keyboard reassignment

REM Set Lua path
set LUA_PATH=;;O:\MyProfile\lua\lua\?.lua;O:\MyProfile\lua\lua\?\init.lua         >nul 2>nul

start  "micro.exe" /MAX  %~dp0micro.exe --config-dir %~dp0confMicro %*
cls

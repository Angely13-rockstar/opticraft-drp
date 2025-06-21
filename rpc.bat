@echo off

if not defined minimized (
    set minimized=1
    start /min "" "%~f0"
    exit /b
)

set NODE_SCRIPT="C:\Users\angely\Documents\Minecraft Launcher\rpc.js"

start /B node %NODE_SCRIPT%

:monitor
tasklist /FI "IMAGENAME eq OptiCraft.exe" 2>NUL | find /I /N "OptiCraft.exe">NUL
if %ERRORLEVEL% equ 0 (
    timeout /t 1 >NUL 
    goto monitor
)

taskkill /F /IM node.exe >NUL 2>&1
exit
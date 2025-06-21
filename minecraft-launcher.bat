@echo off
title Minecraft Launcher
color 0a
mode con: cols=80 lines=30

:main
cls
echo ********************************************
echo *        MINECRAFT LAUNCHER CMD           *
echo ********************************************
echo.
echo Versiones disponibles en C:\Program Files (x86)\Minecraft Launcher\version:
echo.

setlocal enabledelayedexpansion

set "base_dir=C:\Users\angely\Documents\Minecraft Launcher\version"  // EDITAR Y CAMBIAR RUTA AQUI NO MODIFICAR ALGO MAS PUEDE BUGEARSE
set count=0

REM Listar versiones disponibles
for /d %%i in ("%base_dir%\*") do (
    set /a count+=1
    set "ver[!count!]=%%~nxi"
    echo [!count!] %%~nxi
)

echo.
set /p "choice=Elija una version (1-%count%): "

REM Validar entrada
if "%choice%"=="" goto main
if %choice% lss 1 goto main
if %choice% gtr %count% goto main

set "selected_ver=!ver[%choice%]!"
set "exe_path=%base_dir%\!selected_ver!\OptiCraft.exe"

REM Verificar si existe el ejecutable
if not exist "%exe_path%" (
    echo.
    echo Error: No se encontro OptiCraft.exe en la version !selected_ver!
    pause
    goto main
)

:launch
cls
echo Iniciando Minecraft !selected_ver!...
echo Ejecutable: %exe_path%
echo.

REM --- Guardar la versión seleccionada para el RPC ---
echo !selected_ver! > "%TEMP%\mc_version.txt"

REM --- Iniciar Discord RPC (minimizado) ---
start /min "" "C:\Users\angely\Documents\Minecraft Launcher\rpc.bat"

REM --- Iniciar Minecraft ---
start "" "%exe_path%"

REM --- Monitorear proceso de Minecraft ---
:monitor
timeout /t 2 /nobreak >nul

REM Obtener información del proceso
set fps=0
set engine=RenderDragon

for /f "tokens=6 delims= " %%p in ('tasklist /fi "imagename eq OptiCraft.exe" /fo table /nh') do (
    if "%%p" neq "0" (
        set mem_usage=%%p
    )
)

REM Mostrar información de rendimiento
cls
echo ********************************************
echo *      INFORMACION DE RENDIMIENTO          *
echo ********************************************
echo.
echo Version: !selected_ver!
echo.

REM Calcular tiempo transcurrido
for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value') do set "current_time=%%a"
set /a start_secs=1%start_time:~8,2%-100 + (1%start_time:~10,2%-100)*60 + (1%start_time:~6,2%-100)*3600
set /a current_secs=1%current_time:~8,2%-100 + (1%current_time:~10,2%-100)*60 + (1%current_time:~6,2%-100)*3600
set /a elapsed_secs=current_secs - start_secs
set /a elapsed_h=elapsed_secs/3600
set /a elapsed_m=(elapsed_secs%%3600)/60
set /a elapsed_s=elapsed_secs%%60

echo Tiempo de uso: !elapsed_h!:!elapsed_m!:!elapsed_s!
echo FPS aproximados: !fps!
echo Motor grafico: !engine!
echo Uso de memoria: !mem_usage! KB
echo.
echo Presione Ctrl+C para salir del monitoreo

REM Verificar si Minecraft sigue en ejecución
tasklist /fi "imagename eq OptiCraft.exe" | find "OptiCraft.exe" >nul
if %errorlevel% equ 0 (
    timeout /t 1 /nobreak >nul
    goto monitor
) else (
    echo.
    echo Minecraft se ha cerrado.
    REM --- Cerrar el RPC automáticamente ---
    taskkill /f /im "node.exe" >nul 2>&1
    pause
    goto main
)
@echo off
rem Removes WriteNow from this computer. Double-click this file.
title Removing WriteNow
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0uninstall.ps1"
echo.
pause

@echo off
rem Installs WriteNow for this user. Double-click this file.
rem Runs install.ps1 with permission for this one run only; no settings are changed.
title Installing WriteNow
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"
if errorlevel 1 (
  echo.
  echo Something went wrong. Please report the message above at
  echo https://github.com/jeltevanschelven8-afk/writenow/issues
)
echo.
pause

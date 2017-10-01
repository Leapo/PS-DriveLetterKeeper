@ECHO OFF
:: PowerShell Script Launcher (with permissions check). Requires elevation.

SET TestFile=%windir%\AdminCheck%RANDOM%.txt
ECHO Checking write permissions > %TestFile%
IF NOT EXIST %TestFile% (
	EXIT
)
DEL /F %TestFile%

CD %~dp0
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '%~dpn0.ps1'"
EXIT

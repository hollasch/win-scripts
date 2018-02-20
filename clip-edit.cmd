@echo off & setlocal

echo Invoking editor for clipboard.

if not defined EDITOR set EDITOR=notepad.exe

call get-tempFile tempFileName

copy nul %tempFileName% >nul 
call "%EDITOR%" %tempFileName% || (
    echo get-edit.cmd: Unable to invoke "%EDITOR%". Check EDITOR environment variable. 1>&2
    exit /b 1
)

clip < %tempFileName%
del %tempFileName%

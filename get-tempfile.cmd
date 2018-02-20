@echo off 

goto :start
:help
    echo.get-tempfile - Creates a temporary file name for command scripts
    echo.
    echo.Usage: get-tempfile [-h] ^<environment_variable_name^>
    echo.
    echo.  -h   Print help and exit
    echo.
    echo.Creates a temporary file (or directory) name, and sets the given environment
    echo.variable to that name. If no arguments are given, then the temporary file name
    echo.is printed to stdout.
    goto :eof


:start
REM // Check for help option

if x%1x equ xx goto :attempt
if    x%1x equ x-?x (call :help & goto :eof)
if    x%1x equ x/?x (call :help & goto :eof)
if /i x%1x equ x-hx (call :help & goto :eof)
if /i x%1x equ x/hx (call :help & goto :eof)

:attempt
for /f "delims=" %%g in ('powershell -command "[string][guid]::NewGuid()"') do (
    set __get_tempname__=%temp%\%%g
)

if x%1x equ xx (
    echo %__get_tempname__%
) else (
    set %1=%__get_tempname__%
)

set __get_tempname__=

exit /b 0

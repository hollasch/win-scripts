@echo off 

goto :start
:help
    echo.get-tempdir - Creates a temporary directory for command scripts
    echo.
    echo.Usage: get-tempdir [-h] ^<environment_variable_name^>
    echo.
    echo.  -h   Print help and exit
    echo.
    echo.Determines non-existent temporary directory, and sets the given environment
    echo.variable to that directory name. If no arguments are given, then the temporary
    echo.directory name is echoed to stdout.
    goto :eof


:start
REM == Check for help option

if x%1x equ xx goto :attempt
if    x%1x equ x-?x (call :help & goto :eof)
if    x%1x equ x/?x (call :help & goto :eof)
if /i x%1x equ x-hx (call :help & goto :eof)
if /i x%1x equ x/hx (call :help & goto :eof)

:attempt
for /f "delims=" %%g in ('powershell -command "[string][guid]::NewGuid()"') do (
    set __get_tempdir__=%temp%\%%g
)

mkdir %__get_tempdir__% || goto :attempt

if x%1x equ xx (
    echo %__get_tempdir__%
) else (
    set %1=%__get_tempdir__%
)

set __get_tempdir__=

exit /b 0

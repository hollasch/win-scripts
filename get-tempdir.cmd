@echo off
REM -- Create a temporary directory for command scripts
REM -- 
REM -- Usage: get-tempdir <environment_variable_name>
REM --
REM -- Determines non-existent temporary directory, and sets the given
REM -- environment variable to that directory name.

if x%1x equ xx (
    echo get-tempdir: Specify target environment variable to set with temporary directory name.
    exit /b 1
)

:attempt
for /f "delims=" %%g in ('powershell -command "[string][guid]::NewGuid()"') do (
    set __get_tempdir__=%temp%\%%g
)

mkdir %__get_tempdir__% || goto :attempt
set %1=%__get_tempdir__%
set __get_tempdir__=

exit /b 0

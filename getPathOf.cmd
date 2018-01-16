@echo off
@REM -- See help text at bottom for overview.

if    "%~1" equ "/?" goto :help
if /i "%~1" equ "/h" goto :help
if /i "%~1" equ "-h" goto :help

@REM -- Handle the case where a target variable name is supplied. In this case, set the given
@REM -- variable to the resulting path.

if "%~2" neq "" (
    for /f "delims=" %%p in ('call getPathOf "%~1"') do (
        set "%~2=%%p"
        goto :eof
    )
    goto :eof
)

@REM -- Handle the case where the result is to be printed to standard output (no target variable).

for /f "delims=" %%f in ('where "%~1"') do (
    @REM -- Use the base name of the first result from the 'where' command.
    setlocal EnableDelayedExpansion
        set basename=%%~dpf
        @REM -- Trim the trailing slash from the path.
        echo !basename:~0,-1!
    endlocal
    exit /b 0
)

exit /b 1


:help
    echo.getPathOf: Print or set the base path of the given executable.
    echo.Usage    : getPathOf ^<executableName^> [^<targetVariableName^>]
    echo.
    echo.Given an executable name, this command finds the path of the first instance of
    echo.that executable using the current path list.
    echo.
    echo.If no target variable name is supplied, the result is printed.
    echo.
    echo.If a target variable name is supplied, then the named variable is set to the
    echo.resulting path.
    goto :eof

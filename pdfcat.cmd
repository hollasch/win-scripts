@setlocal enabledelayedexpansion && echo off

@REM // This tool uses gs (GhostScript) to concatenate an arbitrary number of
@REM // PDF files into a single output. Run `pdfcat --help` for usage.

if "%1" equ ""          goto :help
if /i "%1" equ "/h"     goto :help
if /i "%1" equ "/help"  goto :help
if /i "%1" equ "-h"     goto :help
if /i "%1" equ "-help"  goto :help
if /i "%1" equ "--help" goto :help

where gs 2>nul
if %errorlevel% gtr 0 (
    echo.ERROR: Required tool `gs` is unavailable. 1>&2
    echo. 1>&2
    goto :help
)

set output=%1
set output=%output:.pdf=%.pdf
shift

:gather_sources
    if "%1" equ "" goto :gather_end
    set _glob=
    for /f "delims=" %%g in ('dir /b %1') do (
        set _glob=!_glob! %%g
    )
    set sources=%sources%%_glob%
    shift
    goto :gather_sources
:gather_end
set _glob=

if "%sources%" equ "" (
    echo 1>&2ERROR: No source files specified.
    echo. 1>&2 
    goto :help
)

call gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOUTPUTFILE=%output% %sources%
exit /b 0


:help
echo.pdfcat: Concatenate multiple PDF files into one
echo.Usage:  pdfcat ^<outputName^> ^<input1^> [input2] [input3] ...
echo.
echo.This tool uses GhostScript to do the work, so you need to have `gs` available on
echo.your path to be able to run this.

@setlocal enabledelayedexpansion && echo off

@REM // This tool uses gs (GhostScript) to concatenate an arbitrary number of
@REM // PDF files into a single output. Run `pdfcat --help` for usage.


@REM // Ensure that the `gs` tool is somewhere on the path.
where gs 1>nul 2>nul
if %errorlevel% gtr 0 (
    echo.ERROR: Required tool `gs` is unavailable. 1>&2
    echo. 1>&2
    goto :help
)

set output=
set sources=
set batchOption=-dBATCH

@REM // Scan through all command-line arguments.
:scan_args
    if "%1" equ "" goto :args_end

    if /i "%1" equ "/h"       goto :help
    if /i "%1" equ "/help"    goto :help
    if /i "%1" equ "-h"       goto :help
    if /i "%1" equ "-help"    goto :help
    if /i "%1" equ "--help"   goto :help

    if /i "%1" equ "--remain" (
        set "batchOption= "
    ) else if not defined output (
        set output=%1
        set output=!output:.pdf=!.pdf
    ) else (
        set glob=
        for /f "delims=" %%g in ('dir /b /on %1') do (
            set glob=!glob! %%g
        )
        set sources=!sources!!glob!
    )

    shift
    goto :scan_args
:args_end

if not defined output goto :help

if not defined sources (
    echo 1>&2ERROR: No source files specified.
    echo. 1>&2 
    goto :help
)

call gs -dNOPAUSE %batchOption% -sDEVICE=pdfwrite -sOUTPUTFILE=%output% %sources%
exit /b 0


:help
echo.pdfcat: Concatenate multiple PDF files into one
echo.Usage:  pdfcat [--remain] ^<outputName^> ^<input1^> [input2] [input3] ...
echo.
echo.This tool uses GhostScript to do the work, so you need to have `gs` available on
echo.your path to be able to run this.
echo.
echo.--remain
echo.    Leave GhostScript window up to review all job output. Type 'quit' to close window.

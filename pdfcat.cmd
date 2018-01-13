@setlocal enabledelayedexpansion && echo off

@REM // This tool uses gs (GhostScript) to concatenate an arbitrary number of
@REM // PDF files into a single output. Run `pdfcat --help` for usage.


@REM // Ensure that the `gs` tool is somewhere on the path.
where gs 1>nul 2>nul
if %errorlevel% equ 0 (
    set gsTool=gs
) else (
    @REM // If no `gs` tool is found, search in standard locations for GhostScript.

    if not exist "%ProgramFiles%\gs" (
        echo.ERROR: Could not find an installation of GhostScript. To run this tool, 1>&2
        echo.       download GhostScript from https://www.ghostscript.com. 1>&2
        echo. 1>&2
    )

    pushd "%ProgramFiles%\gs"
        set gsTool=echo No ghostscript found. Arguments:
        for /f "delims=" %%f in ('dir/b gs*') do (
            if exist "%ProgramFiles%\gs\%%f\bin\gswin64.exe" (
                set gsTool="%ProgramFiles%\gs\%%f\bin\gswin64.exe"
            ) else if exist "%ProgramFiles%\gs\%%f\bin\gswin32.exe" (
                set gsTool="%ProgramFiles%\gs\%%f\bin\gswin32.exe"
            ) else (
                REM -- No-Op
            )
        )
    popd
)

set output=
set sources=
set batchOption=-dBATCH

@REM // Scan through all command-line arguments.
:scan_args
    set arg="%~1"

    if %arg% equ "" goto :args_end

    if /i %arg% equ "/h"       goto :help
    if /i %arg% equ "/help"    goto :help
    if /i %arg% equ "-h"       goto :help
    if /i %arg% equ "-help"    goto :help
    if /i %arg% equ "--help"   goto :help

    if /i %arg% equ "--remain" (
        set "batchOption= "
    ) else if not defined output (
        set output=%~1
        set output="!output:.pdf=!.pdf"
    ) else (
        set glob=
        for /f "delims=" %%g in ('dir /b /on %arg%') do (
            set glob=!glob! "%%g"
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

call %gsTool% -dNOPAUSE %batchOption% -sDEVICE=pdfwrite -sOUTPUTFILE=%output% %sources%
exit /b 0


:help
echo.pdfcat: Concatenate multiple PDF files into one
echo.Usage:  pdfcat [--remain] ^<outputName^> ^<input1^> [input2] [input3] ...
echo.
echo.This tool uses GhostScript to do the work, so you need to have it installed.
echo.You can download GhostScript from https://www.ghostscript.com.
echo.
echo.--remain
echo.    Leave GhostScript window up to review all job output. Type 'quit' to close window.

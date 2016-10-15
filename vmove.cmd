@setlocal enabledelayedexpansion && echo off

REM // vmove
REM // 
REM // Batch file/directory moving/renaming from editor.
REM // 
REM // Usage: vmove [-n] [-f] [glob] ...
REM // 
REM // This command uses the EDITOR environment variable to launch the user's
REM // preferred editor.

call get-tempdir tempDir

REM // Process arguments

set noExecute=0
set forceClobber=0
set showHelp=0
set sourceGlobs=

:argLoop
if "%1" equ "" goto :labelArgsDone
    set arg=%1
    set arg=%arg:/=-%

    if /I "%arg%" equ "-n" (
        set noExecute=1
    ) else if /I "%arg%" equ "-f" (
        set forceClobber=1
    ) else if /I "%arg%" equ "-?" (
        set showHelp=1
    ) else if /I "%arg%" equ "-h" (
        set showHelp=1
    ) else (
        set sourceGlobs=%sourceGlobs% "%~1%"
    )

    shift
    goto :argLoop

:labelArgsDone


if %showHelp% neq 0 (
    echo.vmove: Batch file move / rename
    echo.Usage: vmove [-n] [-f] [-?] [glob] ...
    echo.
    echo.This command creates an editing session on the named file globs. Rename ^(or
    echo.move^) the files in the editor, and then save and exit. At that point, vmove will
    echo.perform the moves from the old name to the new name.
    echo. 
    echo.Options:
    echo.   -n   No execute. If this option is specified, the command will display a
    echo.        list of the actions it would take, but will not actually perform them.
    echo.
    echo.   -f   Force clobber files. If you move a file to an existing file, then the
    echo.        moved file will clobber the existing one.
    echo.
    echo.   -?   Show help information
    exit /b 0
)

REM // Create move file for editing

for /f "delims=" %%f in ('dir/b %sourceGlobs%') do (
    echo>>%tempDir%\moves.txt "%%f" ^(from "%%f"^)
)

if not defined editor set editor=notepad.exe

%editor% %tempDir%\moves.txt


if %forceClobber% equ 0 (
    set clobberOption=/-Y
) else (
    set clobberOption=/Y
)

REM // Loop through the lines in the move file 

for /f "delims=( tokens=1,2" %%f in (%tempDir%\moves.txt) do (
    set dest=%%f
    set src=%%g

    set src=!src:from =!
    set src=!src:~0,-1!
    set dest=!dest:~0,-1!

    if !src! neq !dest! (
        set moveCommand=move %clobberOption% !src! !dest!
        echo !moveCommand!
        if %noExecute% equ 0 (!moveCommand!)
    )
)

rmdir /s /q %tempDir%

goto :eof

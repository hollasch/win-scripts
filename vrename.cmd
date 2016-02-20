@setlocal enabledelayedexpansion && echo off

REM // vrename
REM // 
REM // Batch file/directory renaming from editor.
REM // 
REM // Usage: vrename [glob] ...
REM // 
REM // This command uses the EDITOR environment variable to launch the user's
REM // preferred editor.

call get-tempdir tempDir

for /f "delims=" %%f in ('dir/b %*') do (
    echo>>%tempDir%\renames.txt "%%f" ^(from "%%f"^)
)

%editor% %tempDir%\renames.txt

for /f "delims=( tokens=1,2" %%f in (%tempDir%\renames.txt) do (
    set dest=%%f
    set src=%%g

    set src=!src:from =!
    set src=!src:~0,-1!
    set dest=!dest:~0,-1!

    if !src! neq !dest! (
        @echo on
        rename !src! !dest!
        @echo off
    )
)

rmdir /s /q %tempDir%

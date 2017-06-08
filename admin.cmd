@setlocal & echo off
@REM // ============================================================================================
@REM // admin.cmd -- Administrator launch script
@REM // 
@REM //     This script checks the current permission level of the invoking shell. If it currently
@REM //     has administrator privilege, it executes the command given on the remainder of the
@REM //     command line. If the current shell does not have administrator privilege, it launches
@REM //     a new administrator shell, and then executes the command.
@REM // 
@REM // ============================================================================================

REM // Check for admin rights
net file 1>nul 2>&1

if %errorlevel% equ 0 (
    call %*
) else (
    echo Launching Administrator shell.
    powershell -ex unrestricted ^
        -Command "Start-Process -Verb RunAs -FilePath '%comspec%' -ArgumentList '/k cd /d \"%cd%\" & %*'"
)

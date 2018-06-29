@setlocal EnableDelayedExpansion & echo off

REM  ===========================================================================================
REM  Check for admin rights and self-relaunch as admin if necessary.
REM  ===========================================================================================

net session 1>nul 2>&1 && goto :adminMode

@REM -----------------------------------------------------------------------------------------------
echo Re-launching with administrator privileges.

@REM -- Get the full UNC path of this script. We need to do this because drive mappings are not
@REM -- available to administrator shells.

net use %~d0 1>nul 2>&1
if %ErrorLevel% equ 0 (
    for /f "tokens=1,2,*" %%a in ('net use %~d0 ^| findstr -c:"Remote name"') do (
        set remotePath=%%c
    )
    set scriptPath=!remotePath!%~pnx0
) else (
    set scriptPath=%~f0
)

set command=%scriptPath% %*

powershell -ex unrestricted ^
    -Command "Start-Process -Verb RunAs -FilePath '%comspec%' -ArgumentList '/k %command%'"

goto :eof


@REM -----------------------------------------------------------------------------------------------
:adminMode

net session 1>nul 2>&1
if %ErrorLevel% neq 0 (
    echo ERROR: Failed to run 'net session'. It seems that this script failed.
    goto :eof
)

echo Verified running with administrator privileges.
echo Arguments: %*

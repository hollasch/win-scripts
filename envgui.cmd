@setlocal & echo off
:: This command directly launches the Windows environment variable GUI. It's merely a timesaving way
:: to avoid navigating through many different GUIs to change system environment variables.

set args=sysdm.cpl,EditEnvironmentVariables

:: Check for admin rights and run as admin if necessary.
net file 1>nul 2>&1

if %ErrorLevel% equ 0 (
    rundll32.exe %args%
) else (
    powershell -ex unrestricted ^
        -Command "Start-Process -Verb RunAs -FilePath 'rundll32.exe' -ArgumentList '%args%'"
)

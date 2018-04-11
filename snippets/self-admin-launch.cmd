@setlocal & echo off

REM -- Check for admin rights and relaunch as admin if necessary.

net file 1>nul 2>&1 && goto :admin
    echo Re-launching as Admin...
    powershell -ex unrestricted -Command "Start-Process -Verb RunAs -FilePath '%comspec%' -ArgumentList '/k %~fnx0 %*'"
    goto :eof
:admin

echo Running as admin.
net file

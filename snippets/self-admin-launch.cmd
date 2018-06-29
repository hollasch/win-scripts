@setlocal & echo off

REM -- Check for admin rights and self-relaunch as admin if necessary.
REM --
REM -- Note: this script does not work if it's invoked on a network-mapped drive. To do that, you
REM -- would need to get the full network path (parsing the output of `net map` perhaps?) and then
REM -- construct the fully-qualified name of the script file.

net file 1>nul 2>&1 && goto :admin
    echo Re-launching as Admin...
    powershell -ex unrestricted -Command "Start-Process -Verb RunAs -FilePath '%comspec%' -ArgumentList '/k %~fnx0 %*'"
    goto :eof
:admin

echo Running as admin.
echo Arguments: %*

net file

@if (@CodeSection == @Batch) @then
@echo off & setlocal

REM // The first line skips over the shell script lines until the end statement at the bottom.
REM // A simple trick so that this can also contain its own JScript for clipboard pasting.

echo Invoking editor for clipboard.

if not defined EDITOR set EDITOR=notepad.exe

call get-tempFile tempFileName

REM // The following line pastes the current clipboard contents into the temporary file for editing.
REM // Unfortunately, Windows comes with a standard tool to clip content, but lacks a standard tool
REM // to paste the (text) contents of the clipboard.
REM //
REM // See https://stackoverflow.com/a/15747067/566185

cscript /nologo /e:JScript "%~f0" >%tempFileName%

call "%EDITOR%" %tempFileName% || (
    echo get-edit.cmd: Unable to invoke "%EDITOR%". Check EDITOR environment variable. 1>&2
    exit /b 1
)

clip < %tempFileName%
del %tempFileName%
goto :eof

@end  // Begin JScript hybrid script
WSH.Echo(WSH.CreateObject('htmlfile').parentWindow.clipboardData.getData('text'));

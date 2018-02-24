@if (@CodeSection == @Batch) @then
@echo off & setlocal

REM // The first line skips over the shell script lines until the end statement
REM // at the bottom. A simple trick so that this can also contain its own
REM // JScript for clipboard pasting.

REM // -------------------------------------------------------------------------
REM // clip-edit [editor command]
REM //
REM // This script launches an editor on the text contents of the clipboard. On
REM // editor exit, the result is pasted back to the clipboard.
REM //
REM // The editor used is determined by the following rules, using the first one
REM // that matches:
REM //
REM //     1. If command arguments are given, they are used as the editor
REM //        command.
REM //     2. If the EDITOR environment variable is defined, use that.
REM //     3. Invoke Notepad.exe to edit the contents.
REM //
REM // -------------------------------------------------------------------------

echo Invoking editor for clipboard.

if "%1" neq "" (
    set EDITOR=%*
) else if not defined EDITOR (
    set EDITOR=notepad.exe
)

call get-tempFile tempFileName

REM // The following line pastes the current clipboard contents into the
REM // temporary file for editing. Unfortunately, Windows comes with a standard
REM // tool to clip content, but lacks a standard tool to paste the (text)
REM // contents of the clipboard.
REM //
REM // See https://stackoverflow.com/a/15747067/566185

cscript /nologo /e:JScript "%~f0" >%tempFileName%

call %EDITOR% %tempFileName% || (
    echo get-edit.cmd: Unable to invoke "%EDITOR%". Check EDITOR environment variable. 1>&2
    pause
    exit /b 1
)

clip < %tempFileName%
del %tempFileName%

goto :eof

REM ________________________________________________________________________________________________
@end  // Begin JScript hybrid script
WSH.Echo(WSH.CreateObject('htmlfile').parentWindow.clipboardData.getData('text'));

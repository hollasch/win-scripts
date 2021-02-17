@echo off
goto :two

REM ###########################################################
REM ## This script fails to locate the label :one when saved ##
REM ## with LF line endings. The failure is sensitive to the ##
REM ## exact number of characters from the start of file to  ##
REM ## the :one label below, so adding or removing           ##
REM ## comment characters will "fix" the file.               ##
REM ###########################################################
REM ####################################

:one
echo one
goto :eof

:two
echo two
goto :one

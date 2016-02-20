@echo off

REM -- Replacement for the Unix 'touch' command. Creates target file if it
REM -- doesn't already exist.

if X%1 equ X (
    echo touch: Update file modification time or create empty file.
    echo usage: touch ^<filename^>
    exit /b 0
)

if not exist %1 (
    copy >nul nul %1
) else (
    copy >nul /b %1 +,,
)

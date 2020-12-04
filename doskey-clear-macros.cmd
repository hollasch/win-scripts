@echo off & setlocal

REM -- Clear all standard (non-executable bound) DOSKEY macros. 

for /f "delims==" %%m in ('doskey /macros') do (
    doskey %%m=
)

@echo off & setlocal
@REM // ========================================================================
@REM // This fragment illustrates the way to exit a script with a non-zero exit
@REM // code, in addition to setting the ERRORLEVEL value. The intuitive
@REM // solution of using 'exit /b <nonzero>' doesn't work, since it won't
@REM // affect the command interpreter exit code unless the script was invoked
@REM // via the 'call' command.
@REM // 
@REM // In order to get the script to work like a standard executable, you need
@REM // to take advantage of the fact that the interpreter will exit with the
@REM // exit code of the last command in the file. Thus, use the
@REM // `cmd /c exit <code>` command to set the exit code, and make sure it's
@REM // the last line of the file. With both these conditions, you can ensure
@REM // that both the ERRORLEVEL and the exit code will be set as you wish.
@REM // ========================================================================

@REM // This script will fail if you give it "fail" as a command line argument.

if "%1" equ "fail" (
    echo (Failure)
    goto fail
)

echo (Success)
exit /b 0

:fail
    @REM // Exit with script a failure exit code.
    cmd /c exit 37

@echo off
@REM:  -----------------------------------------------------------------------
@REM:  This command script searches along the current path to find the
@REM:  target file or directory. This is useful for finding setup scripts in
@REM:  an enlistment tree, for example. See usage below for more information.
@REM:  -----------------------------------------------------------------------

if "%~1" equ "" (
    echo %0: Search upward from current directory for a specified file or directory.
    echo Usage: %0 [^<filename^> ^| ^<dirname^>]
    echo.
    echo This command searches upward from the current directory for a target
    echo file or directory. If the target is not found, the error level is set
    echo to 1 and the current directory is unchanged.
    echo.
    echo If the item is found, this command changes to the parent directory of
    echo the target and returns 0.
    exit /b 0
)

pushd .
set __upsearch_root="%cd%"

:loop
    cd ..

    if %__upsearch_root% equ "%cd%" (
        @REM // Path didn't change, so we must have hit the root.
        echo 1>&2File "%~1%" not found.
        popd
        set __upsearch_root=
        goto fail
    )

    set __upsearch_root="%cd%"

    @REM // If we found the target, then we're done.
    if exist "%~1" (
        popd
        cd %__upsearch_root%
        set __upsearch_root=
        exit /b 0
    )

    @REM // Move up to the next parent directory.
    goto :loop


:fail
    @REM // Exit with script a failure exit code.
    cmd /c exit 1

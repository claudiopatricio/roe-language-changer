:: Copyright (c) 2018 Cláudio Patrício
:: 
:: Permission is hereby granted, free of charge, to any person obtaining a copy
:: of this software and associated documentation files (the "Software"), to deal
:: in the Software without restriction, including without limitation the rights
:: to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
:: copies of the Software, and to permit persons to whom the Software is
:: furnished to do so, subject to the following conditions:
:: 
:: The above copyright notice and this permission notice shall be included in all
:: copies or substantial portions of the Software.

@echo off

SETLOCAL ENABLEDELAYEDEXPANSION

:: Check for admin permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
IF '%errorlevel%' NEQ '0' GOTO NOT_ADMIN

:: Check if FINDSTR and WMIC are available
FINDSTR.EXE /? >NUL 2>&1 || GOTO NOT_AVAILABLE
WMIC.EXE    /? >NUL 2>&1 || GOTO NOT_AVAILABLE


:: Main Script
FOR /F "usebackq tokens=1* delims=" %%i IN (`wmic process WHERE "Name='Europa_Client.exe'" get Commandline ^| FINDSTR /I /C:"Europa_Client"`) DO (
    IF NOT %%i=="" (
        set _var=%%i
        @ECHO @echo off > roe_en.bat
        @ECHO !_var:th=en! >> roe_en.bat
        @ECHO exit >> roe_en.bat
        @ECHO Batch file 'roe_en.bat' created with SUCCESS^^!^^!^^!
        
        goto END
    )
)
goto NOT_RUNNING

:NOT_AVAILABLE
@ECHO ERROR: There is some dependencies not available, please enable findstr.exe and wmic.exe
GOTO END

:NOT_RUNNING
@ECHO ERROR: You need to launch the game before running this script!
GOTO END

:NOT_ADMIN
@ECHO ERROR: This script needs to be run as administrator!
GOTO END

:END
ENDLOCAL
@ECHO.
PAUSE
::EXIT
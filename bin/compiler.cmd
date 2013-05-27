@echo off

:: NOTE: Reference: taobao YUI Compressor

SETLOCAL ENABLEEXTENSIONS

echo closure-compiler

:: select *.js
if "%~x1" NEQ ".js" (
    echo NOTE: Please select a js file
    goto End
)

:: check the JAVA
if "%JAVA_HOME%" == "" goto NoJavaHome
if not exist "%JAVA_HOME%\bin\java.exe" goto NoJavaHome
if not exist "%JAVA_HOME%\bin\native2ascii.exe" goto NoJavaHome

:: filename.source.js -> filename.js  or filename.js -> filename.min.js
set RESULT_FILE=%~n1.min%~x1
dir /b "%~f1" | find ".source." > nul
if %ERRORLEVEL% == 0 (
    for %%a in ("%~n1") do (
        set RESULT_FILE=%%~na%~x1
    )
)

:: compile.jar
    :: for utf-8
    "%JAVA_HOME%\bin\java.exe" -jar "%~dp0compiler.jar"  --charset UTF-8 --js "%~nx1" --js_output_file "%RESULT_FILE%"

:: unicode to ascii
    copy /y "%RESULT_FILE%" "%RESULT_FILE%.tmp" > nul
    "%JAVA_HOME%\bin\native2ascii.exe" -encoding UTF-8 "%RESULT_FILE%.tmp" "%RESULT_FILE%"
    del /q "%RESULT_FILE%.tmp"

:: print result
if %ERRORLEVEL% == 0 (
    echo Compress %~nx1 to %RESULT_FILE%
    for %%a in ("%RESULT_FILE%") do (
        echo size from %~z1 bytes to %%~za bytes
    )
) else (
    echo NOTE: file %~nx1 syntax error
    goto End
)
goto End

:NoJavaHome
echo NOTE: You must set the JAVA_HOME environment variable.

:End
ENDLOCAL
:: pause

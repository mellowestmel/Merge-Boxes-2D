@echo off
setlocal EnableExtensions

set "GAME_NAME=Merge Boxes! 2D"
set "EXE_NAME=play.exe"
set "LOVE=C:\Program Files\LOVE"
set "OUTPUT_BASE=%USERPROFILE%\Desktop\mb2d-auto-built"
set "INCLUDE_DIRS=code assets"
set "SCRIPT_DIR=%~dp0"
set "ICON=%SCRIPT_DIR%game.ico"
set "RCEDIT=%SCRIPT_DIR%rcedit.exe"
set "RCEDIT_URL=https://github.com/electron/rcedit/releases/latest/download/rcedit-x64.exe"

for %%I in ("%~dp0..") do set "PROJECT=%%~fI"

set "INTERACTIVE=1"
if /i "%~1"=="/nomenu" set "INTERACTIVE=0"

if "%INTERACTIVE%"=="0" goto :START

cls
echo.
echo    ============================================================
echo     %GAME_NAME% - BUILD TOOL
echo    ============================================================
echo     Project : %PROJECT%
echo    ============================================================
echo.
echo    [1] Build the game
echo    [2] Exit
echo.

choice /c 12 /n /m "    Select an option [1-2]: "

if errorlevel 2 goto :END
if errorlevel 1 goto :START


:START
cls
title Building %GAME_NAME% ...

set "ERR="
set "TEMP_BUILD=%TEMP%\love_build_%RANDOM%"
set "STAGE=%TEMP_BUILD%\stage"

set "OUTPUT=%OUTPUT_BASE%"
set /a OUTPUT_NUMBER=1


:CHECK_OUTPUT
if not exist "%OUTPUT%" goto :OUTPUT_READY

set /a OUTPUT_NUMBER+=1
set "OUTPUT=%OUTPUT_BASE%-%OUTPUT_NUMBER%"
goto :CHECK_OUTPUT


:OUTPUT_READY

echo.
echo    ============================================================
echo     %GAME_NAME% - LOVE2D BUILD
echo    ============================================================
echo     Project : %PROJECT%
echo     Output  : %OUTPUT%
echo    ============================================================
echo.

echo    [1/6] Checking project files

if not exist "%PROJECT%\main.lua" (
    set "ERR=main.lua not found."
    goto :ERROR
)

if not exist "%PROJECT%\conf.lua" (
    set "ERR=conf.lua not found."
    goto :ERROR
)

echo    [ OK ] main.lua
echo    [ OK ] conf.lua

echo.
echo    [2/6] Checking LOVE

if not exist "%LOVE%\love.exe" (
    set "ERR=love.exe not found in %LOVE%"
    goto :ERROR
)

echo    [ OK ] %LOVE%

if not exist "%ICON%" (
    set "ERR=game.ico not found next to the build script."
    goto :ERROR
)

echo    [ OK ] game.ico


if not exist "%RCEDIT%" (
    echo    [ .. ] rcedit.exe missing
    echo    [ .. ] Downloading rcedit-x64.exe...

    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "$ErrorActionPreference='Stop'; Invoke-WebRequest -Uri '%RCEDIT_URL%' -OutFile '%RCEDIT%'"

    if errorlevel 1 (
        set "ERR=Could not download rcedit.exe."
        goto :ERROR
    )

    if not exist "%RCEDIT%" (
        set "ERR=rcedit.exe download failed."
        goto :ERROR
    )

    echo    [ OK ] rcedit.exe downloaded
) else (
    echo    [ OK ] rcedit.exe
)


echo.
echo    [3/6] Preparing folders

if exist "%TEMP_BUILD%" rmdir /s /q "%TEMP_BUILD%" 2>nul

mkdir "%OUTPUT%"
mkdir "%STAGE%"

if not exist "%OUTPUT%" (
    set "ERR=Could not create output folder."
    goto :ERROR
)

if not exist "%STAGE%" (
    set "ERR=Could not create temporary folder."
    goto :ERROR
)

echo    [ OK ] Output folder
echo    [ OK ] Temporary folder


echo.
echo    [4/6] Staging game files

copy /y "%PROJECT%\main.lua" "%STAGE%\main.lua" >nul

if errorlevel 1 (
    set "ERR=Could not copy main.lua."
    goto :ERROR
)

copy /y "%PROJECT%\conf.lua" "%STAGE%\conf.lua" >nul

if errorlevel 1 (
    set "ERR=Could not copy conf.lua."
    goto :ERROR
)

echo    [ OK ] main.lua
echo    [ OK ] conf.lua


for %%D in (%INCLUDE_DIRS%) do (
    if exist "%PROJECT%\%%D" (
        xcopy "%PROJECT%\%%D" "%STAGE%\%%D" /E /I /H /Y /Q >nul

        if errorlevel 1 (
            set "ERR=Could not copy %%D folder."
            goto :ERROR
        )

        echo    [ OK ] %%D\
    )
)


set "FILECOUNT=0"

for /f %%C in ('dir /s /b /a-d "%STAGE%" ^| find /c /v ""') do set "FILECOUNT=%%C"


echo.
echo    [5/6] Building executable

echo    [ .. ] Creating game.love

powershell -NoProfile -Command ^
    "Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::CreateFromDirectory('%STAGE%', '%TEMP_BUILD%\game.zip', [System.IO.Compression.CompressionLevel]::Optimal, $false)"

if errorlevel 1 (
    set "ERR=Failed to create game archive."
    goto :ERROR
)

if not exist "%TEMP_BUILD%\game.zip" (
    set "ERR=Game archive was not created."
    goto :ERROR
)

move /y "%TEMP_BUILD%\game.zip" "%TEMP_BUILD%\game.love" >nul

if errorlevel 1 (
    set "ERR=Could not rename game archive to game.love."
    goto :ERROR
)

if not exist "%TEMP_BUILD%\game.love" (
    set "ERR=game.love was not created."
    goto :ERROR
)

echo    [ OK ] game.love


echo    [ .. ] Copying LOVE executable

copy /y "%LOVE%\love.exe" "%OUTPUT%\%EXE_NAME%" >nul

if errorlevel 1 (
    set "ERR=Could not copy love.exe."
    goto :ERROR
)

echo    [ OK ] love.exe


echo    [ .. ] Setting game icon

"%RCEDIT%" "%OUTPUT%\%EXE_NAME%" --set-icon "%ICON%"

if errorlevel 1 (
    set "ERR=Could not set the executable icon."
    goto :ERROR
)

echo    [ OK ] Game icon


echo    [ .. ] Fusing game.love

copy /b "%OUTPUT%\%EXE_NAME%" + "%TEMP_BUILD%\game.love" "%OUTPUT%\fused.tmp" >nul

if errorlevel 1 (
    set "ERR=Could not fuse game.love into the executable."
    goto :ERROR
)

if not exist "%OUTPUT%\fused.tmp" (
    set "ERR=Fused executable was not created."
    goto :ERROR
)

move /y "%OUTPUT%\fused.tmp" "%OUTPUT%\%EXE_NAME%" >nul

if errorlevel 1 (
    set "ERR=Could not replace the executable with the fused version."
    goto :ERROR
)

echo    [ OK ] Game data fused


echo    [ .. ] Copying LOVE DLLs

copy /y "%LOVE%\*.dll" "%OUTPUT%\" >nul

if errorlevel 1 (
    set "ERR=Could not copy LOVE DLL files."
    goto :ERROR
)

echo    [ OK ] LOVE DLLs
echo    [ OK ] %FILECOUNT% files packed


rmdir /s /q "%TEMP_BUILD%" 2>nul


echo.
echo    [6/6] Build complete
echo.
echo    ============================================================
echo     BUILD SUCCESSFUL
echo    ============================================================
echo     %OUTPUT%\%EXE_NAME%
echo    ============================================================
echo.

if "%INTERACTIVE%"=="0" goto :END


:MENU

echo.
echo    [1] Play the game
echo    [2] Open output folder
echo    [3] Create distributable ZIP
echo    [4] Rebuild
echo    [5] Exit
echo.

choice /c 12345 /n /m "    Select an option [1-5]: "

if errorlevel 5 goto :END
if errorlevel 4 goto :START
if errorlevel 3 goto :MAKEZIP
if errorlevel 2 goto :OPENFOLDER
if errorlevel 1 goto :PLAY

goto :MENU


:PLAY

start "" /d "%OUTPUT%" "%OUTPUT%\%EXE_NAME%"

goto :MENU


:OPENFOLDER

powershell -NoProfile -Command ^
    "$wshell = New-Object -ComObject Shell.Application; $wshell.Open('%OUTPUT%')"

goto :MENU


:MAKEZIP

set "VERSION_NAME="

set /p "VERSION_NAME=    Enter game version: "

if not defined VERSION_NAME (
    echo.
    echo    Version cannot be empty.
    goto :MENU
)

set "ZIP=%USERPROFILE%\Desktop\%VERSION_NAME%.zip"
set "ZIP_STAGE=%TEMP%\%GAME_NAME%_release"

echo.
echo    Creating:
echo    %ZIP%
echo.

if exist "%ZIP%" del /q "%ZIP%"

if exist "%ZIP_STAGE%" rmdir /s /q "%ZIP_STAGE%" 2>nul

mkdir "%ZIP_STAGE%\%GAME_NAME%"

if not exist "%ZIP_STAGE%\%GAME_NAME%" (
    echo.
    echo    [FAIL] Could not create ZIP staging folder.
    goto :MENU
)

xcopy "%OUTPUT%\*" "%ZIP_STAGE%\%GAME_NAME%\" /E /I /H /Y /Q >nul

if errorlevel 1 (
    echo.
    echo    [FAIL] Could not prepare ZIP.
    rmdir /s /q "%ZIP_STAGE%" 2>nul
    goto :MENU
)


if exist "%PROJECT%\CREDITS.md" (
    copy /y "%PROJECT%\CREDITS.md" "%ZIP_STAGE%\CREDITS.md" >nul
)

if exist "%PROJECT%\README.md" (
    copy /y "%PROJECT%\README.md" "%ZIP_STAGE%\README.md" >nul
)


powershell -NoProfile -Command ^
    "Compress-Archive -Path '%ZIP_STAGE%\*' -DestinationPath '%ZIP%' -Force"

if errorlevel 1 (
    echo.
    echo    [FAIL] Could not create ZIP.
    rmdir /s /q "%ZIP_STAGE%" 2>nul
    goto :MENU
)

rmdir /s /q "%ZIP_STAGE%" 2>nul

echo    [ OK ] %ZIP%
echo.

goto :MENU


:ERROR

echo.
echo    ============================================================
echo     BUILD FAILED
echo    ============================================================
echo     %ERR%
echo    ============================================================
echo.

if exist "%TEMP_BUILD%" rmdir /s /q "%TEMP_BUILD%" 2>nul

if "%INTERACTIVE%"=="1" pause

endlocal
exit /b 1


:END

endlocal
exit /b 0
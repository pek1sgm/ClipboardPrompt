@echo off
setlocal EnableDelayedExpansion

:: Skript zum Finden und Starten einer kompatiblen AutoHotkey-Version zum Starten von SendToLLM.ahk

:: Wechsel in das Verzeichnis des aktuellen Skripts
cd /d "%~dp0"

:: Initialisiere Variable für AutoHotkey-Exe-Dateien
set "ahkExecutables="

:: Suche nach AutoHotkey-Exe-Dateien im aktuellen Verzeichnis
for %%F in (*AutoHotkey*.exe) do (
    set "ahkExecutables=!ahkExecutables! %%F"
)

:: Versuche jede gefundene AutoHotkey-Exe zu starten
for %%A in (%ahkExecutables%) do (
    echo Versuche %%A...
    ::start "" "%cd%\%%A" "%cd%\SendToLLM.ahk"
    start "" "%%A" "SendToLLM.ahk"

    :: Warte 2 Sekunden, um den Start zu prüfen
    timeout /t 2 >nul

    :: Überprüfen, ob der Prozess aktiv ist
    tasklist | find /i "%%A" >nul 2>&1
    if !ERRORLEVEL!==0 (
        set "ahkExe=%%A"
        goto :success
    )
)

:: Kein passendes AutoHotkey gefunden
echo Keine kompatible AutoHotkey-Version gefunden.
exit /b 1

:success
:: Erfolgreich gestartete AutoHotkey-Version ausgeben
echo AutoHotkey-Version: %ahkExe%
exit /b 0

endlocal
::popd

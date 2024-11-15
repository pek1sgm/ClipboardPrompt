@echo off
:: Verzeichnis "logs" erstellen
mkdir logs

:: Leere Datei "llm_log.txt" im Verzeichnis "logs" erstellen und "Init" mit Datum eintragen
echo Init %date% %time% > logs\llm_log.txt

:: Überprüfen, ob der erste Schritt erfolgreich war
if not exist logs\llm_log.txt (
    echo Fehler: logs-Verzeichnis oder llm_log.txt konnte nicht erstellt werden.
    exit /b 1
)

:: AutoHotkey-Skript starten
cd ahk
start "ahk\AutoHotkeyU64.exe" .\SendToLLM.ahk

:: Überprüfen, ob das Skript erfolgreich aufgerufen wurde
if %errorlevel% neq 0 (
    echo Fehler: SendToLLM.ahk konnte nicht ausgeführt werden.
    exit /b 1
)

:: Erfolgreiche Installation
echo Fertig!
pause

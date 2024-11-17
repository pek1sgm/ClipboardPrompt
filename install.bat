@echo off
setlocal EnableDelayedExpansion

:: Skript zur Installation und Initialisierung des LLM-Workflows

:: Ins Verzeichnis der Batch-Datei wechseln
pushd "%~dp0"

:: Verzeichnis "logs" erstellen
if not exist logs mkdir logs

:: Leere Datei "llm_log.txt" im Verzeichnis "logs" erstellen und "Init" mit Datum eintragen
echo [%date% %time:~0,8%] Log-Datei wurde erstellt / start install.bat. >> logs\llm_log.txt

:: Prüfe ob llm_lig.txt existiert, wenn nicht gib ein Hinweis aus
if not exist logs\llm_log.txt (
    echo  [%date% %time:~0,8%] /install.bat/ logs-Verzeichnis oder llm_log.txt konnte nicht erstellt werden. >> logs\llm_log.txt
    exit /b 1
)

:: Überpruefen, ob die Datei "apikey.xml" im Verzeichnis "config" existiert
if not exist config\apikey.xml (
    echo [%date% %time:~0,8%] /install.bat/ Die Datei "apikey.xml" wird benoetigt. Bitte geben Sie den API-Key ein.
    :: Eingabe des API-Keys
    set /p "userInput=API-Key: "

    :: Debug-Ausgabe
    :: echo Debug: Eingabe = "!userInput!"

    :: Überprüfen, ob die Eingabe leer ist
    if "!userInput!"=="" (
        echo [%date% %time:~0,8%] /install.bat/ API-Key eingegeben, install.bat wird beendet. >> logs\llm_log.txt
        pause
        exit /b 1
    )

    :: PowerShell-Skript zur API-Key-Verschluesselung aufrufen
    powershell -ExecutionPolicy Bypass -File scripts\StoreApiKey.ps1 -ApiKey "!userInput!"
    echo [%date% %time:~0,8%] /install.bat/ API-Key wird verschluesselt in "apikey.xml" geschrieben. >> logs\llm_log.txt
    pause
) else (
    echo [%date% %time:~0,8%] /install.bat/ Datei "apikey.xml" existiert, keine Eingabe erforderlich. >> logs\llm_log.txt
)

:: Starte Erstellung Datenmanifest (CreateFileManifest.ps1)
echo [%date% %time:~0,8%] /install.bat/ Startbefehl fuer Manifestskript wurde uebergeben. >> logs\llm_log.txt
powershell -NoProfile -ExecutionPolicy Bypass -File "%cd%\scripts\CreateFileManifest.ps1"

:: Starte LLM-Workflow (ProcessLLM.ps1)
echo [%date% %time:~0,8%] /install.bat/ Startbefehl fuer initialen LLM-Workflow wurde uebergeben. >> logs\llm_log.txt
powershell -NoProfile -ExecutionPolicy Bypass -File "%cd%\scripts\ProcessLLM.ps1" -Text "Antworte mit einer Zahl: Was ist der Sinn des Lebens"

:: Starte AutoHotkey
echo [%date% %time:~0,8%] /install.bat/ start_AutoHotkey.bat gestartet. >> logs\llm_log.txt
:: start /b "" "%cd%\ahk\start_AutoHotkey.bat" >nul 2>&1
call "%cd%\ahk\start_AutoHotkey.bat"
echo [%date% %time:~0,8%] start_AutoHotkey.bat erfolgreich. >> logs\llm_log.txt

:: Erfolgreiche Installation
echo [%date% %time:~0,8%]  /install.bat/ Einrichtung abgeschlossen. >> logs\llm_log.txt

endlocal
popd
pause

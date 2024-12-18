﻿; SendToLLM.ahk
; Automatisiert das Senden von markiertem Text an ein LLM über Hotkeys.
;
; Hotkeys:
; - Shift + Strg + C: Grammatik/Stil verbessern
; - Shift + Strg + E: Text ins Englische übersetzen
; - Shift + Strg + D: Text ins Deutsche übersetzen
;
; Abhängigkeiten:
; - JSON.ahk
; - prompts.json
; - RunHiddenLLM.vbs

; Aktuellen Pfad ermitteln
currentDir := A_ScriptDir

; Übergeordnetes Verzeichnis bestimmen
mainDir := RegExReplace(currentDir, "\\[^\\]+$")

#Include %A_ScriptDir%\json.ahk ; JSON-Bibliothek einbinden
; JSON-Daten global einlesen

global prompts_json
global config_file
global manifest_json

; manifest_json einlesen
manifestFile := mainDir "\config\file_manifest.json"
FileRead, jsonData, %manifestFile%
manifest_json := JSON.Load(jsonData)

; Pfade aus manifest_json nehmen
logFile := manifest_json["llm_log.txt"]
promptsFile := manifest_json["prompts.json"]
configFile := manifest_json["config.json"]

; JSON-Daten einlesen
FileRead, jsonData, %promptsFile%
prompts_json := JSON.Load(jsonData)

FileRead, jsonData, %configFile%
config_file := JSON.Load(jsonData)

ProcessHotkey(jsonKey) {
    Clipboard := "" ; Clipboard leeren
    Send, ^c ; Markierten Text in die Zwischenablage kopieren
    Sleep, 200 ; Wartezeit

    if (prompts_json[jsonKey]) {
        Clipboard := prompts_json[jsonKey] . Clipboard ; JSON-Text zuerst, dann markierter Text
        clipboardText := Clipboard
        scriptPath := manifest_json["RunHiddenLLM.vbs"]
        mainScript := manifest_json["ProcessLLM.ps1"]
        command := scriptPath " -File """ mainScript """ -Text """ clipboardText """"
        Run, %ComSpec% /c %command%, ,Hide
        Clipboard := command
    } else {
        MsgBox, Fehler: Kein Wert für "%jsonKey%" gefunden.
    }
}

+^c:: ; Shift + Strg + C
{
    ProcessHotkey("correct")
    return
}

+^e:: ; Shift + Strg + E
{
    ProcessHotkey("translate_to_en")
    return
}

+^d:: ; Shift + Strg + D
{
    ProcessHotkey("translate_to_ge")
    return
}

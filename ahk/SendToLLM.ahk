; SendToLLM.ahk
; Beschreibung:
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

#Include json.ahk ; JSON-Bibliothek einbinden
; JSON-Daten global einlesen
global json
FileRead, jsonData, ..\config\prompts.json
json := JSON.Load(jsonData)

; JSON-Daten in die Log-Datei schreiben
FileAppend, %jsonData%`n, ..\logs\llm_log.txt

+^c:: ; Shift + Strg + C
{
    Clipboard := "" ; Clipboard leeren
    Send, ^c ; Markierten Text in die Zwischenablage kopieren
    Sleep, 200 ; Wartezeit

    if (json.correct) {
        Clipboard := json.correct . Clipboard ; JSON-Text zuerst, dann markierter Text
        clipboardText := Clipboard
        Run, ..\scripts\RunHiddenLLM.vbs "%clipboardText%"
    } else {
        MsgBox, Fehler: Kein Wert für "correct" gefunden.
    }
    return
}

+^e:: ; Shift + Strg + E
{
    Clipboard := "" ; Clipboard leeren
    Send, ^c ; Markierten Text in die Zwischenablage kopieren
    Sleep, 200 ; Wartezeit

    if (json.translate_to_en) {
        Clipboard := json.translate_to_en . Clipboard ; JSON-Text zuerst, dann markierter Text
        clipboardText := Clipboard
        Run, ..\scripts\RunHiddenLLM.vbs "%clipboardText%"
    } else {
        MsgBox, Fehler: Kein Wert für "translate_to_en" gefunden.
    }
    return
}

+^d:: ; Shift + Strg + D
{
    Clipboard := "" ; Clipboard leeren
    Send, ^c ; Markierten Text in die Zwischenablage kopieren
    Sleep, 200 ; Wartezeit

    if (json.translate_to_ge) {
        Clipboard := json.translate_to_ge . Clipboard ; JSON-Text zuerst, dann markierter Text
        clipboardText := Clipboard
        Run, ..\scripts\RunHiddenLLM.vbs "%clipboardText%"
    } else {
        MsgBox, Fehler: Kein Wert für "translate_to_ge" gefunden.
    }
    return
}

' Wrapper-Skript zur Ausführung eines PowerShell-Skripts im versteckten Modus.
' Übergeben wird der Pfad des PowerShell-Skripts sowie ein beliebiger Text.
' Beispiel:
' cscript RunHiddenLLM.vbs -File ".\any_script.ps1" -Text "Beispieltext"


Set objShell = CreateObject("WScript.Shell")

' Argumente prüfen
If WScript.Arguments.Count < 4 Then
    WScript.Echo "Fehler: Erwartet -File <Pfad> und -Text <Text> als Argumente."
    WScript.Quit 1
End If

' Variablen initialisieren
Dim psScriptPath
Dim textArgument

' Argumente parsen
For i = 0 To WScript.Arguments.Count - 1 Step 2
    Select Case WScript.Arguments(i)
        Case "-File"
            psScriptPath = WScript.Arguments(i + 1)
        Case "-Text"
            textArgument = WScript.Arguments(i + 1)
        Case Else
            WScript.Echo "Unbekanntes Argument: " & WScript.Arguments(i)
            WScript.Quit 1
    End Select
Next

' PowerShell-Befehl zusammenstellen
If IsEmpty(psScriptPath) Or IsEmpty(textArgument) Then
    WScript.Echo "Fehler: -File oder -Text Argument fehlt."
    WScript.Quit 1
End If

Dim command
command = "powershell -ExecutionPolicy Bypass -File """ & psScriptPath & """ -Text """ & textArgument & """"
objShell.Run command, 0

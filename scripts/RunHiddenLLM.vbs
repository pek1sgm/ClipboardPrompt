' Wrapper-Skript zur Ausführung eines PowerShell-Skripts im versteckten Modus.
' Übergeben wird der Pfad des PowerShell-Skripts sowie ein beliebiger Text.
' Beispiel:
' cscript RunHiddenLLM.vbs -File ".\any_script.ps1" -Text "Beispieltext"

' Aktuelles Datum und Uhrzeit im gewünschten Format
Set objShell = CreateObject("WScript.Shell")
Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Variablen initialisieren
Dim psScriptPath
Dim textArgument
Dim dateTime
Dim command, returnCode

currentDir = shell.CurrentDirectory
parentDir = fso.GetParentFolderName(currentDir)
logFilePath = fso.BuildPath(parentDir, "logs\llm_log.txt")

' Datum formattieren
dateTime = Now
formattedDateTime = Year(dateTime) & "-" & Right("0" & Month(dateTime), 2) & "-" & Right("0" & Day(dateTime), 2) & " " & Right("0" & Hour(dateTime), 2) & ":" & Right("0" & Minute(dateTime), 2) & ":" & Right("0" & Second(dateTime), 2)

' Eintrag in die Log-Datei / 1. Logging
Set logFile = fso.OpenTextFile(logFilePath, 8, True)
logFile.WriteLine "[" & formattedDateTime & "] (RunHiddenLLM.vbs) >>Wrapperprozess (RunHiddenLLM.vbs) gestartet"

' Argumente prüfen / Fehler-Logging
If WScript.Arguments.Count < 4 Then
    logFile.WriteLine "[" & formattedDateTime & "] (RunHiddenLLM.vbs) Fehler: Erwartet -File <Pfad> und -Text <Text> als Argumente."
    logFile.Close
    WScript.Quit 1
End If



' Argumente parsen / Fehler-Logging
For i = 0 To WScript.Arguments.Count - 1 Step 2
    Select Case WScript.Arguments(i)
        Case "-File"
            psScriptPath = WScript.Arguments(i + 1)
        Case "-Text"
            textArgument = WScript.Arguments(i + 1)
        Case Else
            logFile.WriteLine "[" & formattedDateTime & "] (RunHiddenLLM.vbs) Unbekanntes Argument: " & WScript.Arguments(i)
            logFile.Close
            WScript.Quit 1
    End Select
Next

' PowerShell-Befehl zusammenstellen / Fehler-Logging
If IsEmpty(psScriptPath) Or IsEmpty(textArgument) Then
    logFile.WriteLine "[" & formattedDateTime & "] (RunHiddenLLM.vbs) Fehler: -File oder -Text Argument fehlt."
    WScript.Quit 1
End If
logFile.Close

' Erstellt ein Kommando mit Übergabeparametern und übergibt es an einen PowerShell-Prozess.
' Der Prozess wird im Hintergrund ausgeführt, und der Rückgabecode wird zur Erfolgskontrolle verwendet.
command = "powershell -ExecutionPolicy Bypass -File """ & psScriptPath & """ -Text """ & textArgument & """"
returnCode = objShell.Run(command, 0, True)

' Eintrag in die Log-Datei / 2. Logging
Set logFile = fso.OpenTextFile(logFilePath, 8, True)
logFile.WriteLine "[" & formattedDateTime & "] (RunHiddenLLM.vbs) >>Wrapperprozess beendet" & vbCrLf
logFile.Close



' RunHiddenLLM.vbs
' Beschreibung:
' Startet ein PowerShell-Skript im Hintergrund, um eine LLM-Anfrage zu verarbeiten.
'
' Abhängigkeiten:
' - ProcessLLM.ps1
' - PowerShell 5.1 oder höher

Set objShell = CreateObject("WScript.Shell")
command = "powershell -ExecutionPolicy Bypass -File ..\scripts\ProcessLLM.ps1 -Text """ & WScript.Arguments(0) & """"
objShell.Run command, 0

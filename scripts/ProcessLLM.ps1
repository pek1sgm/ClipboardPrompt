<#
.SYNOPSIS
Verarbeitet Anfragen an ein LLM und protokolliert Eingaben sowie Antworten.

.DESCRIPTION
Dieses Skript sendet Anfragen an ein LLM und loggt die Ergebnisse.
Die Konfigurationsdaten (Modell und URI) sowie Dateipfade werden dynamisch aus einer JSON-Datei geladen.

.PARAMETER Text
Der zu sendende Text.

.DEPENDENCIES
- PowerShell 5.1 oder höher
- file_manifest.json

.OUTPUTS
Protokolldatei: .\logs\llm_log.txt
#>

param (
    [string]$Text = ""
)

# Neue Verzeichniswahl
$parentDir = Split-Path -Path $PSScriptRoot -Parent

# Datei "file_manifest.json" auslesen
$fileManifestPath = "$parentDir\config\file_manifest.json"
$fileManifest = Get-Content -Path $fileManifestPath | ConvertFrom-Json

# Dynamische Pfade setzen
$xmlFilePath = $fileManifest."apikey.xml"
$configFilePath = $fileManifest."config.json"
$logFilePath = $fileManifest."llm_log.txt"

# Konfigurationsdaten (Endpunkt und Modell) auslesen
$config = Get-Content -Path $configFilePath | ConvertFrom-Json

# 1. Logging
$dateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content -Path $logFilePath -Value "[$dateTime] (ProcessLLM.ps1) >>LLM-Workflow gestartet"

# Entschlüsseln des API-Keys / 2. Logging
$secureString = Import-Clixml -Path $xmlFilePath
if (-Not $secureString) {
    Add-Content -Path $logFilePath -Value "[$dateTime] (ProcessLLM.ps1) Fehler: Der Import des SecureStrings aus '$xmlFilePath' ist fehlgeschlagen."
    return
} else {
    $apiKey = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString))
    if (-Not $apiKey -or $apiKey.Trim() -eq "") {
        Add-Content -Path $logFilePath -Value "[$dateTime] (ProcessLLM.ps1) Fehler: Die Umwandlung von SecureString in einen Klartext-API-Schlüssel ist fehlgeschlagen."
        return
    } else {
        Add-Content -Path $logFilePath -Value "[$dateTime] (ProcessLLM.ps1) Erfolgreich: API-Schlüssel wurde erfolgreich entschlüsselt."
    }
}

# Konfigurationsdaten aus config.json lesen / 3. Logging
$config = Get-Content -Path $configFilePath | ConvertFrom-Json
"[$dateTime] (ProcessLLM.ps1) Modell: $($config.model) | Endpunkt: $($config.Uri)"| Out-File -FilePath $logFilePath -Encoding UTF8 -Append

# Header festlegen
$headers = @{
    "api-key" = $apiKey
    "Content-Type" = "application/json; charset=utf-8"
}

# Funktion, um eine Anfrage zu senden
function Send-Request($contentText) {
    $body = @{
        model = $config.model
        temperature = 0.0
        messages = @(@{
            role = "user"
            content = $contentText
        })
    } | ConvertTo-Json -Depth 10

    # Senden der Anfrage und Antwort zurückgeben
    $response = Invoke-WebRequest -Uri $config.Uri `
        -Method Post `
        -Headers $headers `
        -Body ([System.Text.Encoding]::UTF8.GetBytes($body))

    # Konvertiere die Antwort explizit in UTF-8
    $responseData = [System.Text.Encoding]::UTF8.GetString([System.Text.Encoding]::UTF8.GetBytes($response.Content))
    $responseJson = $responseData | ConvertFrom-Json
    return $responseJson.choices[0].message.content
}

# Anfrage senden / 4. Logging
$answer_prompt = Send-Request -contentText $Text
$processedText = $Text -replace '.*?-Text\s+', '' # Zeige nur das was nach '-Text' steht
Add-Content -Path $logFilePath -Value "[$dateTime] (ProcessLLM.ps1) Frageprompt: $processedText"

# 5. Logging
"[$dateTime] (ProcessLLM.ps1) Antwortprompt: $answer_prompt" | Out-File -FilePath $logFilePath -Encoding UTF8 -Append

# Antwort in den Zwischenspeicher kopieren
Set-Clipboard -Value $answer_prompt

# 6. Logging
Add-Content -Path $logFilePath -Value "[$dateTime] (ProcessLLM.ps1) >>LLM-Workflow (ProzessLLM.ps1) abgeschlossen!"

<#
.SYNOPSIS
Verarbeitet Anfragen an ein LLM und protokolliert Eingaben sowie Antworten.

.DESCRIPTION
Dieses Skript liest API-Schlüssel aus einer verschlüsselten XML-Datei, sendet Anfragen an ein LLM und loggt die Ergebnisse. 
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

# Aktuelles Verzeichnis ermitteln
$parentDir = Split-Path -Parent (Get-Location)

# Datei "file_manifest.json" auslesen oder erzeugen
$fileManifestPath = "$parentDir\config\file_manifest.json"
if (-Not (Test-Path $fileManifestPath)) {
    Write-Warning "Datei file_manifest.json wurde nicht gefunden. Versuche, die Datei zu erstellen."
    $createManifestScript = "$parentDir\scripts\CreateFileManifest.ps1"
    if (Test-Path $createManifestScript) {
        & $createManifestScript
        if (-Not (Test-Path $fileManifestPath)) {
            Write-Error "Erstellung der Datei file_manifest.json ist fehlgeschlagen."
            exit 1
        }
    } else {
        Write-Error "Skript CreateFileManifest.ps1 wurde nicht gefunden."
        exit 1
    }
}
$fileManifest = Get-Content -Path $fileManifestPath | ConvertFrom-Json

# Dynamische Pfade setzen
$xmlFilePath = $fileManifest."apikey.xml"
$configFilePath = $fileManifest."config.json"
$logFile = $fileManifest."llm_log.txt"

# Überprüfen, ob die notwendigen Dateien existieren
if (-Not (Test-Path $xmlFilePath)) {
    Write-Error "API-Schlüssel-Datei $xmlFilePath wurde nicht gefunden."
    exit 1
}
if (-Not (Test-Path $configFilePath)) {
    Write-Error "Konfigurationsdatei $configFilePath wurde nicht gefunden."
    exit 1
}

# Entschlüsseln des API-Keys
$secureString = Import-Clixml -Path $xmlFilePath
$apiKey = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString))

# Konfigurationsdaten aus config.json lesen
$config = Get-Content -Path $configFilePath | ConvertFrom-Json

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

# Anfrage senden
$answer_prompt = Send-Request -contentText $Text

# Antwort und Eingabe ins Log schreiben mit Datum und Uhrzeit
$dateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"[$dateTime] prompt (question): $Text" | Out-File -FilePath $logFile -Encoding UTF8 -Append
"[$dateTime] prompt (answer): $answer_prompt" | Out-File -FilePath $logFile -Encoding UTF8 -Append

# Antwort in den Zwischenspeicher kopieren
Set-Clipboard -Value $answer_prompt

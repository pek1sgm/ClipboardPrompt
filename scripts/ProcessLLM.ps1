<#
.SYNOPSIS
Verarbeitet Anfragen an ein LLM und protokolliert Eingaben sowie Antworten.

.DESCRIPTION
Dieses Skript liest API-Schlüssel aus einer verschlüsselten XML-Datei, sendet Anfragen an ein LLM und loggt die Ergebnisse. Die Konfigurationsdaten (Modell und URI) werden aus einer JSON-Datei gelesen.

.PARAMETER Text
Der zu sendende Text.

.DEPENDENCIES
- PowerShell 5.1 oder höher
- apikey.xml
- config.json

.OUTPUTS
Protokolldatei: .\logs\llm_log.txt
#>

param (
    [string]$Text = ""
)

# API-Key aus der XML-Datei lesen
$xmlFilePath = "..\config\apikey.xml"

# Entschlüsseln des API-Keys
$secureString = Import-Clixml -Path $xmlFilePath
$apiKey = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString))

# Konfigurationsdaten aus der JSON-Datei lesen
$configFilePath = "..\config\config.json"
if (-Not (Test-Path $configFilePath)) {
    Write-Error "Konfigurationsdatei $configFilePath wurde nicht gefunden."
    exit 1
}
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

# Datei für das Logging festlegen
$logFile = "..\logs\llm_log.txt"

# Anfrage senden
$answer_prompt = Send-Request -contentText $Text

# Antwort und Eingabe ins Log schreiben mit Datum und Uhrzeit
$dateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"[$dateTime] prompt (question): $Text" | Out-File -FilePath $logFile -Encoding UTF8 -Append
"[$dateTime] prompt (answer): $answer_prompt" | Out-File -FilePath $logFile -Encoding UTF8 -Append

# Antwort in den Zwischenspeicher kopieren
Set-Clipboard -Value $answer_prompt

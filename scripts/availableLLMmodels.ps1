# API-Key aus der XML-Datei lesen
$xmlFilePath = ".\config\apikey.xml"

# Entschlüsseln des API-Keys
$secureString = Import-Clixml -Path $xmlFilePath
$apiKey = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString))

# Header festlegen
$headers = @{
    "api-key" = $apiKey
    "Content-Type" = "application/json; charset=utf-8"
}

Invoke-WebRequest -Uri "https://ews-emea.api.bosch.com/knowledge/insight-and-analytics/llms/d/v1/models" `
    -Headers $headers `
    -Method GET `
    -OutFile ".\logs\modelle.txt"

<#
.SYNOPSIS
Speichert einen API-Key verschlüsselt in einer XML-Datei.

.DESCRIPTION
Der API-Schlüssel wird als SecureString in einer XML-Datei gespeichert, um die Sicherheit zu erhöhen.

.PARAMETER ApiKey
Der zu speichernde API-Schlüssel.

.PARAMETER XmlFilePath
Pfad zur XML-Datei (optional).

.EXAMPLES
.\StoreApiKey.ps1 -ApiKey "dein-api-key"
.\StoreApiKey.ps1 -ApiKey "dein-api-key" -XmlFilePath "D:\secure\apikey.xml"
#>

param (
    [string]$ApiKey,
    [string]$XmlFilePath = ".\config\apikey.xml"
)

ConvertTo-SecureString $ApiKey -AsPlainText -Force | Export-Clixml -Path $XmlFilePath
Write-Host "API-Key wurde verschluesselt und in die XML geschrieben: $XmlFilePath"

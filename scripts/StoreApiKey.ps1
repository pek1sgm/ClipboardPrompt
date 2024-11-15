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
.\StoreApiKey.ps1 "dein-api-key"
#>

param (
    [string]$ApiKey,
    [string]$XmlFilePath
)
# Ermittelt das übergeordnete Verzeichnis des aktuellen Skripts
$parentDir = Get-Item -Path (Get-Item -Path $PSScriptRoot).Parent.FullName
$XmlFilePath = "$parentDir\config\apikey.xml"

ConvertTo-SecureString $ApiKey -AsPlainText -Force | Export-Clixml -Path $XmlFilePath
Write-Host "API-Key wurde verschluesselt und in die XML geschrieben: $XmlFilePath"

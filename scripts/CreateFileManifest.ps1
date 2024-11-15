<#
.SYNOPSIS
Erstellt ein Datei-Manifest als JSON-Datei mit allen Dateien im Verzeichnis des Skripts und seinen Unterverzeichnissen.

.BEISPIEL
powershell -ExecutionPolicy Bypass -File CreateFileManifest.ps1
#>

# Ermittelt das übergeordnete Verzeichnis des aktuellen Skripts
$parentDir = Get-Item -Path (Get-Item -Path $PSScriptRoot).Parent.FullName

# Sucht alle Dateien im übergeordneten Verzeichnis und seinen Unterverzeichnissen
$files = Get-ChildItem -Path $parentDir -Recurse -File

# Erstellt eine Hashtabelle zur Speicherung des Datei-Manifests
$fileManifest = @{}

# Füllt die Hashtabelle mit Dateinamen als Schlüssel und vollständigen Pfaden als Werte
$files | ForEach-Object { $fileManifest[$_.Name] = $_.FullName }

# Konvertiert die Hashtabelle in JSON
$json = $fileManifest | ConvertTo-Json -Depth 10

# Schreibt das JSON in eine Datei
$json | Out-File -FilePath "$parentDir\config\file_manifest.json" -Encoding utf8

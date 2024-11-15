# LLM Integration Tool

## Überblick
Dieses Projekt bietet eine Reihe von Skripten und Konfigurationsdateien zur Automatisierung von Anfragen an ein Language Learning Model (LLM). Es kombiniert PowerShell, AutoHotkey und JSON zur einfachen Nutzung und Integration.

## Voraussetzungen
- **AutoHotkey**: Version 1.1.37.02
- **PowerShell**: Version 5.1 oder höher
- **JSON.ahk**: [GitHub-Link zur Bibliothek](https://github.com/cocobelgica/AutoHotkey-JSON)

## Installation
1. **Repository klonen:**

2. **Bibliothek JSON.ahk installieren:**
Lade die Datei herunter und speichere sie im Ordner `ahk/`.

3. **API-Key speichern:**
.\scripts\StoreApiKey.ps1 -ApiKey "dein-api-key"

## Verwendung
### Hotkeys
- **Grammatik korrigieren:** Shift + Strg + Y
- **Ins Englische übersetzen:** Shift + Strg + E
- **Ins Deutsche übersetzen:** Shift + Strg + D

### Logging
Antworten und Eingaben werden in `logs/llm_log.txt` gespeichert.

### Konfigurationsdatei: `config.json`

Die Datei `config.json` enthält die notwendigen Parameter, um das Modell und den URI für die LLM-Anfragen zu definieren. Sie sollte sich im Verzeichnis `config` befinden und folgenden Aufbau haben:

```json
{
    "model": "bigscience/bloomz-7b1",
    "Uri": "https://api-inference.huggingface.co/models/bigscience/bloomz-7b1"
}
```

**Felder:**
- `model`: Der Name des zu verwendenden Modells.
- `Uri`: Der Endpunkt, an den die Anfragen gesendet werden.

Stelle sicher, dass diese Datei korrekt konfiguriert ist, bevor das Skript ausgeführt wird.

## Ordnerstruktur
project-root/
|-- scripts/
|-- ahk/
|-- config/
|-- logs/
|-- README.md
|-- requirements.md

## Lizenz

Dieses Projekt steht unter der GNU General Public License (GPL) Version 2, da AutoHotkey Version 1.1 verwendet wird. Diese Lizenzbedingungen gelten für den gesamten Code dieses Projekts. Mehr Informationen zur GPLv2 findest du [hier](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html).
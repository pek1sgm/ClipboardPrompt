# LLM Clipboard Tool
## Überblick
Dieses Tool automatisiert Anfragen an ein Language Learning Model (LLM) über den Zwischenspeicher (Clipboard) und nutzt curl für die Kommunikation.

## Voraussetzungen
- **AutoHotkey**: Version 1.1.37.02 (befindet sich im Verzeichnis .\ahk)
  - **AutoHotkeyA32.exe**: ANSI-Version für ältere 32-Bit-Systeme ohne Unicode-Support.  
  - **AutoHotkeyU32.exe**: Unicode-Version für moderne 32-Bit-Systeme.  
  - **AutoHotkeyU64.exe**: Unicode-Version für 64-Bit-Systeme, empfohlen für aktuelle Hardware.  
- **JSON.ahk**: (befindet sich im Verzeichnis .\ahk) [GitHub-Link](https://github.com/cocobelgica/AutoHotkey-JSON)
- **PowerShell**: Version 5.1 oder höher

## Installation
1. **Repository klonen:**
`git clone https://github.com/pek1sgm/ClipboardPrompt.git`

2. **install.bat:**
Starte `.\install.bat` (ggf. AutoHotkey-Version anpassen)

3. **Config.json konfigurieren:**
Passe `Config.json` an: --> `"model"` & `"Uri"`

4. **API-Key bereitstellen:**
Starte `.\scripts\StoreApiKey.ps1 "your-personal-api-key"` (verwende dein persönlichen API-key)

## Verwendung
### Hotkeys
- **Grammatik/Stil verbessern:** Shift + Strg + Y
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
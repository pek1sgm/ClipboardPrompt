# LLM Clipboard Tool

## Überblick
Dieses Tool automatisiert Anfragen an ein Language Learning Model (LLM) über den Zwischenspeicher (Clipboard) und nutzt curl für die Kommunikation.

## Voraussetzungen
- **AutoHotkey**: Version 1.1.37.02 (befindet sich im Verzeichnis `./ahk`)
  - **AutoHotkeyU32.exe**: Unicode-Version für moderne 32-Bit-Systeme.
  - **AutoHotkeyU64.exe**: Unicode-Version für 64-Bit-Systeme, empfohlen für aktuelle Hardware.
- **JSON.ahk**: (befindet sich im Verzeichnis `./ahk`) [GitHub-Link](https://github.com/cocobelgica/AutoHotkey-JSON)
- **PowerShell**: Version 5.1 oder höher

## Installation
1. **Repository klonen:**
   ```
   git clone https://github.com/pek1sgm/ClipboardPrompt.git
   ```

2. **Config.json anpassen:**
   Passe `config.json` an: Fülle die Felder "model" und "Uri" aus. Generiere einen API-Schlüssel. Empfohlenes Modell: `meta-llama/Meta-Llama-3.1-70B-Instruct`.

3. **install.bat ausführen:**
   Starte `./install.bat` (es wird ein API-Schlüssel abgefragt).

## Verwendung
### Hotkeys
- **Grammatik/Stil verbessern:** Shift + Strg + Y
- **Ins Englische übersetzen:** Shift + Strg + E
- **Ins Deutsche übersetzen:** Shift + Strg + D

### Logging
Antworten und Eingaben werden in `logs/llm_log.txt` gespeichert. Die Log-Datei wird nach dem ersten Aufruf von `install.bat` erstellt.

### Konfigurationsdatei: `config.json`
Die Datei `config.json` enthält die notwendigen Parameter, um das Modell und den URI für die LLM-Anfragen zu definieren. Sie sollte sich im Verzeichnis `config` befinden und folgenden Aufbau haben:

```json
{
    "model": "meta-llama/Meta-Llama-3.1-70B-Instruct",
    "Uri": "https://api-inference.huggingface.co/models/meta-llama/Meta-Llama-3.1-70B-Instruct"
}
```

Die Implementierung und die Anfrage, die im PowerShell-Skript (LLM-Workflow) verwendet wird, wurden mit dem Modell `meta-llama/Meta-Llama-3.1-70B-Instruct` entwickelt und getestet. Bei der Verwendung anderer Modelle muss der LLM-Workflow ggf. angepasst werden.

**Felder:**
- `model`: Der Name des zu verwendenden Modells.
- `Uri`: Der Endpunkt, an den die Anfragen gesendet werden.

Stelle sicher, dass diese Datei korrekt konfiguriert ist, bevor das Skript ausgeführt wird.

## Ordnerstruktur
```
project-root/
|-- scripts/
|-- ahk/
|-- config/
|-- logs/
|-- README.md
|-- requirements.md
|-- install.bat
```

## Lizenz
Dieses Projekt steht unter der GNU General Public License (GPL) Version 2, da AutoHotkey Version 1.1 verwendet wird. Diese Lizenzbedingungen gelten für den gesamten Code dieses Projekts. Mehr Informationen zur GPLv2 findest du [hier](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html).


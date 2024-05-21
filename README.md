# Chrome Downloader Script

This PowerShell script automates the process of downloading and organizing Google Chrome installers based on specified configurations. It supports downloading both 64-bit and 32-bit versions of Chrome and organizing them into appropriate folders.

## Script Overview

### Configuration

The script reads its configuration from a JSON file named `config.json` located in the same directory as the script. The configuration options include:

- `enableRegularVersion`: Boolean flag to enable the downloading of the regular version of Chrome.
- `enableForcedVersion`: Boolean flag to enable the downloading of the forced update version of Chrome.

### Configuration File (`config.json`)

```json
{
  "options": {
    "enableRegularVersion": true,
    "enableForcedVersion": false
  }
}
```
## Script Usage
### 1. Prepare the Environment:

Ensure that config.json is present in the same directory as the script.
Create the following template folders and populate them with necessary files:
- `Template\Chrome-Template`
- `Template\Chrome-Template-Forced`

### 2. Run the Script:

- Open PowerShell and navigate to the directory containing the script and config.json.
- Execute the script:
```javascript
.\YourScriptName.ps1
```

### 3. Monitor the Logs:

- Check `Log.txt` in the script directory for detailed logs of the execution process, including any errors encountered.

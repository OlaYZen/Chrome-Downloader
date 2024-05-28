# Google Chrome Downloader MSI Script

This PowerShell script automates the process of downloading and organizing Google Chrome installers based on specified configurations. It supports downloading both 64-bit and 32-bit versions of Chrome and organizing them into appropriate folders.

## Script Overview

## Configuration

The script reads its configuration from a JSON file named config.json located in the same directory as the script. The configuration options include:

### Configuration File
The `config.json` file should be structured as follows:
```json
{
  "options": {
    "enableRegularVersion": true,
    "enableForcedVersion": false,
    "folderNumberedVersion": false,
    "checkExist": false
  },
  "logging": {
    "fileName": "chrome_downloader.log",
    "logDateFormat": "dd/MM/yyyy HH:mm:ss"

  }
}
```

- `enableRegularVersion`: A boolean flag to enable downloading and installing the regular version of Chrome.
- `enableForcedVersion`: A boolean flag to enable downloading and installing the forced update version of Chrome.
- `folderNumberedVersion`: A boolean flag to enable the automatic renaming of the folder to the newest version of Chrome. ⚠️ **This option requires administrative privileges when executing the script!** ⚠️
- `checkExist`: A boolean flag to delete old Chrome folders when the script is executed. ⚠️ **This action will delete your Chrome folders, so ensure you have backups if you wish to retain them.** ⚠️
- `fileName`: A string defining the name of the log file. The default format is `chrome_downloader.log`.
- `logDateFormat`: A string defining the format of timestamps in logs. The default format is `dd/MM/yyyy HH:mm:ss`.


### Date Configuration

##### `yyyy`: This specifier represents the year portion of the date. It uses four digits to represent the year. For example, 2024.

##### `MM`: This specifier represents the month portion of the date. It uses two digits to represent the month, with leading zeros if necessary. For example, 05 represents May.

##### `dd`: This specifier represents the day portion of the date. It uses two digits to represent the day of the month, with leading zeros if necessary. For example, 23.

##### `HH`: This specifier represents the hour portion of the time in 24-hour format. It uses two digits to represent the hour, ranging from 00 to 23. For example, 14 represents 2 PM in 24-hour format.

<details>
<summary><b>More info on HH format</b></summary>

##### `HH` (24-hour format): When HH is used, it represents the hour portion of the time in a 24-hour format, where the hour is represented with two digits from 00 to 23. The HH specifier does not use AM/PM designators since it covers the full 24-hour range. Example: HH:mm:ss might output 14:30:00, representing 2:30 PM in 24-hour format.

##### `hh` (12-hour format): When hh is used, it represents the hour portion of the time in a 12-hour format, where the hour is represented with one or two digits from 1 to 12. The hh specifier is typically used alongside the tt specifier (AM/PM designator) to indicate whether the time is in the AM or PM. Example: hh:mm:ss tt might output 02:30:00 PM, representing 2:30 PM.
</details>



##### `mm`: This specifier represents the minute portion of the time. It uses two digits to represent the minutes, with leading zeros if necessary. For example, 30.

##### `ss`: This specifier represents the second portion of the time. It uses two digits to represent the seconds, with leading zeros if necessary. For example, 45.

##### `tt`: This specifier represents the AM/PM designator in a 12-hour time format. It is typically used alongside the hh specifier to indicate whether the time is in the AM or PM. For example, AM or PM.

### Examples

```json
"logDateFormat": "yyyy'/'MM'/'dd hh:mm:ss tt"
```
Output: <code>2024/06/29 03:19:30 p.m.</code>

```json
"logDateFormat": "MM/dd/yyyy HH:mm:ss"
```
Output: <code>06.29.2024 15:19:30</code>

```json
"logDateFormat": "dd-MM-yyyy HH:mm:ss"
```
Output: <code>29-06-2024 15:19:30</code>

### Numbered Version
`folderNumberedVersion`: Set this to `true` to enable automatic renaming of the folder based on the downloaded Chrome version. This action requires administrative privileges.

For example, if this option is enabled, the folders will be named as follows:

`false`:
```css
Chrome - VERSION_force_update
```

`true`:
```css
Chrome - 125.0.6422.113_force_update
```

The `folderNumberedVersion` configuration requires administrative privileges because the only way to obtain the Chrome version number is by installing the MSI file and retrieving the version from the Windows registry.

## Script Usage
### 1. Prepare the Environment:

Ensure that `config.json` is present in the same directory as the script.
Create the following template folders and populate them with necessary files:
- `Template\Chrome-Template`
- `Template\Chrome-Template-Forced`

### 2. Downloading the Script:

You can download the script using `git clone` command. Follow these steps:

1. Open your terminal or command prompt.
2. Navigate to the directory where you want to download the script.
3. Run the following command:
```
git clone https://github.com/OlaYZen/Chrome-Downloader.git
```

This command will clone the repository into your current directory.

### 3. Run the Script:

- Open PowerShell and navigate to the directory containing the script and config.json.
- Execute the script:
```css
& '.\Chrome Downloader.ps1' 
```

### 4. Monitor the Logs:

- Check `chrome_downloader.log` in the script directory for detailed logs of the execution process, including any errors encountered.

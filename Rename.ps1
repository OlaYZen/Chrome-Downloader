# Read configuration from JSON file
$configPath = "$PSScriptRoot\config.json"
$config = Get-Content -Path $configPath | ConvertFrom-Json

$destinationFolder = Join-Path -Path $PSScriptRoot -ChildPath "Chrome - VERSION"
$forceUpdateFolder = Join-Path -Path $PSScriptRoot -ChildPath "Chrome - VERSION_force_update"

function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format $dateFormat
    Write-Output "[$timestamp] - $message" | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8
}

if ($config.options.enableRegularVersion -and -not $config.options.enableForcedVersion) {
    $msiPath = "$PSScriptRoot\Chrome - VERSION\Files\googlechromestandaloneenterprise64.msi"
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$msiPath`" /quiet" -Wait
    $chromeRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    $chromeVersion = Get-ChildItem -Path $chromeRegPath |
                        Get-ItemProperty |
                        Where-Object { $_.DisplayName -like "*Google Chrome*" } |
                        Select-Object -ExpandProperty DisplayVersion
    # Rename the folder if the version was retrieved
    if ($chromeVersion) {
        $newFolderName = "Chrome - $chromeVersion"
        $newFolderPath = Join-Path -Path $PSScriptRoot -ChildPath $newFolderName
        try {
            Rename-Item -Path $destinationFolder -NewName $newFolderName -ErrorAction Stop
            Log-Message "Success: Folder renamed to $newFolderName"
        } catch {
            Log-Message "Error: Failed to rename folder - $_"
        }
    } else {
        Log-Message "Warning: Chrome version could not be determined. Folder was not renamed."
    }
}
elseif ($config.options.enableForcedVersion -and -not $config.options.enableRegularVersion) {
    $msiPath = "$PSScriptRoot\Chrome - VERSION_force_update\googlechromestandaloneenterprise64.msi"
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$msiPath`" /quiet" -Wait
    $chromeRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    $chromeVersion = Get-ChildItem -Path $chromeRegPath |
                        Get-ItemProperty |
                        Where-Object { $_.DisplayName -like "*Google Chrome*" } |
                        Select-Object -ExpandProperty DisplayVersion
    # Rename the folder if the version was retrieved
    if ($chromeVersion) {
        $newFolderName = "Chrome - $chromeVersion" + "_force_update"
        $newFolderPath = Join-Path -Path $PSScriptRoot -ChildPath $newFolderName
        try {
            Rename-Item -Path $forceUpdateFolder -NewName $newFolderName -ErrorAction Stop
            Log-Message "Success: Folder renamed to $newFolderName"
        } catch {
            Log-Message "Error: Failed to rename folder - $_"
        }
    } else {
        Log-Message "Warning: Chrome version could not be determined. Folder was not renamed."
    }
}
elseif ($config.options.enableForcedVersion -and $config.options.enableRegularVersion) {
    $msiPath = "$PSScriptRoot\Chrome - VERSION_force_update\googlechromestandaloneenterprise64.msi"
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$msiPath`" /quiet" -Wait

    $chromeRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    $chromeVersion = Get-ChildItem -Path $chromeRegPath |
                        Get-ItemProperty |
                        Where-Object { $_.DisplayName -like "*Google Chrome*" } |
                        Select-Object -ExpandProperty DisplayVersion

    # Rename both folders if the version was retrieved
    if ($chromeVersion) {
        # Regular version folder
        $newRegularFolderName = "Chrome - $chromeVersion"
        try {
            Rename-Item -Path $destinationFolder -NewName $newRegularFolderName -ErrorAction Stop
            Log-Message "Success: Folder renamed to $newRegularFolderName"
        } catch {
            Log-Message "Error: Failed to rename folder - $_"
        }

        # Forced version folder
        $newForcedFolderName = "Chrome - $chromeVersion" + "_force_update"
        try {
            Rename-Item -Path $forceUpdateFolder -NewName $newForcedFolderName -ErrorAction Stop
            Log-Message "Success: Folder renamed to $newForcedFolderName"
        } catch {
            Log-Message "Error: Failed to rename folder - $_"
        }
    } else {
        Log-Message "Warning: Chrome version could not be determined. Folders were not renamed."
    }
}

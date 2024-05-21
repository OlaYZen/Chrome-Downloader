# Read configuration from JSON file
$configPath = "$PSScriptRoot\config.json"
$config = Get-Content -Path $configPath | ConvertFrom-Json

# Log the start of the script
Write-Output "[$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")] - Script initiation: Chrome Downloader" | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8

# Check if both options are disabled and log a message
if (-not $config.options.enableRegularVersion -and -not $config.options.enableForcedVersion) {
    Write-Output "[$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")] - Configuration error: Both Regular and Forced versions are disabled. Please enable at least one option to proceed." | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8
    exit
}

# Define URLs
$url1 = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
$url2 = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise.msi"

# Define source and destination folders
$sourceFolderRegular = "$PSScriptRoot\Template\Chrome-Template"
$sourceFolderForced = "$PSScriptRoot\Template\Chrome-Template-Forced"

$destinationFolder = Join-Path -Path $PSScriptRoot -ChildPath "Chrome - VERSION"
$forceUpdateFolder = Join-Path -Path $PSScriptRoot -ChildPath "Chrome - VERSION_force_update"

# Conditional execution based on config
if ($config.options.enableRegularVersion) {
    # Create main folder and files folder if they don't exist
    $folderName = "Chrome - VERSION"
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $folderName
    $filesFolder = Join-Path -Path $folderPath -ChildPath "Files"

    if (-not (Test-Path $filesFolder)) {
        try {
            New-Item -Path $filesFolder -ItemType Directory -ErrorAction Stop
            Write-Output "[$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")] - Directory creation: 'Chrome - VERSION' and 'Files' folder successfully created in $PSScriptRoot" | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8
        } catch {
            Write-Output "[$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")] - Error: Directory creation failed - $_" | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8
        }
    }

    # Copy items from source folder to destination folder
    try {
        Copy-Item -Path $sourceFolderRegular\* -Destination $destinationFolder -Recurse -Force -ErrorAction Stop
        Write-Output "[$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")] - Success: Regular Template successfully copied to $destinationFolder" | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8
    } catch {
        Write-Output "[$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")] - Error: Failed to copy Regular Template - $_" | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8
    }
    
    # Download 64-bit Chrome installer
    $fileName1 = [System.IO.Path]::GetFileName($url1)
    $filePath1 = Join-Path -Path $filesFolder -ChildPath $fileName1
    try {
        Invoke-RestMethod -Uri $url1 -OutFile $filePath1 -ErrorAction Stop
        Write-Output "[$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")] - Download complete: 64-bit version of Chrome successfully downloaded to $filePath1" | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8
    } catch {
        Write-Output "[$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")] - Error: 64-bit Chrome download failed - $_" | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8
    }

    # Download 32-bit Chrome installer
    $fileName2 = [System.IO.Path]::GetFileName($url2)
    $filePath2 = Join-Path -Path $filesFolder -ChildPath $fileName2
    try {
        Invoke-RestMethod -Uri $url2 -OutFile $filePath2 -ErrorAction Stop
        Write-Output "[$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")] - Download complete: 32-bit version of Chrome successfully downloaded to $filePath2" | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8
    } catch {
        Write-Output "[$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")] - Error: 32-bit Chrome download failed - $_" | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8
    }
}

if ($config.options.enableForcedVersion) {
    # Create force update folder if it doesn't exist
    if (-not (Test-Path $forceUpdateFolder)) {
        try {
            New-Item -Path $forceUpdateFolder -ItemType Directory -ErrorAction Stop
            Write-Output "[$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")] - Directory creation: 'Chrome - VERSION_force_update' successfully created in $PSScriptRoot" | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8
        } catch {
            Write-Output "[$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")] - Error: Force update directory creation failed - $_" | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8
        }
    }

    # Copy items from forced source folder to force update folder
    try {
        Copy-Item -Path "$sourceFolderForced\*" -Destination $forceUpdateFolder -Recurse -Force -ErrorAction Stop
        Write-Output "[$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")] - Success: Forced Template successfully copied to $forceUpdateFolder" | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8
    } catch {
        Write-Output "[$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")] - Error: Failed to copy Forced Template - $_" | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8
    }

    # If the regular version is not enabled, download 64-bit Chrome installer directly to the force update folder
    if (-not $config.options.enableRegularVersion) {
        $fileName1 = [System.IO.Path]::GetFileName($url1)
        $filePath1 = Join-Path -Path $forceUpdateFolder -ChildPath $fileName1
        try {
            Invoke-RestMethod -Uri $url1 -OutFile $filePath1 -ErrorAction Stop
            Write-Output "[$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")] - Download complete: 64-bit version of Chrome successfully downloaded to force update folder at $filePath1" | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8
        } catch {
            Write-Output "[$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")] - Error: 64-bit Chrome download to force update folder failed - $_" | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8
        }
    } else {
        # If the regular version is enabled, copy the downloaded 64-bit installer to the force update folder
        $fileName1 = [System.IO.Path]::GetFileName($url1)
        $filePath1 = Join-Path -Path $filesFolder -ChildPath $fileName1
        if (Test-Path $filePath1) {
            try {
                Copy-Item -Path $filePath1 -Destination $forceUpdateFolder -Force -ErrorAction Stop
                Write-Output "[$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")] - Success: 64-bit version of Chrome copied to force update folder at $forceUpdateFolder" | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8
            } catch {
                Write-Output "[$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")] - Error: Failed to copy 64-bit installer to force update folder - $_" | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8
            }
        } else {
            Write-Output "[$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")] - Warning: 64-bit version of Chrome was not downloaded and could not be copied to force update folder." | Out-File -Append -FilePath "$PSScriptRoot\Log.txt" -Encoding utf8
        }
    }
}

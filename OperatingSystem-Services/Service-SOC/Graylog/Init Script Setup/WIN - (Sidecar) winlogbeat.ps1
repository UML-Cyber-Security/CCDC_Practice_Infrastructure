############################
# Powershell script to download and setup
# graylog sidecar with Winlogbeat logging
# NO TLS IN THIS VERSION!
############################

$downloadUrl = "https://github.com/Graylog2/collector-sidecar/releases/download/1.5.0/graylog_sidecar_installer_1.5.0-1.exe"
$destination = "$([Environment]::GetFolderPath('UserProfile'))\Downloads\graylog_sidecar_installer_1.5.0-1.exe"

# Prompt user for Graylog server URL and API token
$graylogServerUrl = Read-Host "Enter the GRAYLOG API Server URL (EX: http://<IP_HERE>:9000/api )"
$apiToken = Read-Host "Enter the API token for the Graylog Sidecar"

# Download the installer
Write-Host "Downloading Graylog Sidecar installer..."
Invoke-WebRequest -Uri $downloadUrl -OutFile $destination -ErrorAction Stop
Write-Host "Installer downloaded to $destination"

# Run the installer with provided parameters
Write-Host "Running the Graylog Sidecar installer..."
Start-Process -FilePath $destination -ArgumentList "/S", "-SERVERURL=$graylogServerUrl", "-APITOKEN=$apiToken" -Wait

# Check if installation succeeded
$sidecarPath = "C:\Program Files\graylog\sidecar\graylog-sidecar.exe"
if (Test-Path $sidecarPath) {
    Write-Host "Graylog Sidecar installed successfully. Proceeding with service setup."
    & "$sidecarPath" -service install
    & "$sidecarPath" -service start

    Write-Host "Graylog Sidecar service installed and started successfully."
} else {
    Write-Host "Installation failed. Please check the installer log for details."
}

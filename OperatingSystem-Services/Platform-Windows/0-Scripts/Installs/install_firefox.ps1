# Set the URL for the Firefox installer
$firefoxInstallerUrl = "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US"

# Set the path where the installer will be saved
$installerPath = "$env:TEMP\firefox_installer.exe"

# Download the installer
Invoke-WebRequest -Uri $firefoxInstallerUrl -OutFile $installerPath

# Run the installer silently
Start-Process -FilePath $installerPath -Args "/S" -Wait

# Clean up the installer
Remove-Item -Path $installerPath

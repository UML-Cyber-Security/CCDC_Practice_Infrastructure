# Download Nmap installer
$installerUrl = "https://nmap.org/dist/nmap-7.94-setup.exe"
$installerPath = "nmap-7.94-setup.exe"
Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

# Install Nmap silently
Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait

# Clean up the installer file
Remove-Item -Path $installerPath

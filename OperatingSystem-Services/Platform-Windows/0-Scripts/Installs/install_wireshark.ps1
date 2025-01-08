# Download Wireshark installer
$installerUrl = "https://2.na.dl.wireshark.org/win64/Wireshark-4.2.3-x64.exe"
$installerPath = "wireshark.exe"
Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

# Install Wireshark silently
Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait

# Clean up the installer file
Remove-Item -Path $installerPath

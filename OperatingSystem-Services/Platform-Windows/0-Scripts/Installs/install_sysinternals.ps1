# Installs and extracts Sysinternals Suite

# Download URL and the destination path
$url = "https://download.sysinternals.com/files/SysinternalsSuite.zip"
$destination = "$env:USERPROFILE\Downloads\SysinternalsSuite.zip"
$extractPath = "$env:USERPROFILE\Documents\Sysinternals"
$importantToolsPath = "$env:USERPROFILE\Documents\Important-Sysinternals"

# Relevant Sysinternals tools to copy
$importantTools = @('procexp64.exe, Procmon64.exe', 'Autoruns64.exe', 'PsLoggedOn.exe', 'LogonSessions.exe', 'AccessChk.exe', 'VMMap.exe', 'Sigcheck.exe', 'Tcpview.exe', 'PsService.exe')

# Download the zip file
Invoke-WebRequest -Uri $url -OutFile $destination

# Extract the zip file
Expand-Archive -Path $destination -DestinationPath $extractPath

# Create Important-Sysinternals directory if it doesn't exist
if (-not (Test-Path $importantToolsPath)) {
    New-Item -Path $importantToolsPath -ItemType Directory
}

# Copy the relevant tools to Important-Sysinternals
foreach ($tool in $importantTools) {
    Copy-Item -Path "$extractPath\$tool" -Destination $importantToolsPath
}

Write-Output "Sysinternals Suite installed and relevant tools copied to Important-Sysinternals."

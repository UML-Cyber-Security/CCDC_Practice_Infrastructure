# First 15 Minutes in Windows (including commands)

#### First Steps
1 - Need to gain access to machines 
  - Split this between each of us Johnny on security so he gets precedence on choice 
2 - Run NMAP scans if needed to get network topology
3 - Once in machines we can run through steps below

#### Notes
1 - Don't forget about GPOs and their ability of enabling/disabling domain wide firewall rules, password complexities, and more

#### Downloading FireFox
```sh
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
```

#### Download NMAP
(Doesn't fully work rn)
```sh
# Define the URL for the Nmap installer
$nmapUrl = "https://nmap.org/dist/nmap-7.93-setup.exe"

# Define the path to save the installer
$installerPath = "$env:USERPROFILE\Downloads\nmap-setup.exe"

# Download the installer
Invoke-WebRequest -Uri $nmapUrl -OutFile $installerPath

# Define the silent install arguments
# /S -> Silent install
# /D=<path> -> Destination directory (optional, specify if needed)
# Npcap options:
#   /NpcapInstallMode=1 -> Install Npcap in WinPcap API-compatible mode
#   /NpcapInstallMode=0 -> Don't install Npcap (use if you don't need it)

$installArguments = '/S /NpcapInstallMode=1'

# Run the installer with the silent arguments
Start-Process -FilePath $installerPath -ArgumentList $installArguments -Wait

# Clean up the installer after installation
Remove-Item -Path $installerPath -Force

Write-Host "Nmap installation completed!"
```

#### Wireshark
(If needed for some evidence)

```sh
# Download Wireshark installer
$installerUrl = "https://2.na.dl.wireshark.org/win64/Wireshark-4.2.3-x64.exe"
$installerPath = "wireshark.exe"
Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

# Install Wireshark silently
Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait

# Clean up the installer file
Remove-Item -Path $installerPath
```


#### FireWall Rules
```sh

# Enable Windows Firewall for all profiles (Domain, Private, Public)
Set-NetFirewallProfile -All -Enabled True

# Ensure that the script is running with Administrator privileges
$IsAdmin = [bool]([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Host "This script must be run as Administrator. Please re-run the script with elevated privileges."
    exit
}

# Enable Remote Desktop (RDP) Firewall Rule
Write-Host "Enabling Remote Desktop Firewall rule..."
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Enable File and Printer Sharing Firewall Rules
Write-Host "Enabling File and Printer Sharing Firewall rules..."
Enable-NetFirewallRule -DisplayGroup "File and Printer Sharing"

# Enable ICMP (Ping) - Allowing ICMP Echo Requests for network diagnostics
Write-Host "Enabling ICMP Echo Requests (Ping)..."
Enable-NetFirewallRule -DisplayGroup "Windows Defender Firewall Remote Management"

# Enable inbound traffic for Windows Defender if security software is enabled
Write-Host "Enabling Windows Defender inbound rules..."
Enable-NetFirewallRule -DisplayGroup "Windows Defender Firewall"

# If you want to enable specific RDP port (3389) explicitly
Write-Host "Enabling RDP port (3389) manually..."
New-NetFirewallRule -Name "Allow RDP" -DisplayName "Allow RDP" -Enabled True -Protocol TCP -LocalPort 3389 -Action Allow -Direction Inbound

Write-Host "Firewall rules have been successfully enabled. You should now be able to access the machine via RDP and other network services."


# Confirm firewall status
Get-NetFirewallProfile
```

#### Disable Local Accounts
```sh
# Disable all local user accounts except specified exclusions

# Current user and excluded accounts
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$excludedAccounts = @("blackteam") # Add any other accounts to this array if needed

# Disable local accounts
Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount='True'" | 
Where-Object { $_.Name -ne $currentUser.Split('\')[1] -and $excludedAccounts -notcontains $_.Name } | 
ForEach-Object {
    $username = $_.Name
    net user $username /active:no
    Write-Host "Disabled local account: $username"
}
```

#### Disable AD Accounts
```sh
# Disable all domain user accounts except specified exclusions

# If ActiveDirectory module isn't loaded, try to import it
$ActiveDirectoryModuleAvailable = $true
if (-not (Get-Module -Name ActiveDirectory -ErrorAction SilentlyContinue)) {
    try {
        Import-Module ActiveDirectory
    } catch {
        Write-Warning "Failed to import ActiveDirectory module. Make sure it's installed."
        $ActiveDirectoryModuleAvailable = $false
    }
}

# Disable AD accounts, if ActiveDirectory module is available
if ($ActiveDirectoryModuleAvailable) {
    # Current user and excluded accounts
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $excludedAccounts = @("blackteam") # Add any other accounts to this array if needed

    try {
        Get-ADUser -Filter * | 
        Where-Object { $_.SamAccountName -ne $currentUser.Split('\')[1] -and $excludedAccounts -notcontains $_.SamAccountName } | 
        ForEach-Object {
            $username = $_.SamAccountName
            Disable-ADAccount -Identity $username
            Write-Host "Disabled AD account: $username"
        }
    } catch {
        Write-Warning "Failed to disable AD accounts. Make sure you have the necessary permissions."
    }
}
```

#### Dumping
If you want to dump information, navigate to Dumping to 0-Scripts in Windows

#### Resetting Local Account Password
```sh
net user [username] *
```

#### Resetting AD Account Passwords
```sh
Set-ADAccountPassword -Identity "Administrator" -NewPassword (ConvertTo-SecureString "NewP@ssw0rd" -AsPlainText -Force) -Reset
```

#### Kicking RDP Sessions
```sh
# Check if ActiveDirectory module is available
if (Get-Module -ListAvailable -Name ActiveDirectory) {
        # Import the Active Directory module
        Import-Module ActiveDirectory

        # Get all disabled users
        $disabledUsers = Get-ADUser -Filter 'Enabled -eq $false' | Select-Object -ExpandProperty SamAccountName

        # For each disabled user
        foreach ($user in $disabledUsers) {
                # Get the session ID of the user
                $sessionId = ((quser | Where-Object { $_ -match $user }) -split ' +')[2]
                
                # If the session ID exists, log off the user
                if ($sessionId) {
                        logoff $sessionId
                }
        }
}
    
# Get all local users
$localUsers = Get-LocalUser

# For each local user
foreach ($user in $localUsers) {
        # If the user is disabled
        if ($user.Enabled -eq $false) {
                # Get the session ID of the user
                $sessionId = ((quser | Where-Object { $_ -match $user.Name }) -split ' +')[2]
                
                # If the session ID exists, log off the user
                if ($sessionId) {
                        logoff $sessionId
                }
        }
}
```
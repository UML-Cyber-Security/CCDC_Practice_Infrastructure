# 1. Disable local accounts
# 2. Disable WinRM
# 3. Kick RDP Users
# 4. Stop SSH
# 5. Uninstall OpenSSH

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

# 2. Disable Win-RM
# Stop the WinRM service
Stop-Service -Name WinRM -Force

# Disable the WinRM service
Set-Service -Name WinRM -StartupType Disabled

# Output the status of the WinRM service
Get-Service -Name WinRM | Format-Table Name, Status, StartType -AutoSize

# 3. Kick RDP Users
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

# 4. Stop SSH

Stop-Service sshd

# Get all firewall rules related to TCP port 22
$rules = Get-NetFirewallRule | Where-Object { $_.DisplayGroup -eq 'OpenSSH Server' }

# Remove each found rule
foreach ($rule in $rules) {
    Remove-NetFirewallRule -DisplayName $rule.DisplayName
    Write-Host "Removed firewall rule: $($rule.DisplayName)"
}

# Confirmation message
Write-Host "All firewall rules related to TCP port 22 have been removed."

# 5. Uninstall OpenSSH
# Check if OpenSSH Client is installed
$OpenSSHClient = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Client*'

if ($OpenSSHClient -and $OpenSSHClient.State -eq 'Installed') {
    # Uninstall the OpenSSH Client
    Remove-WindowsCapability -Online -Name $OpenSSHClient.Name
    Write-Host "OpenSSH Client was installed and has now been removed."
} else {
    Write-Host "OpenSSH Client is not installed."
}

# Check if OpenSSH Server is installed
$OpenSSHServer = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'

if ($OpenSSHServer -and $OpenSSHServer.State -eq 'Installed') {
    # Uninstall the OpenSSH Server
    Remove-WindowsCapability -Online -Name $OpenSSHServer.Name
    Write-Host "OpenSSH Server was installed and has now been removed."
} else {
    Write-Host "OpenSSH Server is not installed."
}

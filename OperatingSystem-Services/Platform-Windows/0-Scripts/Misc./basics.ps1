#Generating Random Password
# Define parameters for the password
$length = 16  # Set the desired password length
$lowercase = "abcdefghijklmnopqrstuvwxyz"
$uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
$numbers = "0123456789"
$specialChars = "!@#$%^&*()-_=+[]{}|;:,.<>?/`~"

# Combine all character sets
$allChars = $lowercase + $uppercase + $numbers + $specialChars

# Create a random password by selecting characters randomly from the combined set
$password = -join ((1..$length) | ForEach-Object { $allChars[(Get-Random -Minimum 0 -Maximum $allChars.Length)] })

# Output the generated password
Write-Output "Generated Password: $password"


#------------------------------------------------------

# Enable Windows Firewall for all profiles (Domain, Private, Public)
Set-NetFirewallProfile -All -Enabled True

# Confirm firewall status
Get-NetFirewallProfile

#-------------------------------
# Disable Sticky Keys
Write-Output "Disabling Sticky Keys..."
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Value 506

# Disable AutoPlay
Write-Output "Disabling AutoPlay..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Value 0x000000FF
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoAutorun" -Value 1

# Disable Utility Manager (which is accessible via the "Windows + U" shortcut)
Write-Output "Disabling Utility Manager..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "DisableUtilityManager" -Value 1

# Disable Narrator
Write-Output "Disabling Narrator..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "DisableNarrator" -Value 1

Write-Output "All specified features have been disabled using Set-ItemProperty."


#------------------------------


# Disable Autorun Commands
Write-Output "Disabling autorun commands..."

# Disable Autorun for all drives by setting the relevant registry keys
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 255 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d 1 /f

# Disable Autorun for all drives (global setting)
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 255 /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d 1 /f

Write-Output "Autorun commands have been disabled."

# Prevent Empty Password Login
Write-Output "Preventing login with empty passwords..."

# Set the registry to prevent login with blank passwords
reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "LimitBlankPasswordUse" /t REG_DWORD /d 1 /f

Write-Output "Login with empty passwords has been prevented."

# Force Group Policy Update (to apply the changes)
gpupdate /force

Write-Output "Changes have been applied successfully."

#------------------------------------------------------
# Function to calculate entropy of a string (higher entropy = more randomness)
function Get-Entropy {
    param (
        [string]$inputString
    )
    
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($inputString)
    $byteCount = $bytes.Length
    $frequencies = @{}
    
    foreach ($byte in $bytes) {
        if ($frequencies.ContainsKey($byte)) {
            $frequencies[$byte] += 1
        } else {
            $frequencies[$byte] = 1
        }
    }
    
    $entropy = 0
    foreach ($frequency in $frequencies.Values) {
        $p = $frequency / $byteCount
        $entropy -= $p * [Math]::Log($p, 2)
    }
    
    return $entropy
}

# Function to check if the service binary is signed
function Check-Signature {
    param (
        [string]$filePath
    )

    try {
        $file = Get-AuthenticodeSignature -FilePath $filePath
        if ($file.Status -eq 'Valid') {
            return $true  # The file is signed
        }
        return $false  # The file is not signed
    } catch {
        return $false  # Error while checking signature
    }
}

# Define suspicious file extensions
$suspiciousExtensions = @(".dll", ".scr", ".bat", ".vbs", ".js")

# Function to identify suspicious services
function Get-SuspiciousServices {
    Write-Output "Scanning for suspicious services..."

    # Get all services on the system
    $services = Get-WmiObject -Class Win32_Service

    # Initialize an array to hold suspicious services
    $suspiciousServices = @()

    # Iterate through all services and check criteria
    foreach ($service in $services) {
        $serviceName = $service.Name
        $serviceDisplayName = $service.DisplayName
        $servicePath = $service.PathName
        $serviceStatus = $service.State
        $serviceStartType = $service.StartMode

        # Check if the service binary has a suspicious extension
        $fileExtension = [System.IO.Path]::GetExtension($servicePath).ToLower()
        if ($suspiciousExtensions -contains $fileExtension) {
            $suspiciousServices += $service
            continue
        }

        # Check if the service binary is unsigned
        if (-not (Check-Signature -filePath $servicePath)) {
            $suspiciousServices += $service
            continue
        }

        # Check if the service path has high entropy (indicating possible obfuscation)
        $entropy = Get-Entropy -inputString $servicePath
        if ($entropy -gt 4.5) {  # Higher entropy indicates potential obfuscation
            $suspiciousServices += $service
        }
    }

    # If suspicious services are found, display them to the user
    if ($suspiciousServices.Count -gt 0) {
        Write-Output "Suspicious services found:"
        $suspiciousServices | Format-Table -Property Name, DisplayName, State, StartMode, PathName
    } else {
        Write-Output "No suspicious services found."
    }
}

# Run the function to check for suspicious services
Get-SuspiciousServices

#------------------------------------

# Script to perform basic security hardening on a Windows machine

# 1. Enable Windows Defender Antivirus (if not already enabled)
Write-Output "Enabling Windows Defender Antivirus..."
Set-MpPreference -DisableRealtimeMonitoring $false  # Enables real-time protection
Set-MpPreference -EnableNetworkProtection $true     # Enables network protection
Set-MpPreference -DisableBehaviorMonitoring $false  # Enables behavior monitoring

# 2. Enable Windows Firewall (if not enabled)
Write-Output "Enabling Windows Firewall..."
Set-NetFirewallProfile -All -Enabled True  # Enables firewall for all profiles (Domain, Private, Public)

# 3. Disable SMBv1 (outdated and vulnerable version of SMB)
Write-Output "Disabling SMBv1..."
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart

# 4. Disable unnecessary services (e.g., Remote Desktop, Remote Assistance)
#Write-Output "Disabling Remote Desktop and Remote Assistance..."
#Stop-Service -Name TermService -Force      # Stop Remote Desktop Service
#Set-Service -Name TermService -StartupType Disabled  # Disable Remote Desktop on startup
#Stop-Service -Name RemoteAssistance -Force  # Stop Remote Assistance Service
#Set-Service -Name RemoteAssistance -StartupType Disabled  # Disable Remote Assistance on startup

# 5. Enable Windows Update (if not already enabled)
Write-Output "Ensuring Windows Update is enabled..."
Set-Service -Name wuauserv -StartupType Automatic
Start-Service -Name wuauserv

# 6. Disable Guest Account
Write-Output "Disabling Guest account..."
Disable-LocalUser -Name "Guest"

# 7. Ensure strong password policy
#Write-Output "Enforcing strong password policies..."
#secpol.msc /s  # Opens local security policy for manual modification (set minimum password length, complexity, etc.)

# 8. Configure User Account Control (UAC) to always notify
Write-Output "Configuring User Account Control (UAC)..."
$UAC = New-Object -ComObject Shell.Application
$UAC.ShellExecute("cmd.exe", "/c reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 1 /f", "", "runas", 1)

# 9. Disable AutoRun to prevent malware from executing via USB drives
Write-Output "Disabling AutoRun..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 0x000000FF /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d 1 /f

# 10. Enable Account Lockout Policy (after multiple failed login attempts)
Write-Output "Enabling Account Lockout Policy..."
secpol.msc /s  # Opens local security policy for manual modifications (set lockout threshold, duration, etc.)

# 11. Set Windows Defender to block untrusted files
Write-Output "Configuring Windows Defender to block untrusted files..."
Set-MpPreference -PUAProtection Enabled  # Enable protection against potentially unwanted applications

# 12. Enforce Windows Defender Cloud Protection (if applicable)
Write-Output "Enforcing Windows Defender Cloud Protection..."
Set-MpPreference -CloudBlockLevel High   # Set cloud protection level to high

# 13. Disable unnecessary scheduled tasks that could be malicious (example: Office Update)
Write-Output "Disabling unnecessary scheduled tasks..."
Get-ScheduledTask | Where-Object {$_.TaskName -match "Office"} | Disable-ScheduledTask

# 14. Enable Security Auditing
Write-Output "Enabling security auditing..."
auditpol /set /category:"Logon/Logoff" /success:enable /failure:enable
auditpol /set /category:"Account Logon/Logoff" /success:enable /failure:enable
auditpol /set /category:"Logon/Logoff" /success:enable /failure:enable
auditpol /set /category:"Object Access" /success:enable /failure:enable

# 15. Ensure System Restore is enabled (to protect against system corruption)
#Write-Output "Ensuring System Restore is enabled..."
#Enable-ComputerRestore -Drive "C:\"

# 16. Clear event logs (optional, use cautiously)
#Write-Output "Clearing event logs..."
#wevtutil el | ForEach-Object { wevtutil cl "$_" }

# 17. Restart the machine to apply changes (optional)
#Write-Output "Rebooting system to apply changes..."
#Restart-Computer -Force

Write-Output "Basic security procedures applied successfully!"

#------------

# Ensure the Active Directory module is imported
Import-Module ActiveDirectory

# Define the output CSV file path
$outputFile = "C:\path\to\output\OUs_and_Permissions.csv"

# Function to get permissions for each OU
function Get-OUPermissions {
    param (
        [string]$OU
    )
    
    # Get the permissions for the specified OU
    $permissions = Get-Acl "AD:$OU" | Select-Object -ExpandProperty Access
    
    # Prepare the output data
    $permissionsInfo = $permissions | Select-Object @{Name="OU";Expression={$OU}}, 
                                                     @{Name="IdentityReference";Expression={$_.IdentityReference}},
                                                     @{Name="AccessControlType";Expression={$_.AccessControlType}},
                                                     @{Name="ActiveDirectoryRights";Expression={$_.ActiveDirectoryRights}},
                                                     @{Name="IsInherited";Expression={$_.IsInherited}}
    
    return $permissionsInfo
}

# Get all Organizational Units (OUs) in the domain
$OUs = Get-ADOrganizationalUnit -Filter * | Select-Object DistinguishedName

# Create an empty list to store all the data
$allOUData = @()

# Loop through each OU and get its permissions
foreach ($OU in $OUs) {
    Write-Host "Gathering permissions for OU: $($OU.DistinguishedName)"
    $OUPermissions = Get-OUPermissions -OU $OU.DistinguishedName
    
    # Add the permissions info for this OU to the list
    $allOUData += $OUPermissions
}

# Export the gathered information to a CSV file
$allOUData | Export-Csv -Path ".\OU_Permissions.csv" -NoTypeInformation

Start-Process ".\OU_Permissions.csv"

Write-Host "Information has been exported to: .\OU_Permissions.csv"

#--------------------

## Scheduled Tasks: PowerShell Script to Get Details on All Scheduled Tasks on a Local or Remote Machine ##

<#   
.SYNOPSIS   
Script that returns scheduled tasks on a computer (local or remote)
    
.DESCRIPTION 
This script uses the Schedule.Service COM-object to query the local or a remote computer in order to gather	a formatted list including the Author, UserId and description of the task. This information is parsed from the XML attributed to provide a more human readable format
 
.PARAMETER Computername
The computer that will be queried by this script, local administrative permissions are required to query this information

.NOTES   
Name: Get-ScheduledTask.ps1
Author: Jaap Brasser
DateCreated: 2012-05-23
DateUpdated: 2015-08-17
Site: http://www.jaapbrasser.com
Version: 1.3.2

.LINKS
http://www.jaapbrasser.com
https://gallery.technet.microsoft.com/scriptcenter/Get-Scheduled-tasks-from-3a377294

.EXAMPLE
	.\Get-ScheduledTask.ps1 -ComputerName server01

Description
-----------
This command query mycomputer1 and display a formatted list of all scheduled tasks on that computer

.EXAMPLE
	.\GetScheduledTask.ps1

Description
-----------
This command query localhost and display a formatted list of all scheduled tasks on the local computer

.EXAMPLE
	.\GetScheduledTask.ps1 -ComputerName server01 | Select-Object -Property Name,Trigger

Description
-----------
This command query server01 for scheduled tasks and display only the TaskName and the assigned trigger(s)

.EXAMPLE
	.\GetScheduledTask.ps1 | Where-Object {$_.Name -eq 'TaskName') | Select-Object -ExpandProperty Trigger

Description
-----------
This command queries the local system for a scheduled task named 'TaskName' and display the expanded view of the assisgned trigger(s)

.EXAMPLE
	Get-Content C:\Servers.txt | ForEach-Object { .\GetScheduledTask.ps1 -ComputerName $_ }

Description
-----------
Reads the contents of C:\Servers.txt and pipes the output to GetScheduledTask.ps1 and outputs the results to the console


#>
param(
	[string]$ComputerName = $env:COMPUTERNAME,
    [switch]$RootFolder
)

#region Functions
function Get-AllTaskSubFolders {
    [cmdletbinding()]
    param (
        # Set to use $Schedule as default parameter so it automatically list all files
        # For current schedule object if it exists.
        $FolderRef = $Schedule.getfolder("\")
    )
    if ($FolderRef.Path -eq '\') {
        $FolderRef
    }
    if (-not $RootFolder) {
        $ArrFolders = @()
        if(($Folders = $folderRef.getfolders(1))) {
            $Folders | ForEach-Object {
                $ArrFolders += $_
                if($_.getfolders(1)) {
                    Get-AllTaskSubFolders -FolderRef $_
                }
            }
        }
        $ArrFolders
    }
}

function Get-TaskTrigger {
    [cmdletbinding()]
    param (
        $Task
    )
    $Triggers = ([xml]$Task.xml).task.Triggers
    if ($Triggers) {
        $Triggers | Get-Member -MemberType Property | ForEach-Object {
            $Triggers.($_.Name)
        }
    }
}
#endregion Functions


try {
	$Schedule = New-Object -ComObject 'Schedule.Service'
} catch {
	Write-Warning "Schedule.Service COM Object not found, this script requires this object"
	return
}

$Schedule.connect($ComputerName) 
$AllFolders = Get-AllTaskSubFolders

foreach ($Folder in $AllFolders) {
    if (($Tasks = $Folder.GetTasks(1))) {
        $Tasks | Foreach-Object {
	        New-Object -TypeName PSCustomObject -Property @{
	            'Name' = $_.name
                'Path' = $_.path
                'State' = switch ($_.State) {
                    0 {'Unknown'}
                    1 {'Disabled'}
                    2 {'Queued'}
                    3 {'Ready'}
                    4 {'Running'}
                    Default {'Unknown'}
                }
                'Enabled' = $_.enabled
                'LastRunTime' = $_.lastruntime
                'LastTaskResult' = $_.lasttaskresult
                'NumberOfMissedRuns' = $_.numberofmissedruns
                'NextRunTime' = $_.nextruntime
                'Author' =  ([xml]$_.xml).Task.RegistrationInfo.Author
                'UserId' = ([xml]$_.xml).Task.Principals.Principal.UserID
                'Description' = ([xml]$_.xml).Task.RegistrationInfo.Description
                'Trigger' = Get-TaskTrigger -Task $_
                'ComputerName' = $Schedule.TargetServer
            }
        }
    }
}

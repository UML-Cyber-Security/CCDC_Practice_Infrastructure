# Windows 10

## Objective



## Security Analysis

- Malicious software may be able to run under elevated credentials without the user or administrator being aware
  - Ensure 'User Account Control: Admin Approval Mode for the Built-in Administrator account' is set to 'Enabled'
  - Ensure 'User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode' is set to 'Prompt for consent on the secure desktop'
  - Ensure 'User Account Control: Behavior of the elevation prompt for standard users' is set to 'Automatically deny elevation requests'
  - Ensure 'User Account Control: Detect application installations and prompt for elevation' is set to 'Enabled'
  - Ensure 'User Account Control: Only elevate UIAccess applications that are installed in secure locations' is set to 'Enabled'
  - Ensure 'User Account Control: Run all administrators in Admin Approval Mode' is set to 'Enabled'
  - Ensure 'User Account Control: Switch to the secure desktop when prompting for elevation' is set to 'Enabled'
  - Ensure 'User Account Control: Virtualize file and registry write failures to per-user locations' is set to 'Enabled'
- Bootloader attacks can allow attackers to scrape data from memory at boot time
  - Enable Secure Boot (Default)
    - Ensure 'Turn On Virtualization Based Security: Select Platform Security Level' is set to 'Secure Boot and DMA Protection'
    - Ensure 'Allow Secure Boot for integrity validation' is set to 'Enabled'
- Attackers can potentially tamper with the OS drive (or any other fixed or removable data drive) when the user is offline
  - Enable BitLocker on all drives
    - Ensure 'Require additional authentication at startup' is set to 'Enabled'
    - Ensure 'Require additional authentication at startup: Allow BitLocker without a compatible TPM' is set to 'Enabled: False'

### Enabling System Restore

* Allows the user to set their system back to a previous state
* By default: **System Restore** is disabled in Windows 10
  * So if a problem occurs and System Restore is disabled, the user cannot revert back to a previous state

### Antivirus and Windows Firewall

* Windows Defender alone (in most cases) is not sufficient for keeping a computer Secure
* ONLY use **reliable** antivirus programs that is released by **well known** companies
* An Antivirus program should include:
  * Automatic updates
  * Real-time scanning
  * Built-in Firewall
    * If there is no built-in firewall, the user must enable the Windows firewall

### Disable Ad Tracking

* People can track a user's online behavior when browsing the web
* Marketers create user profiles based on a user's online activity in order to provide relevant advertising messages
* People should not be able to observe what a user does online
* Users should disable their advertising ID in the Windows 10 settings

## Testing

Scripted:

-
-
-
-

Active:

-
-
-
-

## Documentation

-
-
-
-

## Script with Comments

```
#configure user account control settings
Set-ItemProperty -Path “HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System” -Name “FilterAdministratorToken” -Value “1”;
Set-ItemProperty -Path “HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System” -Name “ConsentPromptBehaviorAdmin” -Value “2”;
Set-ItemProperty -Path “HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System” -Name “ConsentPromptBehaviorUser” -Value “0”;
Set-ItemProperty -Path “HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System” -Name “EnableInstallerDetection” -Value “1”;
Set-ItemProperty -Path “HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System” -Name “EnableSecureUIAPaths” -Value “1”;
Set-ItemProperty -Path “HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System” -Name “EnableLUA” -Value “1”;
Set-ItemProperty -Path “HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System” -Name “PromptOnSecureDesktop” -Value “1”;
Set-ItemProperty -Path “HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System” -Name “EnableVirtualization” -Value “1”;

```

### Script to easily create and manage Sysinternals Sysmon v2.0 config files

* Microsoft's **Sysmon** is a tool to monitor systems and adds low-level events to be tracked even after a reboot
* Recommended for:
  * edge based systems
  * public-facing web servers
* PowerShell script **POSH-Sysmon** is based on Powershell 3.0 and above and adds the ability to use Powershell to easily create and manage Sysinternals Sysmon v2.0 config files
* Sysmon collects the events it generates using **Windows Event Collection** or **SIEM agents**
* The events can then be analyzed to identify malicious or anomalous activity to understand how intruders and malware are operating on a network
* A sample event can then tracked using the Process Access filter for **Local Security Authority Subsystem Service (LSASS)** to detect if a malicious process is trying to extract credentials from memory

To check what version of PowerShell you have:

1. Open PowerShell
2. Type ``` Get-Host | Select-Object Version ```

On PowerShell v5 and above:

``` POSH-Sysmon install Script

Install-Module -Name Posh-Sysmon

```
## ToDo

- [ ]   
- [ ]   
- [ ]   
- [ ]   

## References

- Center for Internet Security Benchmarks Document for Windows 10: https://www.cisecurity.org/benchmark/microsoft_windows_desktop/
- [System Restore, Antivirus and Firewall, Disable Ad Tracking](https://www.webnots.com/11-ways-to-secure-windows-10/)
- [POSH-Sysmon: Configuring Sysmon](https://www.csoonline.com/article/3148823/10-essential-powershell-security-scripts-for-windows-administrators.html)
- [Full POSH-Sysmon Configuration](https://github.com/darkoperator/Posh-Sysmon)
- []()

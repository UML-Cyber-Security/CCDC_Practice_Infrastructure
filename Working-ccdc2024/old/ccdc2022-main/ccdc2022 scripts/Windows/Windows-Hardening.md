# General

Edit GP registry values: 

```
Set-GPRegistryValue -Name "TestGPO" -Key "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop" -ValueName "ScreenSaveTimeOut" -Type DWORD -Value 900
```

Install the GoupPolicy cmdlet and run the refresh command:

```
Get-Command -Module GroupPolicy
Invoke-GPUpdate
```

# Ensure 'Interactive logon: Do not display last user name' is set to 'Enabled'

# Ensure 'Interactive logon: Smart card removal behavior' is set to 'Lock Workstation' or higher

# Ensure 'Microsoft network client: Digitally sign communications (always)' is set to 'Enabled'

# Ensure 'Network access: Do not allow storage of passwords and credentials for network authentication' is set to 'Enabled'

# Ensure 'Network security: Minimum session security for NTLM SSP based (including secure RPC) clients' is set to 'Require NTLMv2 session security, Require 128-bit encryption'

# Ensure 'Network security: Minimum session security for NTLM SSP based (including secure RPC) servers' is set to 'Require NTLMv2 session security, Require 128-bit encryption'

# Disable Null Sessions in Windows 

Guide to disable null sessions via Group Policy: https://social.technet.microsoft.com/Forums/windowsserver/en-US/e56374b4-6132-4aae-ab6b-349e5d355575/disable-null-sessions-on-domain-controllers-and-member-servers?forum=winserverGP


```Set-GPRegistryValue -Name "TestGPO" -Key "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\LSA" -ValueName "RestrictAnonymous" -Type DWORD -Value 1```



# IMPORTANT
Make sure to force update the group policy or changes WILL NOT take place

# Ensure 'Interactive logon: Do not display last user name' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System" -ValueName "DontDisplayLastUserName" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_server_2012_member_server/2014-01-07/finding/V-11806)
Severity: Low

# Ensure 'Interactive logon: Smart card removal behavior' is set to 'Lock Workstation' or higher
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon" -ValueName "ScRemoveOption" -Type REG_SZ -Value "1"`

(https://www.stigviewer.com/stig/windows_7/2014-04-02/finding/V-1157)
Severity: Medium

# Ensure 'Microsoft network client: Digitally sign communications (always)' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LanmanWorkstation\\Parameters" -ValueName "RequireSecuritySignature" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_server_2012_member_server/2014-01-07/finding/V-6833)
Severity: Medium

# Ensure 'Network access: Do not allow storage of passwords and credentials for network authentication' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa" -ValueName "DisableDomainCreds" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_8/2014-01-07/finding/V-3376)
Severity: Medium

# Ensure 'Network security: Minimum session security for NTLM SSP based (including secure RPC) clients' is set to 'Require NTLMv2 session security, Require 128-bit encryption'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa\\MSV1_0" -ValueName "NTLMMinServerSec" -Type REG_DWORD -Value 537395200`

(https://www.stigviewer.com/stig/windows_server_2008_r2_member_server/2014-04-02/finding/V-3666)
Severity: Medium

# Ensure 'Network security: Minimum session security for NTLM SSP based (including secure RPC) servers' is set to 'Require NTLMv2 session security, Require 128-bit encryption'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa\\MSV1_0" -ValueName "NTLMMinClientSec" -Type REG_DWORD -Value 537395200`

(https://www.stigviewer.com/stig/windows_10/2018-04-06/finding/V-63805)
Severity: Medium

# Ensure Null sessions are not allowed
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKLM\\System\\CurrentControlSet\\Control\\Lsa" -ValueName "RestrictAnonymous" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/microsoft_windows_server_20122012_r2_member_server/2021-03-05/finding/V-225493)
Severity: High

# Ensure 'Accounts: Limit local account use of blank passwords to console logon only' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa" -ValueName "LimitBlankPasswordUse" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_server_2016/2019-01-16/finding/V-73621)
Severity: High

# Ensure 'Audit: Shut down system immediately if unable to log security audits' is set to 'Disabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa" -ValueName "CrashOnAuditFail" -Type REG_DWORD -Value 0`

(https://www.stigviewer.com/stig/windows_server_2012_2012_r2_member_server/2015-06-16/finding/V-57657)
Severity: Medium

# Ensure 'Devices: Prevent users from installing printer drivers' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Print\\Providers\\LanMan Print Services\\Servers" -ValueName "AddPrinterDrivers" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_7/2014-04-02/finding/V-1151)
Severity: Low

# Ensure 'Domain member: Digitally encrypt or sign secure channel data (always)' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\Netlogon\\Parameters" -ValueName "RequireSignOrSeal" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_server_2016/2020-06-16/finding/V-73633)
Severity: Medium

# Ensure 'Domain member: Digitally encrypt secure channel data (when possible)' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\Netlogon\\Parameters" -ValueName "SealSecureChannel" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_server_2008_r2_member_server/2016-06-08/finding/V-1163)
Severity: Medium

# Ensure 'Domain member: Digitally sign secure channel data (when possible)' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\Netlogon\\Parameters" -ValueName "SignSecureChannel" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_server_2016/2019-07-09/finding/V-73637)
Severity: Medium

# Ensure 'Domain member: Disable machine account password changes' is set to 'Disabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\Netlogon\\Parameters" -ValueName "DisablePasswordChange" -Type  -Value 0`

(https://www.stigviewer.com/stig/windows_10/2017-02-21/finding/V-63653)
Severity: Low

# Ensure 'Domain member: Require strong (Windows 2000 or later) session key' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\Netlogon\\Parameters" -ValueName "RequireStrongKey" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_server_2012_member_server/2014-01-07/finding/V-3374)
Severity: Low

# Ensure 'Interactive logon: Do not require CTRL+ALT+DEL' is set to 'Disabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System" -ValueName "DisableCAD" -Type REG_DWORD -Value 0`

(https://www.stigviewer.com/stig/windows_7/2014-04-02/finding/V-1154)
Severity: Medium

# Ensure 'Interactive logon: Prompt user to change password before expiration' is set to 'between 5 and 14 days'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon" -ValueName "PasswordExpiryWarning" -Type REG_DWORD -Value 14`

(https://www.stigviewer.com/stig/windows_server_20122012_r2_member_server/2018-10-30/finding/V-1172)
Severity: Low

# Ensure 'Microsoft network client: Digitally sign communications (if server agrees)' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LanmanWorkstation\\Parameters" -ValueName "EnableSecuritySignature" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_7/2016-06-08/finding/V-1162)
Severity: Medium

# Ensure 'Microsoft network client: Send unencrypted password to third-party SMB servers' is set to 'Disabled' <- LMAO WHY BRO WHY?
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LanmanWorkstation\\Parameters" -ValueName "EnablePlainTextPassword" -Type REG_DWORD -Value 0`

(https://www.stigviewer.com/stig/windows_7/2012-08-22/finding/V-1141)
Severity: Medium

# Ensure 'Microsoft network server: Amount of idle time required before suspending session' is set to '15 or fewer minute(s), but not 0'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LanManServer\\Parameters" -ValueName "AutoDisconnect" -Type REG_DWORD -Value 0`

(https://www.stigviewer.com/stig/windows_server_2012_2012_r2_member_server/2015-06-16/finding/V-1174)
Severity: Low

# Ensure 'Microsoft network server: Digitally sign communications (always)' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LanManServer\\Parameters" -ValueName "RequireSecuritySignature" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_server_2012_member_server/2014-01-07/finding/V-6833)
Severity: Medium

# Ensure 'Microsoft network server: Digitally sign communications (if client agrees)' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LanManServer\\Parameters" -ValueName "EnableSecuritySignature" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_7/2016-06-08/finding/V-1162)
Severity: Medium

# Ensure 'Network access: Do not allow anonymous enumeration of SAM accounts' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Lsa" -ValueName "RestrictAnonymousSAM" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/microsoft_windows_server_2019/2021-03-05/finding/V-205914)
Severity: High

# Ensure 'Network access: Let Everyone permissions apply to anonymous users' is set to 'Disabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa" -ValueName "EveryoneIncludesAnonymous" -Type REG_DWORD -Value 0`

(https://www.stigviewer.com/stig/windows_server_2012_member_server/2014-01-07/finding/V-3377)
Severity: Medium

# Ensure 'Network access: Restrict anonymous access to Named Pipes and Shares' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LanManServer\\Parameters" -ValueName "RestrictNullSessAccess" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_server_2016/2020-06-16/finding/V-73675)
Severity: High

# Ensure 'Network access: Sharing and security model for local accounts' is set to 'Classic - local users authenticate as themselves'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa" -ValueName "ForceGuest" -Type REG_DWORD -Value 0`

(https://www.stigviewer.com/stig/windows_server_20122012_r2_domain_controller/2019-01-16/finding/V-3378)
Severity: Medium

# Ensure 'Network security: Do not store LAN Manager hash value on next password change' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa" -ValueName "NoLMHash" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_server_2016/2019-01-16/finding/V-73687)
Severity: High

# Ensure 'Network security: LDAP client signing requirements' is set to 'Negotiate signing' or higher
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LDAP" -ValueName "LDAPClientIntegrity" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_server_2012_member_server/2014-01-07/finding/V-3381)
Severity: Medium

# Ensure 'System objects: Require case insensitivity for non-Windows subsystems' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager\\Kernel" -ValueName "ObCaseInsensitive" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_10/2017-02-21/finding/V-63813)
Severity: Medium

# Ensure 'System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager" -ValueName "ProtectionMode" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_7/2014-04-02/finding/V-1173)
Severity: Low

# Ensure DCOM is enabled
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\OLE" -ValueName "EnableDCOM" -Type REG_SZ -Value "Y"`

(https://docs.microsoft.com/en-us/windows/win32/com/enabledcom)
Severity: Unknown

# Ensure Automatic Logon is disabled
First line removes default user password if any was set
`Remove-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon" -ValueName "DefaultPassword"
Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon" -ValueName "AutoAdminLogon" -Type REG_SZ -Value 0`

(https://www.stigviewer.com/stig/windows_8/2013-07-03/finding/V-1145)
Severity: Medium

# Ensure Winpcap packet filter driver is not present
If this returns true then Winpcap is present. This could be a sign of wireshark or other network sniffing tools.
`Test-Path -Path "%WINDIR%\\Sysnative\\drivers\\npf.sys" -PathType Leaf
Test-Path -Path "%WINDIR%\\System32\\drivers\\npf.sys"  -PathType Leaf`

Script form below

`if( Test-Path -Path "%WINDIR%\\Sysnative\\drivers\\npf.sys"  -PathType Leaf ){Write-Output "WARNING, WINPCAP IS INSTALLED"}
if( Test-Path -Path "%WINDIR%\\System32\\drivers\\npf.sys"  -PathType Leaf ){Write-Output "WARNING, WINPCAP IS INSTALLED"}`

# Ensure 'Devices: Allowed to format and eject removable media' is set to 'Administrators'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon" -ValueName "AllocateDASD" -Type REG_SZ -Value 0`

(https://www.stigviewer.com/stig/windows_7/2012-07-02/finding/V-1171)
Severity: Medium

# Ensure 'Network access: Shares that can be accessed anonymously' is set to 'None'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LanManServer\\Parameters" -ValueName "NullSessionShares" -Type REG_MULTI_SZ -Value ""`

(https://www.stigviewer.com/stig/windows_7/2014-04-02/finding/V-3340)
Severity: High

# Ensure 'Network security: LAN Manager authentication level' is set to 'Send NTLMv2 response only. Refuse LM & NTLM'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa" -ValueName "LmCompatibilityLevel" -Type REG_DWORD -Value 5`

(https://www.stigviewer.com/stig/windows_10/2020-06-15/finding/V-63801)
Severity: High

# Ensure 'Windows Firewall: Private: Firewall state' is set to 'On'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\WindowsFirewall\\PrivateProfile" -ValueName "EnableFirewall" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_firewall_with_advanced_security/2016-05-12/finding/V-17416)
Severity: Medium

# Ensure 'Windows Firewall: Public: Firewall state' is set to 'On'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\WindowsFirewall\\PublicProfile" -ValueName "EnableFirewall" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_firewall_with_advanced_security/2016-05-12/finding/V-17416)
Severity: Medium

# Ensure Registry tools set is enabled
might be a good idea to disable registry, may be used for pivoting.... maybe not
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System" -ValueName "DisableRegistryTools" -Type REG_DWORD -Value 0`

(https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.WindowsTools::DisableRegedit)
Severity: Unknown

# Ensure LM authentication is not allowed (disable weak passwords)
This was already done in a previous one....

# Ensure Firewall/Anti Virus notifications are enabled
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Security Center" -ValueName "FirewallDisableNotify" -Type REG_DWORD -Value 0
Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Security Center" -ValueName "antivirusoverride" -Type REG_DWORD -Value 0
Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Security Center" -ValueName "firewalldisablenotify" -Type REG_DWORD -Value 0
Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Security Center" -ValueName "firewalldisableoverride" -Type REG_DWORD -Value 0`

Severity: Unknown

# Ensure Microsoft Firewall is enabled
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\software\\policies\\microsoft\\windowsfirewall\\domainprofile" -ValueName "enablefirewall" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_firewall_with_advanced_security/2016-05-12/finding/V-17416)
Severity: Medium

# Ensure Turn off Windows Error reporting is enabled
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\PCHealth\\ErrorReporting" -ValueName "DoReport" -Type REG_DWORD -Value 0
Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\Windows Error Reporting" -ValueName "Disabled" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_server_2012_member_server/2014-01-07/finding/V-3471)
Severity: Medium

(https://www.stigviewer.com/stig/windows_7/2014-04-02/finding/V-15715)
Severity: Medium

# Ensure 'MSS: (AutoAdminLogon) Enable Automatic Logon (not recommended)' is set to 'Disabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon" -ValueName "AutoAdminLogon" -Type REG_SZ -Value "0"`

(https://www.stigviewer.com/stig/windows_8/2013-07-03/finding/V-1145)
Severity: Medium

# Ensure 'MSS: (DisableIPSourceRouting IPv6) IP source routing protection level (protects against packet spoofing)' is set to 'Enabled: Highest protection, source routing is completely disabled'
Might be needed by SOC team for monitoring? Gonna keep it off but if worse comes to worse this can be enabled.

IMPORTANT:
This policy setting requires the installation of the MSS-Legacy custom templates included with the STIG package. 
"MSS-Legacy.admx" and "MSS-Legacy.adml" must be copied to the \Windows\PolicyDefinitions and \Windows\PolicyDefinitions\en-US
 directories respectively. 

`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\Tcpip6\\Parameters" -ValueName "DisableIPSourceRouting" -Type REG_DWORD -Value 2`

(https://www.stigviewer.com/stig/windows_server_2016/2019-07-09/finding/V-73501)
Severity: Low

# Ensure 'MSS: (DisableIPSourceRouting) IP source routing protection level (protects against packet spoofing)' is set to 'Enabled: Highest protection, source routing is completely disabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\Tcpip\\Parameters" -ValueName "DisableIPSourceRouting" -Type REG_DWORD -Value 2`

IMPORTANT:
This policy setting requires the installation of the MSS-Legacy custom templates included with the STIG package. 
"MSS-Legacy.admx" and "MSS-Legacy.adml" must be copied to the \Windows\PolicyDefinitions and \Windows\PolicyDefinitions\en-US
 directories respectively. 

# Ensure 'MSS: (SafeDllSearchMode) Enable Safe DLL search mode (recommended)' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session Manager" -ValueName "SafeDllSearchMode" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_server_2008_r2_member_server/2014-04-02/finding/V-3479)
Severity: Medium

# Ensure 'MSS: (ScreenSaverGracePeriod) The time in seconds before the screen saver grace period expires (0 recommended)' is set to 'Enabled: 5 or fewer seconds'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon" -ValueName "ScreenSaverGracePeriod" -Type REG_SZ -Value "0"`

(https://www.stigviewer.com/stig/windows_7/2012-07-02/finding/V-4442)
Severity: Low

4th wall break, hi person reading.

# Ensure 'MSS: (WarningLevel) Percentage threshold for the security event log at which the system will generate a warning' is set to 'Enabled: 90% or less'
SOC Team can change this if they dont wanna look through too many logs. 
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\Eventlog\\Security" -ValueName "WarningLevel" -Type REG_DWORD -Value 90`

(https://www.stigviewer.com/stig/windows_server_2008_r2_member_server/2014-01-07/finding/V-4108)
Severity: Low

# Ensure 'Configure registry policy processing: Do not apply during periodic background processing' is set to 'Enabled: FALSE'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\Group Policy\\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}" -ValueName "NoBackgroundPolicy" -Type REG_DWORD -Value 0`

(https://www.stigviewer.com/stig/windows_7/2014-04-02/finding/V-4448)
Severity: Medium

# Ensure 'Turn off downloading of print drivers over HTTP' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Printers" -ValueName "DisableWebPnPDownload" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/microsoft_windows_server_2012_member_server/2013-07-25/finding/WN12-CC-000032)
Severity: Medium

# Ensure 'Turn off Internet download for Web publishing and online ordering wizards' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer" -ValueName "NoWebServices" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_10/2017-12-01/finding/V-63621)
Severity: Medium

# Ensure 'Turn off printing over HTTP' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Printers" -ValueName "DisableHTTPPrinting" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_10/2018-04-06/finding/V-63623)
Severity: Medium

# Ensure 'Configure Offer Remote Assistance' is set to 'Disabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Terminal Services" -ValueName "fAllowUnsolicited" -Type REG_DWORD -Value 0`

(https://www.stigviewer.com/stig/windows_7/2013-03-14/finding/V-3470)
Severity: Medium

# Ensure 'Configure Solicited Remote Assistance' is set to 'Disabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Terminal Services" -ValueName "fAllowToGetHelp" -Type REG_DWORD -Value 0`

(https://www.stigviewer.com/stig/windows_server_2012_member_server/2014-01-07/finding/V-3343)
Severity: High

# Ensure 'Turn off Autoplay' is set to 'Enabled: All drives'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer" -ValueName "NoDriveTypeAutoRun" -Type REG_DWORD -Value 255`

(https://www.stigviewer.com/stig/windows_10/2017-12-01/finding/V-63673)
Severity: High

# Ensure 'Do not allow passwords to be saved' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Terminal Services" -ValueName "DisablePasswordSaving" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_server_2012_member_server/2014-01-07/finding/V-14247)
Severity: Medium

# Ensure 'Do not allow drive redirection' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Terminal Services" -ValueName "fDisableCdm" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/microsoft_windows_server_2019/2021-03-05/finding/V-205722)
Severity: Medium

# Ensure 'Always prompt for password upon connection' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Terminal Services" -ValueName "fPromptForPassword" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_server_2012_member_server/2014-01-07/finding/V-3453)
Severity: Medium

# Ensure 'Set client connection encryption level' is set to 'Enabled: High Level'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Terminal Services" -ValueName "MinEncryptionLevel" -Type REG_DWORD -Value 3`

(https://www.stigviewer.com/stig/windows_server_2012_member_server/2014-01-07/finding/V-3454)
Severity: Medium

# Ensure 'Always install with elevated privileges' is set to 'Disabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\Installer" -ValueName "AlwaysInstallElevated" -Type REG_DWORD -Value 0`

(https://www.stigviewer.com/stig/microsoft_windows_server_2012_member_server/2013-07-25/finding/WN12-CC-000116)
Severity: High

# Ensure 'Configure Automatic Updates' is set to 'Enabled'
Website says that this should have a value of 1 but wazuh believes it should be 0.
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsUpdate\\AU" -ValueName "NoAutoUpdate" -Type REG_DWORD -Value 0`

(https://www.stigviewer.com/stig/windows_7/2012-07-02/finding/V-14250)
Severity: Unknown

# Ensure 'No auto-restart with logged on users for scheduled automatic updates installations' is set to 'Disabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsUpdate\\AU" -ValueName "NoAutoRebootWithLoggedOnUsers" -Type REG_DWORD -Value 0`

(https://docs.microsoft.com/en-us/windows/deployment/update/waas-restart)

    0: disable do not reboot if users are logged on
    1: do not reboot after an update installation if a user is logged on
    Note: If disabled: Automatic Updates will notify the user that the computer will automatically restart in 5 minutes to complete the installation

# Ensure 'MSS: (TcpMaxDataRetransmissions IPv6) How many times unacknowledged data is retransmitted' is set to 'Enabled: 3'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\TCPIP6\\Parameters" -ValueName "TcpMaxDataRetransmissions" -Type REG_DWORD -Value 3`

(https://www.stigviewer.com/stig/windows_server_2008_r2_domain_controller/2019-01-16/finding/V-4438)
Severity: Low

# Ensure 'MSS: (TcpMaxDataRetransmissions) How many times unacknowledged data is retransmitted' is set to 'Enabled: 3'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\Tcpip\\Parameters" -ValueName "TcpMaxDataRetransmissions" -Type  -Value 3`

(https://www.stigviewer.com/stig/windows_server_2008_r2_domain_controller/2019-01-16/finding/V-4438)
Severity: Low

# Ensure 'Turn off Search Companion content file updates' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\SearchCompanion" -ValueName "DisableContentFileUpdates" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_7/2014-04-02/finding/V-14258)
Severity: Medium

# Ensure 'Turn off the "Publish to Web" task for files and folders' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer" -ValueName "NoPublishingWizard" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_server_2012_member_server/2014-01-07/finding/V-14255)
Severity: Medium

# Ensure 'Turn off the Windows Messenger Customer Experience Improvement Program' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Messenger\\Client" -ValueName "CEIP" -Type REG_DWORD -Value 2`

(https://www.stigviewer.com/stig/windows_7/2012-07-02/finding/V-14257)
Severity: Medium

# Ensure 'Turn off Windows Error Reporting' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\Windows Error Reporting" -ValueName "Disabled" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_7/2014-04-02/finding/V-15715)
Severity: Medium

# Ensure 'Enable RPC Endpoint Mapper Client Authentication' is set to 'Enabled'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Rpc" -ValueName "EnableAuthEpResolution" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_server_2012_member_server/2014-01-07/finding/V-14254)
Severity: Medium

# Ensure 'Restrict Unauthenticated RPC clients' is set to 'Enabled: Authenticated'
`Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Rpc" -ValueName "RestrictRemoteClients" -Type REG_DWORD -Value 1`

(https://www.stigviewer.com/stig/windows_server_2012_member_server/2014-01-07/finding/V-14253)
Severity: Medium

# Links
https://4sysops.com/archives/administering-group-policy-with-powershell/

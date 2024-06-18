Write-Output " ______           __      _______                __               __              
|   __ \.---.-.--|  |    |   |   |.---.-.----.--|  |.-----.-----.|__|.-----.-----.
|   __ <|  _  |  _  |    |       ||  _  |   _|  _  ||  -__|     ||  ||     |  _  |
|______/|___._|_____|    |___|___||___._|__| |_____||_____|__|__||__||__|__|___  |
                                                                           |_____|
                     _______             __         __                            
                    |     __|.----.----.|__|.-----.|  |_                          
                    |__     ||  __|   _||  ||  _  ||   _|                         
                    |_______||____|__|  |__||   __||____|                         
                                            |__|     for use in servers           "

$GroupPolicy = Read-Host "Please enter the name of the group policy"

Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System" -ValueName "DontDisplayLastUserName" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon" -ValueName "ScRemoveOption" -Type REG_SZ -Value "1"


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LanmanWorkstation\\Parameters" -ValueName "RequireSecuritySignature" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa" -ValueName "DisableDomainCreds" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa\\MSV1_0" -ValueName "NTLMMinServerSec" -Type REG_DWORD -Value 537395200


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa\\MSV1_0" -ValueName "NTLMMinClientSec" -Type REG_DWORD -Value 537395200


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKLM\\System\\CurrentControlSet\\Control\\Lsa" -ValueName "RestrictAnonymous" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa" -ValueName "LimitBlankPasswordUse" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa" -ValueName "CrashOnAuditFail" -Type REG_DWORD -Value 0


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Print\\Providers\\LanMan Print Services\\Servers" -ValueName "AddPrinterDrivers" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\Netlogon\\Parameters" -ValueName "RequireSignOrSeal" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\Netlogon\\Parameters" -ValueName "SealSecureChannel" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\Netlogon\\Parameters" -ValueName "SignSecureChannel" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\Netlogon\\Parameters" -ValueName "DisablePasswordChange" -Type  -Value 0


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\Netlogon\\Parameters" -ValueName "RequireStrongKey" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System" -ValueName "DisableCAD" -Type REG_DWORD -Value 0


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon" -ValueName "PasswordExpiryWarning" -Type REG_DWORD -Value 14


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LanmanWorkstation\\Parameters" -ValueName "EnableSecuritySignature" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LanmanWorkstation\\Parameters" -ValueName "EnablePlainTextPassword" -Type REG_DWORD -Value 0


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LanManServer\\Parameters" -ValueName "AutoDisconnect" -Type REG_DWORD -Value 0


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LanManServer\\Parameters" -ValueName "RequireSecuritySignature" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LanManServer\\Parameters" -ValueName "EnableSecuritySignature" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Lsa" -ValueName "RestrictAnonymousSAM" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa" -ValueName "EveryoneIncludesAnonymous" -Type REG_DWORD -Value 0


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LanManServer\\Parameters" -ValueName "RestrictNullSessAccess" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa" -ValueName "ForceGuest" -Type REG_DWORD -Value 0


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa" -ValueName "NoLMHash" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LDAP" -ValueName "LDAPClientIntegrity" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager\\Kernel" -ValueName "ObCaseInsensitive" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager" -ValueName "ProtectionMode" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\OLE" -ValueName "EnableDCOM" -Type REG_SZ -Value "Y"


Remove-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon" -ValueName "DefaultPassword"
Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon" -ValueName "AutoAdminLogon" -Type REG_SZ -Value 0


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon" -ValueName "AllocateDASD" -Type REG_SZ -Value 0


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\LanManServer\\Parameters" -ValueName "NullSessionShares" -Type REG_MULTI_SZ -Value ""


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa" -ValueName "LmCompatibilityLevel" -Type REG_DWORD -Value 5


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\WindowsFirewall\\PrivateProfile" -ValueName "EnableFirewall" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\WindowsFirewall\\PublicProfile" -ValueName "EnableFirewall" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System" -ValueName "DisableRegistryTools" -Type REG_DWORD -Value 0


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Security Center" -ValueName "FirewallDisableNotify" -Type REG_DWORD -Value 0
Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Security Center" -ValueName "antivirusoverride" -Type REG_DWORD -Value 0
Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Security Center" -ValueName "firewalldisablenotify" -Type REG_DWORD -Value 0
Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Security Center" -ValueName "firewalldisableoverride" -Type REG_DWORD -Value 0


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\software\\policies\\microsoft\\windowsfirewall\\domainprofile" -ValueName "enablefirewall" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\PCHealth\\ErrorReporting" -ValueName "DoReport" -Type REG_DWORD -Value 0
Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\Windows Error Reporting" -ValueName "Disabled" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon" -ValueName "AutoAdminLogon" -Type REG_SZ -Value "0"


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\Tcpip6\\Parameters" -ValueName "DisableIPSourceRouting" -Type REG_DWORD -Value 2


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\Tcpip\\Parameters" -ValueName "DisableIPSourceRouting" -Type REG_DWORD -Value 2


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session Manager" -ValueName "SafeDllSearchMode" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon" -ValueName "ScreenSaverGracePeriod" -Type REG_SZ -Value "0"


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\Eventlog\\Security" -ValueName "WarningLevel" -Type REG_DWORD -Value 90


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\Group Policy\\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}" -ValueName "NoBackgroundPolicy" -Type REG_DWORD -Value 0


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Printers" -ValueName "DisableWebPnPDownload" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer" -ValueName "NoWebServices" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Printers" -ValueName "DisableHTTPPrinting" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Terminal Services" -ValueName "fAllowUnsolicited" -Type REG_DWORD -Value 0


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Terminal Services" -ValueName "fAllowToGetHelp" -Type REG_DWORD -Value 0


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer" -ValueName "NoDriveTypeAutoRun" -Type REG_DWORD -Value 255


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Terminal Services" -ValueName "DisablePasswordSaving" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Terminal Services" -ValueName "fDisableCdm" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Terminal Services" -ValueName "fPromptForPassword" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Terminal Services" -ValueName "MinEncryptionLevel" -Type REG_DWORD -Value 3


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\Installer" -ValueName "AlwaysInstallElevated" -Type REG_DWORD -Value 0


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsUpdate\\AU" -ValueName "NoAutoUpdate" -Type REG_DWORD -Value 0


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsUpdate\\AU" -ValueName "NoAutoRebootWithLoggedOnUsers" -Type REG_DWORD -Value 0


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\TCPIP6\\Parameters" -ValueName "TcpMaxDataRetransmissions" -Type REG_DWORD -Value 3


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\Tcpip\\Parameters" -ValueName "TcpMaxDataRetransmissions" -Type  -Value 3


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\SearchCompanion" -ValueName "DisableContentFileUpdates" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer" -ValueName "NoPublishingWizard" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Messenger\\Client" -ValueName "CEIP" -Type REG_DWORD -Value 2


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\Windows Error Reporting" -ValueName "Disabled" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Rpc" -ValueName "EnableAuthEpResolution" -Type REG_DWORD -Value 1


Set-GPRegistryValue -Name "$GroupPolicy" -Key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Rpc" -ValueName "RestrictRemoteClients" -Type REG_DWORD -Value 1

Write-Output "IMPORTANT: update group policy by running gpupdate /force"


Write-Output "Additional information if applicable: "


if( Test-Path -Path "%WINDIR%\\Sysnative\\drivers\\npf.sys"  -PathType Leaf ){Write-Output "WINPCAP IS INSTALLED"}
if( Test-Path -Path "%WINDIR%\\System32\\drivers\\npf.sys"  -PathType Leaf ){Write-Output "WINPCAP IS INSTALLED"}

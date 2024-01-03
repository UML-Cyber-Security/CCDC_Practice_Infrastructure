# Based on: https://security.uconn.edu/server-hardening-standard-windows/#

# Note: Took ~35 minutes to implement up to "Additional Security Settings" but could easily get that down (I was copying off phone) and will reorganize them to flow a little better

## Terms:

Specialized Security Limited Functionality (SSLF) Client computers in this type of environment are members of an AD DS domain and must be running Windows Vista or later. Concern for security in this environment is a higher priority than functionality and manageability, which means that the majority of enterprise organizations do not use this environment. The types of environments that might use SSLF are military and intelligence agency computers.

# Baseline Security Settings
## Basic Commands
In powershell run:
`gpmc.msc`
Navigate down: 
`Group Policy Management\Forst: *\ Domains\*\Group Policy Objects\Default Domain Policy\`

Click edit.
Should also do same for 
`Group Policy Management\Forst: *\ Domains\*\Group Policy Objects\Default Domain Controllers Policy\`

## Working under: `Computer Configuration\Policies\Windows Settings\Security Settings\'
Each subheading is a subfolder
i.e. with heading below we are in `Computer Configuration\Policies\Windows Settings\Security Settings\Account Policies\'
## Account Policies
### Password Policy
| Field | Value |
| --- | --- |
| Enforce password | 24 remembered |
| Maximum password age | 90 days (maximum) |
| Minimum password age | 1 day or more |
| Minimum password length | 8 characters |
| Password must meet complexity requirements	| Enabled |
| Store passwords using reversible encryption | Disabled |

### ..\Account Lockout Policy
| Field | Value |
| --- | --- |
| Account lockout duration	| 15 minutes (minimum)| 
| Account lockout threshold	| 10 attempts| 
| Reset account lockout counter after	| 15 minutes (minimum)| 


### ..\Kerberos Policy
| Field | Value |
| --- | --- |
|	Enforce user logon restrictions	| Enabled|
|	Maximum lifetime for service ticket	| 600|
|	Maximum lifetime for user ticket renewal	| 7 days|
|	Maximum lifetime for user ticket	| 10|
|	Maximum tolerance for computer clock synchronization	| 5|


## ..\..\Local Policies/Audit Policies
#### Windows Server 2008 has detailed audit facilities that allow administrators to tune their audit policy with greater specificity. By enabling the legacy audit facilities outlined in this section, it is probable that the performance of the system may be reduced and that the security event log will realize high event volumes. Given this, it is recommended that Detailed Audit Policies in the subsequent section be leveraged in favor over the policies represented below. Additionally, the "Force audit policy subcategory settings", which is recommended to be enabled, causes Windows to favor the audit subcategories over the legacy audit policies. For the above reasons, this Benchmark does not prescribe specific values for legacy audit policies.

| Field | Value |
| --- | --- |
|	Audit Account Logon Events	| Success and Failure|
|	Audit Account Management	  | Success and Failure|
|	Audit Directory Service Access	| No Auditing|
|	Audit Logon Events	| Success and Failure|
|	Audit Object Access	| Failure (minimum)|
|	Audit Policy Change	| Success (minimum)|
|	Audit Privilege Use	| Failure (minimum)|
|	Audit Process Tracking	| No Audit|
|	Audit System Events	| Success (minimum)|

## ..\User Rights
| Field | Value |
| --- | --- |
|    Access credential Manager as a trusted caller	|No One|
|	Access this computer from the network	|Member: Authenticated Users, Domain: Administrators, Authenticated Users, ENTERPRISE DOMAIN CONTROLLERS|
|	Act as part of the operating system	|No one|
|	Add workstations to domain	|Domain: Administrators, Member: Not Defined|
|	Adjust memory quotas for a process	|Administrators, LOCAL SERVICE, NETWORK SERVICE|
|	Allow log on locally	|Administrators|
|	Allow log on through Terminal Services	|Do not disable|
|	Back up files and directories|Administrators|
|	Bypass traverse checking	|Domain: Authenticated Users, Local Service, Network Service, Member: Administrators, Authenticated Users, Local Service, Network Service|
|	Change the system time	|LOCAL SERVICE, Administrators|
|	Change the time zone	|LOCAL SERVICE, Administrators|
|	Create a pagefile	|Administrators|
|	Create a token object	|No One|
|	Create global objects	|Administrators, SERVICE, Local Service, Network Service|
|	Create permanent shared objects	|No One|
|	Create symbolic links	|Administrators|
|	Debug programs	|No one|
|	Deny access to this computer from the network	|Guests|
|	Deny log on locally	|Guests|
|	Deny log on through Terminal Services	|Guests|
|	Enable computer and user accounts to be trusted for delegation	|No One|
|	Force shutdown from a remote system	|Administrators|
|	Generate security audits	|LOCAL SERVICE, NETWORK SERVICE|
|	Impersonate a client after	|Administrators, SERVICE, Local Service, Network Service|
|	Increase a process working set	|Administrators, Local Service|
|	Increase scheduling priority	|Administrators|
|	Load and unload device drivers	|Administrators|
|	Lock pages in memory	|No one|
|	Log on as a batch job	|No one|
|	Manage auditing and security log	|Administrators|
|	Modify firmware environment values	|Member: Administrators, Domain: Not Defined|
|	Perform volume maintenance tasks	|Administrators
|	Profile single process	|Administrators|
|	Profile system performance	|Administrators|
|	Remove computer from docking station	|Administrators|
|	Replace a process level token	|LOCAL SERVICE, NETWORK SERVICE|
|	Restore files and directories	|Administrators|
|	Synchronize directory service data	|No One|
|	Shut down the system	|Administrators|
|	Take ownership of files or other objects	|Administrator|


## ..\Secuirty Options
| Field | Value |
| --- | --- |
|	Audit: Shut down system immediately if unable to log security audits	| Disabled|
|	Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings	| Enabled|
|	Accounts: Guest account status	|Disabled|
|	Accounts: Limit local account use of blank passwords to console logon only|	Enabled|
|	Accounts: Rename administrator account	|does not contain the term "admin".|
|	Accounts: Rename guest account	|does not contain the term "guest".|
|	Devices: Allowed to format and eject removable media	|Administrators|
|	Devices: Prevent users from installing printer drivers	|Enabled|
|	Devices: Restrict CD-ROM access to locally logged-on user only	|Enabled|
|	Devices: Restrict floppy access to locally logged-on user only	|Enabled|
|	Domain controller: Allow server operators to schedule tasks	|Domain: Disabled, Member: Not Defined|
|	Domain controller: LDAP server signing requirements	|Domain: Require signing, Member: Not Defined|
|	Domain controller: Refuse machine account password changes	|Domain: Disabled, Member: Not Defined|
|	Domain member: Digitally encrypt or sign secure channel data (always)	|Enabled|
|	Domain member: Digitally encrypt secure channel data (when possible)	|Enabled|
|	Domain member: Digitally sign secure channel data (when possible)	|Enabled|
|	Domain member: Disable machine account password changes	|Disabled|
|	Domain member: Maximum machine account password age	|30 day(s).|
|	Domain member: Require strong (Windows 2000 or later) session key	|Enabled|
|	Interactive logon: Do not display last user name	|Enabled|
|	Interactive logon: Do not require CTRL+ALT+DEL	|Disabled|
|	Interactive logon: Number of previous logons to cache (in case domain controller is not available)	|1 logon|
|	Interactive logon: Prompt user to change password before expiration	|14 days|
|	Interactive logon: Require Domain Controller authentication to unlock workstation	|Enabled|
|	Microsoft network client: Digitally sign communications (always)	|Enabled|
|	Microsoft network client: Digitally sign communications (if server agrees)	|Enabled|
|	Microsoft network client: Send unencrypted password to third-party SMB servers	|Disabled|
|	Microsoft network server: Amount of idle time required before suspending session	|15 minutes|
|	Microsoft network server: Digitally sign communications (always)	|Enabled|
|	Microsoft network server: Digitally sign communications (if client agrees)	|Enabled|
|	Microsoft network server: Disconnect clients when logon hours expire	|Disabled|
|	Network access: Allow anonymous SID/Name translation	|Disabled|
|	Network access: Do not allow anonymous enumeration of SAM accounts	|Enabled|
|	Network access: Do not allow anonymous enumeration of SAM accounts and shares	|Enabled|
|	Network access: Do not allow storage of credentials or .NET Passports for network authentication	|Enabled|
|	Network access: Let Everyone permissions apply to anonymous users	|Disabled|
|	Network access: Named Pipes that can be accessed anonymously	|Member: browser, Domain: netlogon, lsarpc, samr, browser|
|	Network access: Remotely accessible registry paths|System\CurrentControlSet\Control\ProductOptions, System\CurrentControlSet\Control\Server Applications, Software\Microsoft\Windows NT\CurrentVersion|
|	Network access: Remotely accessible registry paths and sub-paths	|System\CurrentControlSet\Control\Print\Printers System\CurrentControlSet\Services\Eventlog,  Software\Microsoft\OLAP Server, Software\Microsoft\Windows NT\CurrentVersion\Print, Software\Microsoft\Windows NT\CurrentVersion\Windows,  System\CurrentControlSet\Control\ContentIndex System\CurrentControlSet\Control\Terminal Server System\CurrentControlSet\Control\Terminal Server\UserConfig System\CurrentControlSet\Control\Terminal Server\DefaultUserConfiguration Software\Microsoft\Windows NT\CurrentVersion\Perflib System\CurrentControlSet\Services\SysmonLog|
|	Network access: Restrict anonymous access to Named Pipes and Shares	|Enabled|
|	Network access: Shares that can be accessed anonymously	|None|
|	Network access: Sharing and security model for local accounts	|Classic - local users authenticate as themselves.|
|	Network security: Do not store LAN Manager hash value on next password change	|Enabled|
|	Network security: LAN Manager authentication level	|Send NTLMv2 response only. Refuse LM & NTLM.|
|	Network security: LDAP client signing requirements	|Negotiate signing|
|	Network security: Minimum session security for NTLM SSP based (including secure RPC) clients	|Require NTLMv2 session security, Require 128-bit encryption|
|	Network security: Minimum session security for NTLM SSP based (including secure RPC) servers	|Require NTLMv2 session security, Require 128-bit encryption.|
|  Recovery console: Allow automatic administrative logon	|Disabled|
| 	Recovery console: Allow floppy copy and access to all drives and all folders|Disabled|
|	Shutdown: Clear virtual memory pagefile	|Disabled|
|	Shutdown: Allow system to be shut down without having to log on	|Disabled|
|	System objects: Require case insensitivity for non-Windows subsystems	|Enabled|
|	System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)	|Enabled|
|	System cryptography: Force strong key protection for user keys stored on the computer	|User must enter a password each time they use a key|
|	System settings: Optional subsystems|None|
|	System settings: Use Certificate Rules on Windows Executables for Software Restriction Policies	|Enabled|

If exists, also apply.

| Field | Value |
| --- | --- |
|	MSS: (AutoAdminLogon) Enable Automatic Logon (not recommended)	|Disabled|
|	MSS: (DisableIPSourceRouting) IP source routing protection level (protects against packet spoofing)	|Highest protection, source routing is completely disabled.|
|	MSS: (EnableICMPRedirect) Allow ICMP redirects to override OSPF generated routes	|Disabled|
|	MSS: (KeepAliveTime) How often keep-alive packets are sent in milliseconds	|5 minutes|
|	MSS: (KeepAliveTime) How often keep-alive packets are sent in milliseconds	|5 minutes|
|	MSS: (NoDefaultExempt) Configure IPSec exemptions for various types of network traffic|Only ISAKMP is exempt (recommended for Windows Server 2003).|
|	MSS: (NoNameReleaseOnDemand) Allow the computer to ignore NetBIOS name release requests except from WINS servers	|Enabled|
|	MSS: (NtfsDisable8dot3NameCreation) Enable the computer to stop generating 8.3 style filenames (recommended)	|Enabled|
|	MSS: (PerformRouterDiscovery) Allow IRDP to detect and configure Default Gateway addresses (could lead to DoS)	|Disabled|
|	MSS: (SafeDllSearchMode) Enable Safe DLL search mode (recommended)	|Enabled|
|	MSS: (ScreenSaverGracePeriod) The time in seconds before the screen saver grace period expires (0 recommended)	|0|
|	MSS: (TCPMaxDataRetransmissions) How many times unacknowledged data is retransmitted (3 recommended, 5 is default)	|3|
|	MSS: (WarningLevel) Percentage threshold for the security event log at which the system will generate a warning	|90% or less|
|	MSS: (DisableIPSourceRouting IPv6) IP source routing protection level (protects against packet spoofing)	|Highest protection, source routing is completely disabled.|
|	MSS: (TCPMaxDataRetransmissions) IPv6 How many times unacknowledged data is retransmitted (3 recommended, 5 is default)	|3|

     
## ..\..\Advanced Audit Policy Config/Audit Policies
#### This section articulates the detailed audit policies introduced in Windows Vista and later. Prior to Windows Server 2008 R2, these settings could only be established via the auditpol.exe utility. However, in Server 2008 R2, GPOs exist for managing these items. Guidance is provided for establishing the recommended state using via GPO and auditpol.exe. The values prescribed in this section represent the minimum recommended level of auditing.

## \System
| Field | Value |
| --- | --- |
|	Audit IPsec Driver |	Success and Failure|
|    Audit Security State Change	| Success and Failure|
|	Audit Security System Extension	| Success and Failure|
|	Audit System Integrity	| Success and Failure|

## ..\Logon/Logoff
| Field | Value |
| --- | --- |
|	Audit Logoff	|Success|
|	Audit Logon	|Success and Failure|
|	Audit Special Logon|	Success|

## ..\Object Access
| Field | Value |
| --- | --- |
|	Audit Policy File System	| Failure|
|	Audit Policy Registry	| Failure|

## ..\Privilege Use
| Field | Value |
| --- | --- |
|	Audit Policy:  Sensitive Privilege Use	| No auditing|

## ..\Detailed Tracking
| Field | Value |
| --- | --- |
|	Audit Policy Process Creation	|Success|

## ..\Policy Change
| Field | Value |
| --- | --- |
| Audit Audit Policy Change	|Success and Failure|
| Audit Authentication Policy Change	|Success|

## ..\Account Management
| Field | Value |
| --- | --- |
|	Audit Computer Account Management	|Success and Failure|
|	Audit Other Account Management Events	|Success and Failure|
|	Audit Security Group Management	|Success and Failure|
|	Audit User Account Management	|Success and Failure|

## ..\DS Access
| Field | Value |
| --- | --- |
|	Audit Directory Service Access	|No Auditing|
|	Audit Directory Service Changes	|No Auditing|

## ..\Account Logon
| Field | Value |
| --- | --- |
|	Audit Credential Validation	|Success and Failure|

## ..\..\..\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\
## Click: Windows Firewall Properties (on right hand pane)
| Field | Value |
| --- | --- |
|	Windows Firewall: Firewall state (Domain)	|On|
|	Windows Firewall: Inbound connections (Domain)	|Block|
|	Windows Firewall: Firewall state (Private)	|On|
|	Windows Firewall: Inbound connections (Private)	|Block|
|	Windows Firewall: Firewall state (Public)	|On|
|	Windows Firewall: Inbound connections (Public)	|Block|

## Click: Settings -> Customize 
| Field | Value |
| --- | --- |
|	Windows Firewall: Apply local connection security rules (Public)	|No|
|	Windows Firewall: Apply local firewall rules (Public)	|No|
|	Windows Firewall: Display a notification (Public)	|No|
|	Windows Firewall: Apply local connection security rules (Domain) |No|
|	Windows Firewall: Apply local firewall rules (Domain)	|No|
|	Windows Firewall: Display a notification (Domain)	|Yes|
|	Windows Firewall: Apply local connection security rules (Private)	|No|
|	Windows Firewall: Apply local firewall rules (Private)	|No|
|	Windows Firewall: Display a notification (Private)	|Yes|


   
## ..\..\..\..\..\Adminstrative templates: Policy definitions (AMDX files) retrieved from the local computer
## Windows Componments\Event Log Service\Application\
| Field | Value |
| --- | --- |
| Back up log automatically when full | Disabled |
| Control Event Log behavior when the log file reaches its maximum size | Disabled |
| Specify the maximum log file size (KB) | 32768 KB or greater | 

## ..\Security
| Field | Value |
| --- | --- |
| Back up log automatically when full | Disabled |
| Control Event Log behavior when the log file reaches its maximum size | Disabled |
| Specify the maximum log file size (KB) | 81920 KB or greater | 

## ..\System
| Field | Value |
| --- | --- |
| Back up log automatically when full | Disabled |
| Control Event Log behavior when the log file reaches its maximum size | Disabled |
| Specify the maximum log file size (KB) | 32768 KB or greater | 


## ..\..\Network\Network Connections\Windows Firewall\Domain Profile
| Field | Value |
| --- | --- |
|	Windows Firewall: Allow ICMP exceptions (Domain)	|Disabled|
|	Windows Firewall: Prohibit notifications (Domain)	|Disabled|
|	Windows Firewall: Protect all network connections (Domain)	|Enabled|

## ..\Standard Profile
| Field | Value |
| --- | --- |
| Windows Firewall: Allow ICMP exceptions (Standard)	|Disabled|
| Windows Firewall: Prohibit notifications (Standard)	|Disabled|
| Windows Firewall: Protect all network connections (Standard)	|Enabled|


## ..\..\..\..\Windows Components\Windows Update
| Field | Value |
| --- | --- |
|	Configure Automatic Updates	|Enabled: 3 - Auto download and notify for install|
|	Do not display 'Install Updates and Shut Down' option in Shut Down Windows dialog box	|Disabled|
|	Reschedule Automatic Updates scheduled installations	|Enabled|


## ..\..\Remote Desktop Services\Remote Desktop Session Host\Security
| Field | Value |
| --- | --- |
|	Always prompt client for password upon connection	|Enabled|
|	Do not allow drive redirection	|Enabled|
|	Do not allow passwords to be saved	|Enabled|
|	Set client connection encryption level	|Enabled: High Level|

## ..\..\..\..\..\System\Internet Communication Management\Internet Communication settings
| Field | Value |
| --- | --- |
|	Turn off downloading of print drivers over HTTP	|Enabled|
|	Turn off Internet download for Web publishing and online ordering wizards	|Enabled|
|	Turn off printing over HTTP	|Enabled|
|	Turn off Search Companion content file updates	|Enabled|
|	Turn off the "Publish to Web" task for files and folders	|Enabled|
|	Turn off the Windows Messenger Customer Experience Improvement Program	|Enabled|
|	Turn off Windows Update device driver searching	|Enabled|

## Didn't find locations for below
## Additional Security Settings
| Field | Value |
| --- | --- |
|	Do not process the legacy run list	|For the Enterprise Member Server and Enterprise Domain Controller profile(s), the recommended value is Not Configured. For the SSLF Member Server and SSLF Domain Controller profile(s), the recommended value is Enabled.|
|	Do not process the run once list	|For the Enterprise Member Server and Enterprise Domain Controller profile(s), the recommended value is Not Configured. For the SSLF Member Server and SSLF Domain Controller profile(s), the recommended value is Enabled.|
|	Registry policy processing	|For the Enterprise Member Server and SSLF Member Server profile(s), the recommended value is Enabled (Process even if the Group Policy objects have not changed). For the Enterprise Domain Controller and SSLF Domain Controller profile(s), the recommended value is Not Defined.|
|	Offer Remote Assistance	|For the SSLF Member Server and SSLF Domain Controller profile(s), the recommended value is Disabled. For the Enterprise Member Server and Enterprise Domain Controller profile(s), the recommended value is Not Defined.|
|	Solicited Remote Assistance	|For the SSLF Member Server and SSLF Domain Controller profile(s), the recommended value is Disabled. For the Enterprise Member Server and Enterprise Domain Controller profile(s), the recommended value is Not Defined.|
|	Restrictions for Unauthenticated RPC clients	|For the SSLF Member Server and SSLF Domain Controller profile(s), the recommended value is Enabled: Authenticated. For the Enterprise Member Server and Enterprise Domain Controller profile(s), the recommended value is Not Defined.|
|	RPC Endpoint Mapper Client Authentication	|For the SSLF Member Server and SSLF Domain Controller profile(s), the recommended value is Enabled. For the Enterprise Member Server and Enterprise Domain Controller profile(s), the recommended value is Not Defined.|
|	Turn off Autoplay	|Enabled: All drives|
|	Enumerate administrator accounts on elevation	|For the Enterprise Member Server and Enterprise Domain Controller profile(s), the recommended value is Not Configured. For the SSLF Member Server and SSLF Domain Controller profile(s), the recommended value is Disabled.|
|	Require trusted path for credential entry	|Enabled|
|	Disable remote Desktop Sharing	|Enabled|

# Group Policy Settings

Automating the configuration of group policy settings is not easy to do through batch files or command line. Even Server Core installations give Administrators access to `gpmc.msc`, which gives an interface for managing group policy settings. This is the easiest way to make these changes.

It is recommended that for any group policy settings that need to be changed at the domain level, a new GPO should be created and linked to the domain controller or domain. Setting the `Enforced` setting on the new GPO will cause the enforced settings to override the corresponding settings in the default policy. This practice ensures the protection of default policies as well as an easy way to disable change made in group policy.

On existing systems, it is still worth checking to make sure that policies defined in `Default Domain Policy` and `Default Domain Controller Policy` are in accord with the recommendations outlined below.

Some exceptions need to be added to the policies depending on the specific services that may be running. For instance, if IIS is being implemented on a server, IIS_IUSRS group may need to be given certain specific permissions in order to function properly and securely.

# Enforcing Group Policy Updates

To enforce group policy updates locally on a computer, run the command `gpupdate /force`.

### Firewall settings

Firewall settings on clients must be configured correctly in order to be able to do this. These are the inbound firewall rules that need to be set:
```
Windows Firewall: Allow inbound Remote Desktop exceptions
Windows Firewall: Allow inbound Remote administration exception
Windows Firewall: Allow inbound file and printer sharing exception
```
These open TCP ports 3389, 135, 139, 445, 1024-1034, and UDP ports 137, 138 for inbound traffic.

Can do this through group policy by going to `gpmc`, creating a new GPO, and navigating to this folder in the `Edit...` screen:
```
Computer Configuration > Policies > Admin Templates > Network > Windows Firewall > Domain Profile
```
Can then enable the rules and enforce the group policy as desired. Run `gpupdate /force` on the client computers.

If running versions of Windows Server 2012+, there is the option of using one of the Starter GPOs titled `Group Policy Remote Update Firewall Ports`. This comes packaged with all the firewall settings needed.

### WS 2008 and older
To remotely enforce group policy changes across multiple computers in a network, can download the following tool:<br/>
https://specopssoft.com/product/specops-gpupdate/

Complete installation steps (very quick). Can check off `Add menu extensions` to add options to `Active Directory Users and Computers` tool to force group policy updates on particular OUs or groups.

#### Gpupdate from ADUC Window

- Launch `dsa`
- Right-click desired OU or group
- Click `Gpupdate`

#### Gpupdate from Powershell

Or can do from Powershell commands as this sample shows:

```
# Run GPUpdate on all computers in the webservers security group Get-SpecopsADComputer -group:webservers | Update-SpecopsGroupPolicy 
# Run GPUpdate on all servers that are not webservers $servers = Get-SpecopsADComputer -group:servers
$webservers = Get-SpecopsADComputer -group:webservers
$servers | where {$webservers -notcontains $_} |
 Update-SpecopsGroupPolicy
 ```
 
### WS 2012 and newer

- Launch `gpmc`
- Right-click the desired OU and select `Group Policy Update` from the menu
- Confirm the action in the `Force Group Policy Update` dialog by clicking `Yes`
- Check the results in the Remote Group Policy update results window

# Creating a New GPO to link to the Domain or Domain Controller to override defaults

Go to command line, and type in `gpmc.msc`.

Open the dropdowns `Forests` > `Domains` > `[your domain name]` > `Group Policy Objects`. Right-click to create a new GPO. Right-click the GPO name and click `Edit...`. Define the desired setting in your GPO.

To link the GPO to the domain, right-click the domain name on the dropdown tree in the left pane and click `Link Existing GPO`. Add your GPO. To cause an override of the existing `Default Domain Policy`, right-click the GPO under the domain tree. Check off the box that says `Enforced`.

To link the GPO to the domain controller, follow the same steps as above except instead of right-clicking the domain name, right-click the `Domain Controllers` folder.

To set policy settings in an existing GPO, right-click the GPO that you wish to change and click `Edit...`.

# Recommended Domain Policy Settings (clients)

When a setting is in **bold** it means that the default setting is not the recommended setting. On a new installation, these are the settings that should be changed. On existing installations, all settings should be checked over.

## Password Policy

Go to `Computer Configuration > Policies > Windows Settings > Security Settings > Account Policies > Password Policy`

  - Enforce Password History: 24
  - Max Password Age: 42
  - Min Password Age: 1
  - **Min Password Length: 14 (default is 7)** 
  - Password must meet complexity requirements: Enabled
  - Store passwords using reversible encryption: Disabled

## Account Lockout Policy

Go to `Computer Configuration > Policies > Windows Settings > Security Settings > Account Policies > Account Lockout Policy`

  - **Account Lockout Duration: 30 (default is none)**
  - **Account Lockout Threshold: 3 (default is 0)**
  - **Reset Account Lockout Counter After: 30 (default is none)**

## Kerberos Policy

Go to `Computer Configuration > Policies > Windows Settings > Security Settings > Account Policies > Kerberos Policy`

  - Enforce User Logon Restrictions: Enabled
  - Maximum lifetime for service ticket: 600
  - Maximum lifetime for user ticket: 10
  - Maximum lifetime for user ticket renewal: 7 days
  - Maximum tolerance for user clock synchronization: 5 minutes

## User Rights Assignment

Go to `Computer Configuration > Policies > Windows Settings > Security Settings > Local Policies > User Rights Assignment`

  - Access Credential Manager as a trusted caller: No One
  - **Access this computer from the network: Administrators, Authenticated Users (default Administrators, backup operators, users, everyone)**
  - Act as part of the Operating System: No One
  - Adjust memory quotas for a process: Adminstrators, Local service, network service
  - **Allow log on locally: Administrators, Authenticated Users (default Administrators, Backup Operators, Power Users, Users, and Guest)**
  - Allow log on through Remote Desktop Services: Administrators, Remote Desktop Users
  - **Back up files and directories: Administrators (default Administrators, Backup Operators)**
  - Bypass traverse checking: Administrators, Backup Operators, Users, Everyone, Local Service, Network Service
  - Change system time: Administrators, LOCAL SERVICE
  - **Change the time zone: Administrators, LOCAL SERVICE (default Administrators, Users)**
  - Create a pagefile: Administrators
  - Create a token object: No One
  - Create global objects: Administrators, LOCAL SERVICE, NETWORK SERVICE, Service
  - Create permanent shared objects: No One
  - Create symbolic links: Administrators
  - **Deny access to this computer from the network: Guest, Local account and Administrators (default Guest)**
  - **Deny log on as a batch job: Guest (default no one)**
  - **Deny log on as service: Guest (default no one)**
  - **Deny log on locally: Guest (default no one)**
  - **Deny log on through Remote Desktop Services: Guests, Local Account (default no one)**
  - Enable computer and user accounts to be trusted for delegation: No one
  - Force shutdown from a remote system: Administrators
  - Generate security audits: local service, network service
  - Impersonate a client after authentication: Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE
  - Increase scheduling priority: Administrators
  - Load and unload device drivers: Administrators
  - Lock pages in memory: No one
  - Manage auditing and security log: Administrators
  - Modify an object label: no one
  - Modify firmware environment values: Administrators
  - Obtain an impersonation token for another user in the same session: no one
  - Perform volume maintenance tasks: Administrators
  - **Profile single process: Administrators (default Administrators, Power Users)**
  - Profile system performance: Administrators, `NT SERVICE\WdiServiceHost`
  - Replace a process level token: LOCAL SERVICE, NETWORK SERVICE
  - **Restore files and directories: Administrators (default Administrators, Backup Operators)**
  - **Shut down the system: Administrators (default Administrators, Backup Operators)**
  - Take ownership of files or other objects: Administrators
  
  ## Security Options
  
  Go to `Computer Configuration > Policies > Windows Settings > Security Settings > Local Policies > Security Options`
  
  - **Accounts: Block Microsoft accounts: Users can't add or log on with Microsoft accounts (default Users are able to use Microsoft accounts with Windows)**
  - Accounts: Guest account status: disabled
  - Accounts: Limit local account use of blank passwords to console logon only: Enabled
  - **Accounts: Rename administrator account: {some secure string} (default Administrator)**
  - Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings: Enabled
  - Audit: Shut down system immediately if unable to log security audits: Disabled
  - Devices: Allowed to format and eject removable media: Administrators
  - Devices: Prevent users from installing printer drivers: Enabled
  - Domain member: Digitally encrypt or sign secure channel data (always): Enabled
  - Domain member: Digitally sign secure channel data (when possible): Enabled
  - Domain member: Disable machine account password changes: disabled
  - Domain member: Maximum machine account password age: 30 days
  - Domain member: Require strong (Windows 2000 or later) session key: Enabled
  - **Interactive logon: Do not display last user name: Enabled (default disabled)**
  - Interactive logon: Do not require CTRL+ALT+DEL: disabled
  - **Interactive logon: Machine inactivity limit: 900 seconds (default 0)**
  - **Interactive logon: Message text for users attempting to log on: `There are legal ramifications for misusing confidential information. Your actions may be audited during this logon session for security purposes.` (default none)**
  - **Interactive logon: Message title for users attempting to log on: `Security Warning` (default none)**
  - **Interactive logon: Number of previous logons to cache (in case domain controller is not available): 4 (default 25)**
  - Interactive logon: Prompt user to change password before expiration: 5 days
  - **Interactive logon: Require Domain Controller Authentication to unlock workstation: Enabled (default disabled)**
  - **Interactive logon: Smart card removal behavior: Lock Workstation (default none)**
  - **Microsoft network client: Digitally sign communications (always): enabled (default disabled)**
  - **Microsoft network client: Digitally sign communications (if server agrees): enabled (default enabled)**
  - Microsoft network client: Send unencrypted password to third-party SMB servers: disabled
  - Microsoft network server: Amount of idle time required before suspending session: 15
  - **Microsoft network server: Digitally sign communications (always): enabled (default disabled)**
  - **Microsoft network server: Digitally sign communications (if client agrees): enabled (default disabled)**
  - Microsoft network server: Disconnect clients when logon hours expire: enabled
  - **Microsoft network server: Server SPN target name validation level: accept if provided by client (default off)**
  - Network access: Allow anonymous SID/Name translation: disabled
	- Network access: Do not allow anonymous enumeration of SAM accounts: enabled
  - Network access: Let Everyone permissions apply to anonymous users: disabled
  - Network access: Remotely accessible registry paths: 
  ```
  System\CurrentControlSet\Control\ProductOptionsSystem\CurrentControlSet\Control\Server 
  ApplicationsSoftware\Microsoft\Windows NT\CurrentVersion
  ```
  - Network access: Remotely accessible registry paths and sub-paths: 
  
  ```
  System\CurrentControlSet\Control\Print\Printers System\CurrentControlSet\Services\Eventlog<br/>
  Software\Microsoft\OLAP Server
  Software\Microsoft\Windows 
  NT\CurrentVersion\Print Software\Microsoft\Windows 
  NT\CurrentVersion\Windows 
  System\CurrentControlSet\Control\ContentIndex 
  System\CurrentControlSet\Control\Terminal Server System\CurrentControlSet\Control\Terminal 
  Server\UserConfig    
  System\CurrentControlSet\Control\Terminal 
  Server\DefaultUserConfiguration 
  Software\Microsoft\Windows 
  NT\CurrentVersion\Perflib 
  System\CurrentControlSet\Services\SysmonLog
  ```
  
  - Network access: Restrict anonymous access to Named Pipes and Shares: enabled
  - Network access: Restrict clients allowed to make remote calls to SAM: Administrators: Remote Access: Allow
  - Network access: Shares that can be accessed anonymously: none
  - Network access: Sharing and security model for local accounts: Classic -local users authenticate as themselves
  - **Network security: Allow Local System to use computer identity for NTLM: enabled (default disabled)**
  - **Network security: Allow LocalSystem NULL session fallback: disabled (default in version > Windows Server 2008, else default is enabled)**
  - Network Security: Allow PKU2U authentication requests to this computer to use online identities: disabled
  - Network security: Configure encryption types allowed for Kerberos: RC4_HMAC_MD5, AES128_HMAC_SHA1, AES256_HMAC_SHA1, Future encryption types
  - Network security: Do not store LAN Manager hash value on next password change: enabled
  - Network security: Force logoff when logon hours expire: enabled
  - **Network security: LAN Manager authentication level: Send NTLMv2 response only. Refuse LM & NTLM (default Send NTLMv2 response only)**
  - Network security: LDAP client signing requirements: Negotiate signing
  - **Network security: Minimum session security for NTLM SSP based (including secure RPC) client: Require NTLMv2 session security, Require 128-bit encryption (default Require 128-bit encryption)**
  - **Network security: Minimum session security for NTLM SSP based (including secure RPC) server: Require NTLMv2 session security, Require 128-bit encryption (default Require 128-bit encryption)**
  - Shutdown: Allow system to be shut down without having to log on: enabled
  - System objects: Require case insensitivity for non-Windows subsystems: enabled
  - System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links): enabled
  - **User Account Control: Admin Approval Mode for the Built-in Administrator account: enabled (default disabled)**
  - User Account Control: Allow UIAccess applications to prompt for elevation without using the secure desktop: disabled
  - **User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode: Prompt for consent on the secure desktop (default Prompt for consent for non-Windows binaries)**
  - **User Account Control: Behavior of the elevation prompt for standard users: Automatically deny elevation requests (default Prompt for credentials)**
  - **User Account Control: Detect application installations and prompt for elevation: enabled (default disabled)**
  - User Account Control: Only elevate UIAccess applications that are installed in secure locations: enabled
  - User Account Control: Run all administrators in Admin Approval Mode: enabled
  - User Account Control: Switch to the secure desktop when prompting for elevation: enabled
  - User Account Control: Virtualize file and registry write failures to per-user locations: enabled
  
 # Recommended Domain Controller Policy Settings (controllers)

When a setting is in **bold** it means that the default setting is not the recommended setting. On a new installation, these are the settings that should be changed. On existing installations, all settings should be checked over.

## Password Policy

Go to `Computer Configuration > Policies > Windows Settings > Security Settings > Account Policies > Password Policy`

  - Enforce Password History: 24
  - Max Password Age: 42
  - Min Password Age: 1
  - **Min Password Length: 14 (default is 7)** 
  - Password must meet complexity requirements: Enabled
  - Store passwords using reversible encryption: Disabled

## Account Lockout Policy

Go to `Computer Configuration > Policies > Windows Settings > Security Settings > Account Policies > Account Lockout Policy`

  - **Account Lockout Duration: 30 (default is none)**
  - **Account Lockout Threshold: 3 (default is 0)**
  - **Reset Account Lockout Counter After: 30 (default is none)**

## Kerberos Policy

Go to `Computer Configuration > Policies > Windows Settings > Security Settings > Account Policies > Kerberos Policy`

  - Enforce User Logon Restrictions: Enabled
  - Maximum lifetime for service ticket: 600
  - Maximum lifetime for user ticket: 10
  - Maximum lifetime for user ticket renewal: 7 days
  - Maximum tolerance for user clock synchronization: 5 minutes

## Audit Policy
Go to `Computer Configuration > Policies > Windows Settings > Security Settings > Advanced Audit Policy Configuration`

### Account Logon
- Audit Credential Validation (success/failure)

### Account Management
- Set all these configurations to success/failure

### Detailed Tracking
- Audit PNP Activity (success)
- Audit Process Creation (success)

### DS Access
- Audit Directory Service Access (success/failure)
- Audit Directory Service Changes (success/failure)

### Logon/Logoff
- Audit Account Lockout (success/failure)
- Audit Group Membership (success)
- Audit Logoff (success)
- Audit Logon (success/failure)
- Audit Other Logon/Logoff Events (success/failure)
- Audit Special Logon (success)

### Object Access
- Audit Removable Storage (success/failure)

### Policy Change
- Audit Audit Policy Change (success/failure)
- Audit Authentication Policy Change (success)
- Audit Authorization Policy Change (success)

### Privilege Use
- Audit Sensitive Privilege Use (success/failure)

### System
- Audit IPsec Driver (success/failure)
- Audit Other System Events (success/failure)
- Audit Security State Change (success)
- Audit Security System Extension (success/failure)
- Audit System Integrity (success/failure)

## User Rights Assignment

Go to `Computer Configuration > Policies > Windows Settings > Security Settings > Local Policies > User Rights Assignment`

  - Access Credential Manager as a trusted caller: No One
  - **Access this computer from the network: Administrators, Authenticated Users, Enterprise Domain Controllers (default Administrators, Authenticated Users, Enterprise Domain Controllers, everyone, pre-windows 2000 compatible…)**
  - Act as part of the Operating System: No One
  - Adjust memory quotas for a process: Adminstrators, Local service, network service
  - **Allow log on locally: Administrators, Enterprise domain controllers (default Account Operators, Administrators, Backup Operators, and Print Operators)**
  - Allow log on through Remote Desktop Services: Administrators
  - **Back up files and directories: Administrators (default Administrators, Backup Operators, Server Operators)**
  - Bypass traverse checking: Administrators, Backup Operators, Users, Everyone, LOCAL SERVICE, Network Service
  - **Change system time: Administrators, LOCAL SERVICE (default Administrators, LOCAL SERVICE, Server Operators)**
  - **Change the time zone: Administrators, LOCAL SERVICE (default Administrators, Users)**
  - Create a pagefile: Administrators
  - Create a token object: No One
  - Create global objects: Administrators, LOCAL SERVICE, NETWORK SERVICE, Service
  - Create permanent shared objects: No One
  - Create symbolic links: Administrators
  - **Deny access to this computer from the network: Guest, Local account (default Guest)**
  - **Deny log on as a batch job: Guest (default no one)**
  - **Deny log on as service: Guest (default no one)**
  - **Deny log on locally: Guest (default no one)**
  - **Deny log on through Remote Desktop Services: Guests, Local Account (default no one)**
  - Enable computer and user accounts to be trusted for delegation: Administrators
  - **Force shutdown from a remote system: Administrators (default Administrators, server operators)**
  - Generate security audits: local service, network service
  - Impersonate a client after authentication: Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE
  - Increase scheduling priority: Administrators
  - **Load and unload device drivers: Administrators (default Administrators and Print Operators)**
  - Lock pages in memory: No one
  - **Log on as a batch job: Administrators (default Administrators, Backup Operators)**
  - Log on as a service: No one
  - Manage auditing and security log: Administrators
  - Modify an object label: no one
  - Modify firmware environment values: Administrators
  - Obtain an impersonation token for another user in the same session: no one
  - Perform volume maintenance tasks: Administrators
  - **Profile single process: Administrators (default Administrators, Power Users)**
  - Profile system performance: Administrators, `NT SERVICE\WdiServiceHost`
  - Replace a process level token: LOCAL SERVICE, NETWORK SERVICE
  - **Restore files and directories: Administrators (default Administrators, Backup Operators, Server Operators)**
  - **Shut down the system: Administrators (default Administrators, Backup Operators, Server Operators, Print Operators)**
  - Take ownership of files or other objects: Administrators
  
  ## Security Options
  
  Go to `Computer Configuration > Policies > Windows Settings > Security Settings > Local Policies > Security Options`
  
  - **Accounts: Block Microsoft accounts: Users can't add or log on with Microsoft accounts (default Users are able to use Microsoft accounts with Windows)**
  - Accounts: Guest account status: disabled
  - Accounts: Limit local account use of blank passwords to console logon only: Enabled
  - **Accounts: Rename administrator account: {some secure string} (default Administrator)**
  - Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings: Enabled
  - Audit: Shut down system immediately if unable to log security audits: Disabled
  - Devices: Allowed to format and eject removable media: Administrators
  - Devices: Prevent users from installing printer drivers: Enabled
  - Domain controller: Allow server operators to schedule tasks: disabled
  - **Domain controller: LDAP server signing requirements: Require signing (default None)**
  - Domain controller: Refuse machine account password changes: disabled
  - Domain member: Digitally encrypt or sign secure channel data (always): Enabled
  - Domain member: Digitally sign secure channel data (when possible): Enabled
  - Domain member: Disable machine account password changes: disabled
  - Domain member: Maximum machine account password age: 30 days
  - Domain member: Require strong (Windows 2000 or later) session key: Enabled
  - **Interactive logon: Do not display last user name: Enabled (default disabled)**
  - Interactive logon: Do not require CTRL+ALT+DEL: disabled
  - **Interactive logon: Machine inactivity limit: 900 seconds (default 0)**
  - **Interactive logon: Message text for users attempting to log on: `There are legal ramifications for misusing confidential information. Your actions may be audited during this logon session for security purposes.` (default none)**
  - **Interactive logon: Message title for users attempting to log on: `Security Warning` (default none)**
  - **Interactive logon: Number of previous logons to cache (in case domain controller is not available): 4 (default 25)**
  - Interactive logon: Prompt user to change password before expiration: 5 days
  - **Interactive logon: Smart card removal behavior: Lock Workstation (default none)**
  - **Microsoft network client: Digitally sign communications (always): enabled (default disabled)**
  - **Microsoft network client: Digitally sign communications (if server agrees): enabled (default enabled)**
  - Microsoft network client: Send unencrypted password to third-party SMB servers: disabled
  - Microsoft network server: Amount of idle time required before suspending session: 15
  - **Microsoft network server: Digitally sign communications (always): enabled (default disabled)**
  - **Microsoft network server: Digitally sign communications (if client agrees): enabled (default disabled)**
  - Microsoft network server: Disconnect clients when logon hours expire: enabled
  - Network access: Allow anonymous SID/Name translation: disabled
  - **Network access: Do not allow storage of passwords and credentials for network authentication: enabled (default disabled)**
  - Network access: Let Everyone permissions apply to anonymous users: disabled
  - Network access: Remotely accessible registry paths: 
  ```
  System\CurrentControlSet\Control\ProductOptionsSystem\CurrentControlSet\Control\Server 
  ApplicationsSoftware\Microsoft\Windows NT\CurrentVersion
  ```
  - Network access: Remotely accessible registry paths and sub-paths: 
  
  ```
  System\CurrentControlSet\Control\Print\Printers System\CurrentControlSet\Services\Eventlog<br/>
  Software\Microsoft\OLAP Server
  Software\Microsoft\Windows 
  NT\CurrentVersion\Print Software\Microsoft\Windows 
  NT\CurrentVersion\Windows 
  System\CurrentControlSet\Control\ContentIndex 
  System\CurrentControlSet\Control\Terminal Server System\CurrentControlSet\Control\Terminal 
  Server\UserConfig    
  System\CurrentControlSet\Control\Terminal 
  Server\DefaultUserConfiguration 
  Software\Microsoft\Windows 
  NT\CurrentVersion\Perflib 
  System\CurrentControlSet\Services\SysmonLog
  ```
  - Network access: Restrict anonymous access to Named Pipes and Shares: enabled
  - Network access: Shares that can be accessed anonymously: none
  - Network access: Sharing and security model for local accounts: Classic -local users authenticate as themselves
  - **Network security: Allow Local System to use computer identity for NTLM: enabled (default disabled)**
  - **Network security: Allow LocalSystem NULL session fallback: disabled (default in version > Windows Server 2008, else default is enabled)**
  - Network Security: Allow PKU2U authentication requests to this computer to use online identities: disabled
  - Network security: Configure encryption types allowed for Kerberos: RC4_HMAC_MD5, AES128_HMAC_SHA1, AES256_HMAC_SHA1, Future encryption types
  - Network security: Do not store LAN Manager hash value on next password change: enabled
  - Network security: Force logoff when logon hours expire: enabled
  - **Network security: LAN Manager authentication level: Send NTLMv2 response only. Refuse LM & NTLM (default Send NTLMv2 response only)**
  - Network security: LDAP client signing requirements: Negotiate signing
  - **Network security: Minimum session security for NTLM SSP based (including secure RPC) client: Require NTLMv2 session security, Require 128-bit encryption (default Require 128-bit encryption)**
  - **Network security: Minimum session security for NTLM SSP based (including secure RPC) server: Require NTLMv2 session security, Require 128-bit encryption (default Require 128-bit encryption)**
  - Shutdown: Allow system to be shut down without having to log on: enabled
  - System objects: Require case insensitivity for non-Windows subsystems: enabled
  - System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links): enabled
  - **User Account Control: Admin Approval Mode for the Built-in Administrator account: enabled (default disabled)**
  - User Account Control: Allow UIAccess applications to prompt for elevation without using the secure desktop: disabled
  - **User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode: Prompt for consent on the secure desktop (default Prompt for consent for non-Windows binaries)**
  - **User Account Control: Behavior of the elevation prompt for standard users: Automatically deny elevation requests (default Prompt for credentials)**
  - **User Account Control: Detect application installations and prompt for elevation: enabled (default disabled)**
  - User Account Control: Only elevate UIAccess applications that are installed in secure locations: enabled
  - User Account Control: Run all administrators in Admin Approval Mode: enabled
  - User Account Control: Switch to the secure desktop when prompting for elevation: enabled
  - User Account Control: Virtualize file and registry write failures to per-user locations: enabled

## Resources
- [CIS Benchmarks for Windows Server 2016](https://utexas.app.box.com/v/CISBenchmarkWindowsServer2016)
- [Audit Policy Best Practices](https://activedirectorypro.com/audit-policy-best-practices/)
- [Group Policy Best Practices](https://activedirectorypro.com/group-policy-best-practices/)
- [Forcing Group Policy Updates in WS 2012](https://www.petri.com/force-remote-group-policy-update-gpmc)
- [Firewall Setup for Remote Group Policy Update](https://social.technet.microsoft.com/Forums/en-US/dd0d8368-522d-4dcb-9406-0eb8bb8f4e40/windows-firewall-rules-setup-for-inboundoutbound-for-gp-result?forum=winserverwsus)

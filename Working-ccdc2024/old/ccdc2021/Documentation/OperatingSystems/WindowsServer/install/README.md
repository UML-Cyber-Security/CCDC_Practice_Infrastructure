# Windows Server 2016 and Active Directory Installation

## Install Windows Server 2016

Create a new virtual machine. Give it at least 4096 MB of space. Select “Create virtual hard disk”. Set file size to 80GB and select “Dynamically allocated” under the “Storage on Physical Hard Disk” section. Leave the other defaults.

The system will prompt you for an installation file. Select the Windows Server 2016 ISO and click Next. Choose the Microsoft Windows Server 2016 Datacenter Evaluation. Select the Custom install option. Leave the defaults and install.

The system will prompt you to create an administrator account. Use your own complex password.

## Install and Set Up Active Directory (GUI)

Log in as Administrator. Open ServerManager.exe.

Click ```Add Roles and Features```. Click ```Next```. Select ```Role-based or feature-based installation```. Click ```Next```. Click ```Next``` again. Check off the box that says ```Active Directory Domain Services```. When a dialog box pops up asking you to add features, click ```Add features```. Continue to click ```Next``` until the active directory installation begins. 

Once the installation completes, click ```Promote this server to a domain controller```. This will open another wizard.

Select ```Add a new forest``` and type in the desired name of your domain. The next page asks you to set up a DSRM password for recovery purposes. Choose your own complex password. Click ```Next```. Ignore warnings. Continue to click ```Next```, leaving all the defaults until you get to the install page. Click ```Install```.

The system will automatically restart.

## Install and Set Up Active Directory (PowerShell)

1. Log in as Administrator.

2. Install Active Directory:

```
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
```

3. To view the available module commands related to AD DS:

```
Get-Command -Module ADDSDeployment
```
4. Install the root domain:

```
Install-ADDSForest -DomainName “corp.momco.com”
```
System will prompt you for a safe mode (DSRM) password. Will also warn you that the target account will now be acting a domain controller for the active directory. Type ```y``` to confirm. The system will automatically restart when finished to apply the changes.

5. After the machine restarts to apply the new changes you should now be able to view this client on your Windows server domain controller (DC) by typing:

```
Get-ADComputer | Format-Table DNSHostName, Enabled, Name, SamAccountName
```
5. You can add a user to the AD domain by typing:

```
New-ADUser -Name [Username] -AccountPassword(Read-Host -AsSecureString AccountPassword) -PassThru | Enable-ADAccount
```

## Security Analysis
- Attackers can obtain access using brute force, dictionary attacks, and other tools on passwords
  - Set minimum password length
  - Enable password complexity requirements
  - Do not store passwords using reversible encryption (Default)
  - Configure account lockout policy
- Attackers may abuse user rights to log on to the console of the computer and download/run malicious software to elevate their privileges
  - Configure ‘Allow log on locally’ using the following settings:
    - Level 1 (Domain Controller). The recommended state for this setting is: Administrators, ENTERPRISE DOMAIN CONTROLLERS.
    - Level 1 (Member Server). The recommended state for this setting is: Administrators.
- Guest accounts with different log on options available to them may be able to manipulate system resources or configure and start unauthorized services
  - Ensure 'Deny log on as a batch job' includes 'Guests'
  - Ensure 'Deny log on as a service' includes 'Guests'
  - Ensure ‘Deny log on locally’ includes ‘Guests’
  - Ensure 'Deny log on through Remote Desktop Services' includes 'Guests, Local account'

### Configure Time Synchronization

* Reasons why accurate time is necessary:
  * Kerberos: requires five minutes of accuracy between the client and server
  * Government regulations:
    * 50 ms acuracy for FINRA in the US
    * 1 ms ESMA (MiFID II) in the EU
    * Cryptographic Algorithms
    * Distributed systems like Cluster/SQL/Exchange and Document databases
    * Blockchain framework for bitcoin transactions
    * Distributed logs and threat Analysis
    * AD replication
    * PCI (Payment Card Industry), currently 1 second accuracy
* Sync time on domain controllers to a stratum-one external time server
  * Sync time on non-domain servers to an external NTP Server
  * Rely on an external NTP server to protect against NTP-based DDoS attacks
* Ensure servers are set to proper time zone (for logging, etc.)

### Configure Windows firewall

* Restrict traffic only to ports that need to be open for services
  * For example: web serbers will need to provide access to TCP ports 80 and 443 for most user, but they **do not** need RDP access from all sources
* Restrict management access (ex. RDP, WMI, etc.) to only those IPs and networks belonging to system administrators

### Secure and Encrypt Remote Access

* RDP should only be accessible by authorized administrators
* Prune Remote Desktop Users group
* Telnet and other unencrypted management protocols should be disabled across the whole environment
* Use only encrypted remote access
  * SFTP
  * SSH (From VPN access)
  
### Networking 
* Set Static IP - guarantees you are connecting to the right server when trying to connect. 
	* Adding a network firewall
	* Disable server vices such as IPv6 that you are not using 
	* Disable inbound traffic on ports that you are not using 
* Segment network 
	* Host on same subnet will have an easier chance pretending to be the server. 
* Use secondary DNS servers for load-balancing and redundancy 
	* Also having more than one allows for a backup in case anything should happen 

### Users/Admins on the Server 
* Disable local admins and secure admin rights 
	* Create your own admin that is not defaulted in, especially in AD, and make a strong password for it and add to admin group
		* Using the default admin name is too easy to be broken into - where if you had a admin name like [company]support, [company]admin, etc. then the hacker would have to get the exact username and the exact password - making it a little harder on his end and easier on our end 
*Do not recuse admin password through the environment 
	*Passwords should be changed regularly in order to prevent password leaks that could lead to new breaches 
	* Have strong password policies 
	*Complexity/length 
	* Expirations 
	* Re-use policies 
	* Enable account lockout for repeated failed attempts 

### Packages/Services to Install/Uninstall
* Make sure that everything is UpToDate 
	* Test updates in a testing environment to make sure these updates won't cause any issues 
* Microsoft Products are up to date 
	* Especially Exchange Server and SQL Server 
* Update 3rd party applications 
* Services that are running and should that are not in use should be turned off immediately 
* Set up a specific account for applications and user services 
	* This provides that if an attacker gets access they have limited control based on the account they have gotten into 
* In Windows Features disable default applications that are not being used 

Resources used for security analysis:
- University of Texas WS 2016 hardening checklist: https://security.utexas.edu/os-hardening-checklist/windows-2016
- CIS Benchmark recommendations for WS 2016: https://utexas.app.box.com/v/CISBenchmarkWindowsServer2016
- [Why is time important?](https://docs.microsoft.com/en-us/windows-server/networking/windows-time-service/accurate-time)
- [Configure time synch, Win firewall, secure and encrypt remote access])(https://www.tevora.com/10-essential-baseline-security-hardening-considerations-windows-server-2016/)
- https://www.tevora.com/10-essential-baseline-security-hardening-considerations-windows-server-2016/

## Script with Comments

```
# enforce password and account lockout policy over the active directory
$parms = @{ 'Identity' = 'test.net';
            'MinPasswordLength' = 14;
            'ComplexityEnabled' = 1;
            'ReversibleEncryptionEnabled' = 0;
            'LockoutDuration' = '00:30:00';
            'LockoutThreshold' = 3;
            'LockoutObservationWindow' = '00:30:00';
          }

Set-ADDefaultDomainPasswordPolicy @parms
```

## References

- [Windows Server 2016 Install](https://www.tactig.com/install-windows-server-step-by-step/)

- [AD Install with GUI](https://blogs.technet.microsoft.com/canitpro/2017/02/22/step-by-step-setting-up-active-directory-in-windows-server-2016/)

- [AD Install PowerShell script](https://medium.com/@eeubanks/install-ad-ds-dns-and-dhcp-using-powershell-on-windows-server-2016-ac331e5988a7)

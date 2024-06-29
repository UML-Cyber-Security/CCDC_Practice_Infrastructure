
# Free IPA Notes 
Updated 01/19/2024

## Installation Steps (Rocky Linux)

Open the necessary ports for FreeIPA to function and make sure they stay open beyond reboots
```
firewall-cmd --add-service=freeipa-ldap --add-service=freeipa-ldaps

firewall-cmd --add-service=freeipa-ldap --add-service=freeipa-ldaps --permanent
```
Install FreeIPA and start the Initialization Process
```
dnf install freeipa-server

ipa-server-install
```

Once initialization has started, you will be prompted for information.
Default option is shown in parenthesis and is good for most values.

- No for internal DNS
- static hostname is whatever your DNS entry for the machine is. 
(can be found using `hostnamectl` command or in the `/etc/hostname` file)
- realm name is the static name but in all caps
- admin password is whatever you like
- directory manager password is also whatever you like
- all future prompts are default value until it asks if you would like to proceed, choose yes

Wait a few minutes and FreeIPA should be properly installed


## Important Commands

- `kinit <user>`  allows you to authenticate as a user (password required)
- `ipa user-add`  adds a new user
- `ipa passwd <user>` changes the password for a user
- `man ipa` shows more information for commands


## Link Dump

General Start-Up Guide: https://www.freeipa.org/page/Quick_Start_Guide  

Deployment Guide: https://www.freeipa.org/page/Deployment_Recommendations

Web-UI Basics: https://www.freeipa.org/page/Web_UI 

Making/Restoring Backups: https://www.freeipa.org/page/Backup_and_Restore, 
https://www.freeipa.org/page/V3/Backup_and_Restore 

Windows Active Directory Integration Info: 
https://computingforgeeks.com/establish-trust-between-ipa-and-active-directory/ 

Centralized one stop logging information: 
https://www.freeipa.org/page/Centralized_Logging 

FreeIPA behind a proxy (HTTP) or DMZ: 
https://www.adelton.com/freeipa/freeipa-behind-proxy-with-different-name 

FreeIPA possible Vulnerabilities: 
https://book.hacktricks.xyz/linux-hardening/freeipa-pentesting 

Disabling Anonymous Unauthenticated Binds: 
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/linux_domain_identity_authentication_and_policy_guide/disabling-anon-binds 


## Mistakes Made


**Need a static domain name**
(sidenote) installed vim with “sudo yum install vim”
#hostnamectl will display hostname information, we are worried about Static hostname at the top. Remember this for later.
Mine was unused so I edited the  /etc/hostname file and typed “freeipa” as the new static hostname.
^^This does not work because the hostname needs to be resolvable by the DNS, so I just had to wait for a valid hostname to use.

**Using incorrect hostnames in the /etc/hostname folder**
Hostname for freeIPA needed a domain name to have 2 or more fields.
I originally just had “freeipa.test”, but the domain name must have more than 1 field, so I changed it to “server.freeipa.test” and the initial config ran smoothly.

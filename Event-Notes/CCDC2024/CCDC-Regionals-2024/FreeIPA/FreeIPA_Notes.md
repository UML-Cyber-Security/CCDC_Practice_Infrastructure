# FreeIPA Documentation
### [Installation](#installation) | [Commands](#commands) | [Migration](#migration) | [Conceptual Info](#conceptual-info) | [Removal](#removal) | [Possible Injects](#possible-injects) | [Links](#links)
---
<br/><br/>


# Installation ([Client](#client-rhel-or-ubuntu) and [Server](#server-do-this-on-rhel))

## Server (Do this on RHEL)

### Change Hostname so it has 3 fields (ex first.second.third)
`hostnamectl set-hostname <freeipa.zodu.com>`


### Add firewall rules to open needed ports
```bash
firewall-cmd --add-service=freeipa-ldap --add-service=freeipa-ldaps

firewall-cmd --add-service=freeipa-ldap --add-service=freeipa-ldaps --permanent

firewall-cmd --add-port={80/tcp,443/tcp,389/tcp,636/tcp,88/tcp,464/tcp,53/tcp,88/udp,464/udp,53/udp,123/udp}

firewall-cmd --add-port={80/tcp,443/tcp,389/tcp,636/tcp,88/tcp,464/tcp,53/tcp,88/udp,464/udp,53/udp,123/udp} --permanent

firewall-cmd --reload
```

### Install the FreeIPA Server
```bash
sudo dnf install freeipa-server

sudo ipa-server-install
```
This will ask a lot of questions, heres a guide:
- Yes for internal DNS
- default domain name
- default realm name
- Whatever you want for directory manager and admin password
- everything is default here until you reach "continue with these values?" choose yes.




## Client ([RHEL](#rhel) or [Ubuntu](#ubuntu))

### RHEL:

### Change Hostname so it has 3 fields (ex first.second.third)
`hostnamectl set-hostname <service.zodu.com>`


### Add server to /etc/hosts
example line: `192.168.2.127 freeipa.zodu.com`


### Add firewall rules to open needed ports
```bash
sudo firewall-cmd --add-service=freeipa-ldap --add-service=freeipa-ldaps

sudo firewall-cmd --add-service=freeipa-ldap --add-service=freeipa-ldaps --permanent

sudo firewall-cmd --add-port={80/tcp,443/tcp,389/tcp,636/tcp,88/tcp,464/tcp,88/udp,464/udp,53/udp}

sudo firewall-cmd --add-port={80/tcp,443/tcp,389/tcp,636/tcp,88/tcp,464/tcp,88/udp,464/udp,53/udp} --permanent

sudo firewall-cmd --reload
```

### Install the FreeIPA Server
```bash
sudo dnf install freeipa-client

sudo ipa-client-install
```

### Ubuntu:

### Change Hostname so it has 3 fields (ex first.second.third)
`hostnamectl set-hostname <service.zodu.com>`

### Add server to /etc/hosts
example line: `192.168.2.127 freeipa.zodu.com`

### Add firewall rules to open needed ports
```bash

ufw add 22 # also do this for 80, 88, 443, 389, 464

ufw enable
```

### Install the FreeIPA Server
```bash
sudo apt install freeipa-client

sudo ipa-client-install
```
<br><br>

# Commands
Also see [Command List](https://freeipa.readthedocs.io/en/latest/api/commands.html) or [Command Structure](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_identity_management/introduction-to-the-ipa-command-line-utilities_configuring-and-managing-idm).

### `ipa help commands` displays a list  of ipa commands

### `ipa help topics` displays a list of all the ipa topics

### `kinit <user>` allows you to login as a user with a password

### `ipa passwd <user>` adds/changes the password for a user

### `ipa user-add <name>` adds a user with a given name (no password)

### `ipa user-del <name>` deletes a user with a given name

### `ipa user-find <name>` finds users with that name (lists all users if no name given)

### `ipa user-show <name>` displays more information on a user with that name

### `ipa user-mod <name>` Modifies a user using flags shown [here](https://freeipa.readthedocs.io/en/latest/api/user_mod.html)

### `ipa host-del <name>`  deletes a host machine from FreeIPA

### `ipa host-find` shows all the machines with clients connected to the server

### `ipa host-show <name>` shows more information on a given host

### `man ipa` gives more information on other commands

### `ipa-backup` creates a backup of the FreeIPA Server in `/var/lib/ipa/backup/`.

Must be run as root. More Information in the [Link Section](#backup-and-restore-red-hat-backing-up-and-restoring-identity-management ).

> Arguments:
>
> `--data` does a data only backup. A full Server backup is done by default.
>
> `--logs` includes logs into the backup.

### `ipa-restore <Directory_Name> ` restores from backup in `/var/lib/ipa/backup`.
> Arguments:
>
> `/file/path/for/backup` if the backup is in a different directory than default.
>
> `--data` does a data only restore. A full Server restore is done by default if the backup allows.
>
> `--no-logs` does not includes logs into the restoration if the backup has logs.

<br/><br/>

# Migration
Important Note: New Machine must have the same host as the original machine.

### 1. Backup the Existing FreeIPA Server using.
`ipa-backup --logs`

### 2a. Install FreeIPA on the new machine if you haven't already.
**Make Sure the Hostname is the same as the original machine!!!**

More Information [here](#installation).

### 2b. Move the Backup File To the New machine.
`scp /var/lib/ipa/backup <user@NewMachine>:/var/lib/ipa/backup/`.

### 3. Restore the Backup on the new machine.
`ipa-restore <Directory_Name>`

<br/><br/>

# Conceptual Info:
There should be one IPA Server, Ideally on a RHEL machine.

Clients should be on all Linux machines that can have them, regardless of OS.





<br/><br/>

# Removal
To Remove the installation run either:

`ipa-server-install --uninstall` or `ipa-client-install --uninstall`
<br/><br/>


# Possible Injects:

### Password Policy for Users
```bash 
# Look at all the groups available
ipa group-find

# Add a Group if needed
ipa group-add <groupname> -desc "a description of the group"

# Add Users to a group if needed
ipa group-add-member <groupname> --users={username1, username2}

# Add a Policy to a group if needed
# (leave groupname empty to make it global)
ipa pwpolicy-add <groupname> -minlength=9 -minclasses=3

# Modify a Policy for a group
# (leave groupname empty to make it global)
ipa pwpolicy-mod <groupname> -maxlife=90 -minlife=8

# Show a policy for a user for proof
ipa pwpolicy-show -user=<username>

# Show the global password policy
ipa pwpolicy-show

```

### Windows AD Integration
Note: untested, might need changes

On Windows AD
```bash
# Add the hostname and IP of IPA Server
dnscmd 127.0.0.1 /ZoneAdd <freeipa_hostname> /Forwarder <freeipa_IP>

# get the time zone for windows (remember to match with FreeIPA)
Get-TimeZone

```

On FreeIPA Server
```bash
# Make sure the timezone matches wiht windows
sudo timedatectl set-timezone <timezone>

# Edit the /etc/sysctd.d/ipv6.conf file to include:
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.<interface>.disable_ipv6 = 1
# replace <interface> with the network interface (ex: ens18)

# Edit the /etc/hosts file to have the ADs
example line: 192.168.3.111 ad.zodu.com

# Install the needed package
sudo yum install -y "*ipa-server" "*ipa-server-trust-ad" ipa-server-dns bind bind-dyndb-ldap

# Install the needed tools to make a trust
ipa-adtrust-install --netbios-name=ipa_netbios

# With AD and IPA Ready, run this with windows admin password
ipa trust-add --type=ad <ad_domain> --admin Administrator --password
```



### Client Install on all Machines with Proof
Follow the client install process shown [above](#client-rhel-or-ubuntu)

On the server machine:
```bash
# List all the hosts connected to the server
ipa host-find
# For clean output, grep the output like this
ipa host-find | grep "Host name"

```


### Gitlab Integration
Follow this link [here](#gitlab-integration-info-gitlab-integration-gitlab-docs).

On FreeIPA Server:
```bash
# create a "gitlabusers" & "gitlabadmins" group
ipa group-add gitlabusers -desc "group for gitlab users integration"
ipa group-add gitlabadmins -desc "group for gitlab admins integration"

# Check the groups were made
ipa group-find

# Add Users to the groups as you need
ipa group-add-member <groupname> --users={username1, username2}

# Add Gitlab to /etc/hosts
example line: 192.168.3.222 gitlab.zodu.com
```

On Gitlab
```bash
# Edit the gitlabbdn.update file to include:
dn: uid=GITLAB_DOMAIN_NAME,cn=users,cn=accounts,dc=zodu,dc=com
add:objectclass:account
add:objectclass:simplesecurityobject
add:uid:GITLAB_DOMAIN_NAME
add:userPassword:USERPASSWORDHERE
add:passwordExpirationTime:20380119031407Z
add:nsIdleTimeout:0
```

Back on the IPA Server Run:
```bash
# Sign in as admin
kinit admin

# Update using the gitlab update file
ipa-ldap-updater gitlab-bind.update

# If the filename doesnt work, find the file in the /usr/share/ipa/updates

# If the file isn't there, run the ldapadd command to add it

```

Finally on Gitlab:
```bash
# Modify LDAP Section of /etc/gitlab/gitlab.rb to include:

gitlab_rails['ldap_enabled'] = true
gitlab_rails['prevent_ldap_sign_in'] = false

###! **remember to close this block with 'EOS' below**
gitlab_rails['ldap_servers'] = YAML.load <<-'EOS'
  main:
    label: 'My LDAP'
    host: 'ipa.example.com'
    port: 389
    uid: 'uid'
    bind_dn: 'uid=gitlabbdn,cn=users,cn=accounts,dc=example,dc=com'
    password: 's3cr3tP455w0rdHERE'
    encryption: 'start_tls'
    verify_certificates: false
    smartcard_auth: false
    active_directory: false
    allow_username_or_email_login: false
    lowercase_usernames: false
    block_auto_created_users: false
    base: 'cn=accounts,dc=example,dc=com'
    user_filter: '(memberof=CN=gitlabusers,CN=groups,CN=accounts,DC=example,DC=com)'
    attributes:
      username: ['uid']
      email: ['mail']
      name: 'displayName'
      first_name: 'givenName'
      last_name: 'sn'
EOS

# Then in the terminal run:
gitlab-ctl reconfigure
```

Now you should be able to authenticate in Gitlab through FreeIPA



<br><br>


# Links
 ### Backup and restore [Red Hat Backing Up and Restoring Identity Management](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/linux_domain_identity_authentication_and_policy_guide/backup-restore)

 ### Migrating IPA [Examples of using migrate-ds](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/linux_domain_identity_authentication_and_policy_guide/using-migrate-ds)
 Note: this is not used for FreeIPA to FreeIPA, but for other LDAP providers moving to FreeIPA.

### Windows Active Directory Integration Info: [AD Integration](https://computingforgeeks.com/establish-trust-between-ipa-and-active-directory/)

### Gitlab Integration Info: [Gitlab Integration](https://dev.to/kenmoini/ldap-on-gitlab-with-red-hat-identity-management-freeipa-3f5l), [Gitlab Docs](https://docs.gitlab.com/ee/administration/auth/ldap/?tab=Helm+chart+%28Kubernetes%29)

### Centralized one stop logging information: [Centralized Logs](https://www.freeipa.org/page/Centralized_Logging)

### FreeIPA behind a proxy (HTTP) or DMZ: [IPA with proxy](https://www.adelton.com/freeipa/freeipa-behind-proxy-with-different-name)

### FreeIPA possible Vulnerabilities: [IPA Vulnerabilities](https://book.hacktricks.xyz/linux-hardening/freeipa-pentesting)

### Disabling Anonymous Unauthenticated Binds: [Anonymous Binds](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/), [Anonymous Bind Disable](html/linux_domain_identity_authentication_and_policy_guide/disabling-anon-binds)

### Live FreeIPA Web Environment Demo: [IPA Web GUI DEMO](https://www.freeipa.org/page/Demo)

### Potential IP Table Configuration: [IPA IP Tables](https://adam.younglogic.com/2013/03/iptables-rules-for-freeipa/)

### ALL IPA COMMAND LINE COMMANDS: [IPA COMMANDS](https://freeipa.readthedocs.io/en/latest/api/commands.html)

### Basic Command Structure: [Ipa Command Structure](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_identity_management/introduction-to-the-ipa-command-line-utilities_configuring-and-managing-idm)





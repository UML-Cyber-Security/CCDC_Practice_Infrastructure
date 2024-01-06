# Basics
##### Written by a sad Matthew Harper

Where things are generally stored 


# Custom
## Sudo 
The SUDO script will chaneg the logging location for sudo actions to be stored at the following location
```
/var/log/sudo.log
```
If we do not use the sudo script the logs will be stored at the systems default logging equivalent of the following 
```
/var/log/syslog
```
## Iptables
Currently there is additional logging for SSH-INITAL connections,  INVALID packets (indicative of a scan), and ICMP-FLOOD packets (possible)

* SSH-INITAL will result in logs prefixed at log-level 5 (Notice) with 
  * "IPTables-SSH-INITIAL: "
* INVALID packets will result in logs prefixed at log-level 4 (Warning) with 
  * "IPTables-INVALID-LOG: "
* ICMP-FLOOD will result in logs prefixed at log-level 4 (warning) with
  * "IPTables-ICMP-FLOOD: " 
* Traffic to Docker containers will result in logs prefixed at log-level 5 (Notice) with
  * "IPTables-DOCKER-LOG:"

These are again stored in the systems default logging equivalent of the following 
```
/var/log/syslog
``` 

## Healthchecks
### Core Service
* "\[Health-Check-Docker:\]" - Indicates docker is not running
* "\[Health-Check-Auditd\]" - Indicates Auditd is not running
* "\[Health-Check-Glusterd\]" - Indicates Gluster is not running -- likely not needed.
*  "\[Health-Check-SSHD\]" - Indicates SSH server is not running -- bad...
*  "\[Health-Check-Cron\]" - Indicates Cron is not running
*   "\[Health-Check-Wazuh-Agent\]" - Indicates Wazuh is not running
*   "\[Health-Check-Rsyslog\]" - Indicates rsyslog is not running
*   "\[Health-Check-Auditd\]" - Indicates malformed auditd rules
    *   Need to change the value when deployed.
*   "\[Health-Check-sysctl\]" - Indicates malformed systemctl rule

These are again stored in the systems default logging equivalent of the following 
```
/var/log/syslog
``` 
## Auditd 
-- ref AUDITD section for manual overview

### Keys
* time-change
  * This is any time changes or commands used to change the time on the machine 
* system-locale
  * Changes to hostname, domainname
  * Changes to /etc/issues(.net)
  * Changes to /etc/hosts 
  * Changes to /etc/network 
* MAC-policy
  * if apparmor is enabled it will be watched
* logins
  * /var/log/faillog write and attribute change (chmod) 
  * /var/log/lastlog
  * /var/log/tallylog
  * /var/log/wtmp
  * /var/log/btmp
  * /etc/login.defs
  * /etc/securetty
* session
  * /var/run/utmp 
* perm_mod
  * Any changes to permissions
* access
  * Any unauthorized access attempts are logged
* mounts
  * Log any successful file system mounts 
* delete
  * File deletion events
* scope
  * Changes to sudoers or sudoer.d files/dirs
  * /etc/sudoers: Changes to sudoers file
* sudo_log -- anything as root
  * Log all sudo commands 
* modules
  * /sbin/insmod (execute)
  * /sbin/rmmod
  * /sbin/modprobe
  * Initalizing and deleting module (syscalls)
* Cron 
  * /var/spool/atspool: creation of at rules
  * /etc/at.allow: Editing of at allow list
  * /etc/at.deny: Editing of at deny list
  * /etc/cron.allow: Editing of cron allow list 
  * /etc/cron.deny: Editing of cron deny list 
  * /etc/cron.d/: Editing of cron.d directory (file creation ect)
  * /etc/cron.monthly/: Monthly cron jobs (Not important)
  * /etc/cron.weekly/: Weekly (not important)
  * /etc/cron.daily/: Daily cron job editing (not super relevant)
  * /etc/cron.hourly/: Hourly cron jobs
  * /etc/crontab: Edits
  * /var/spool/cron/root: Changes to root crontab
* user_groups
  * /etc/group: Changes to groups file
* user_passwd
  * /etc/passwd: Changes to passwd file
* user_shadow
  * /etc/shadow: Changes to the shadow file 
* passwd_modification
  * /usr/bin/passwd: Changing of passwords
* group_modification
  * /usr/sbin/groupadd
  * /usr/sbin/groupmod
  * /usr/sbin/addgroup
* user_modification 
  * /usr/sbin/useradd
  * /usr/sbin/userdel
  * /usr/sbin/usermod
  * /usr/sbin/adduser
* rootkey
  * /root/.ssh: Changes to root ssh key
* systemd
  * /bin/systemctl: systemctl command 
  * /etc/systemd/: Systemd configurations (long lived)
  * /usr/lib/systemd
* pam
  * /etc/pam.d/
  * /etc/security/limits.conf
  * /etc/security/limits.d
  * /etc/security/pam_env.conf
  * /etc/security/namespace.conf
  * /etc/security/namespace.d
  * /etc/security/namespace.init
* priv_esc
  * /bin/su
  * /usr/bin/sudo: We do have a rule to catch euid=0 what about sudo -u \<user\>
* susp_activity
  * /usr/bin/wget
  * /usr/bin/curl
  * /usr/bin/base64 
  * /bin/nc
  * /bin/netcat
  * /usr/bin/ncat
  * /usr/bin/ss
  * /usr/bin/netstat
  * /usr/bin/ssh
  * /usr/bin/scp
  * /usr/bin/sftp
  * /usr/bin/ftp
  * /usr/bin/socat
  * /usr/bin/wireshark
  * /usr/bin/tshark
  * /usr/bin/rawshark
* T1219_Remote_Access_Tools
  * /usr/bin/rdesktop
  * /usr/local/bin/rdesktop
  * /usr/bin/wlfreerdp
  * /usr/bin/xfreerdp
  * /usr/local/bin/xfreerdp
  * /usr/bin/nmap
* sbin_susp
  * /sbin/iptables
  * /sbin/ip6tables
  * /sbin/ifconfig 
  * /usr/sbin/arptables
  * /usr/sbin/ebtables
  * /sbin/xtables-nft-multi
  * /usr/sbin/nft
  * /usr/sbin/tcpdump
  * /usr/sbin/traceroute
  * /usr/sbin/ufw 
* susp_shell
  * /bin/rbash
  * /bin/open
  * /usr/local/bin/xonsh
  * /bin/xonsh
  * /bin/tclsh
  * /bin/tcsh
  * /bin/fish
  * /bin/csh
  * /bin/ash
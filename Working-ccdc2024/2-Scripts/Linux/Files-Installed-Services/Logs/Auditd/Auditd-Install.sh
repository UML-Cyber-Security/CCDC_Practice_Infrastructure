#! /bin/bash

#********************************
# Written by a sad Matthew Harper...
#********************************

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# If there exists this file, it is a debian based system. Use APT
if [ -f "/etc/debian_version" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get -q install auditd audispd-plugins -y
elif [ -f "/etc/redhat-release" ]; then
    yum install audit audit-libs -y
elif [ -f "/etc/arch-release" ];then 
    echo "Arch, Will this come up -- probably should do fedora"
fi

systemctl --now enable auditd
touch /etc/audit/rules.d/ccdc.rules
chown root:root /etc/audit/rules.d/ccdc.rules

# Log modifications to date and time. (2611)
# 32-64 bit
#echo -e "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change \n-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change \n-a always,exit -F arch=b64 -S clock_settime -k time-change \n-a always,exit -F arch=b32 -S clock_settime -k time-change \n-w /etc/localtime -p wa -k time-change" >> /etc/audit/rules.d/ccdc.rules 
echo "[+] Create auditd rule to watch for modifications to date and time"
echo -e "-a always,exit -F arch=b64 -S adjtimex,settimeofday -k time-change \n-a always,exit -F arch=b32 -S adjtimex,settimeofday,stime -k time-change \n-a always,exit -F arch=b64 -S clock_settime -k time-change \n-a always,exit -F arch=b32 -S clock_settime -k time-change \n-w /etc/localtime -p wa -k time-change" >> /etc/audit/rules.d/ccdc.rules 

# Log modifications to host/domain name (2613)
#echo "-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale   -a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale       -w /etc/issue -p wa -k system-locale          -w /etc/issue.net -p wa -k system-locale           -w /etc/hosts -p wa -k system-locale         -w /etc/network -p wa -k system-locale" >> /etc/audit/rules.d/ccdc.rules 
#echo -e "-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale \n-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale \n-w /etc/issue -p wa -k system-locale \n-w /etc/issue.net -p wa -k system-locale \n-w /etc/hosts -p wa -k system-locale  \n-w /etc/network -p wa -k system-locale" >> /etc/audit/rules.d/ccdc.rules 
echo "[+] Create auditd rule to watch for modifications to host or domain names"
echo -e "-a always,exit -F arch=b64 -S sethostname,setdomainname -k system-locale \n-a always,exit -F arch=b32 -S sethostname,setdomainname -k system-locale \n-w /etc/issue -p wa -k system-locale \n-w /etc/issue.net -p wa -k system-locale \n-w /etc/hosts -p wa -k system-locale  \n-w /etc/network -p wa -k system-locale" >> /etc/audit/rules.d/ccdc.rules 

if [ "$(systemctl status apparmor | grep "active (running)" | wc -l)" -ne 0 ]; then 
    # Log modifications to AppArmor's Mandatory Acces Controls (2614)
    #echo "-w /etc/apparmor/ -p wa -k MAC-policy -w /etc/apparmor.d/ -p wa -k MAC-policy" >> /etc/audit/rules.d/ccdc.rules 
    echo "[+] Create auditd rule to watch for apparmor modifications"
    echo -e "-w /etc/apparmor/ -p wa -k MAC-policy \n-w /etc/apparmor.d/ -p wa -k MAC-policy" >> /etc/audit/rules.d/ccdc.rules 
fi
# Collect login/logout information (2615)
#echo "-w /var/log/faillog -p wa -k logins | -w /var/log/lastlog -p wa -k logins | -w /var/log/tallylog -p wa -k logins" >> /etc/audit/rules.d/ccdc.rules
echo "[+] Create auditd rule to monitor login and logout infomtaion"
echo -e "-w /var/log/faillog -p wa -k logins \n-w /var/log/lastlog -p wa -k logins \n-w /var/log/tallylog -p wa -k logins" >> /etc/audit/rules.d/ccdc.rules

# Collect session initiation info (2616) 
#echo "-w /var/run/utmp -p wa -k session | -w /var/log/wtmp -p wa -k logins | -w /var/log/btmp -p wa -k logins" >> /etc/audit/rules.d/ccdc.rules 
echo "[+] Create auditd rule to coleect session initalization information"
echo -e "-w /var/run/utmp -p wa -k session \n-w /var/log/wtmp -p wa -k logins \n-w /var/log/btmp -p wa -k logins" >> /etc/audit/rules.d/ccdc.rules 

# Collect file permision changes (2617)
#echo "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/ccdc.rules 
#echo -e "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod \n-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod \n-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod \n -a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod \n -a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod \n-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/ccdc.rules 
echo "[+] Create auditd rule to watch for file permission changes"
echo -e "-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod \n-a always,exit -F arch=b32 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod \n-a always,exit -F arch=b64 -S chown,fchown,fchownat,lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod \n-a always,exit -F arch=b32 -S chown,fchown,fchownat,lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod \n-a always,exit -F arch=b64 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod \n-a always,exit -F arch=b32 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/ccdc.rules 

# Collect unsuccessful unauthorized file access attempts (2618)
#echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access | -a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access | -a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access | -a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/ccdc.rules 
#echo -e "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access \n-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access \n-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access \n-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/ccdc.rules 
echo "[+] Create auditd rule to watch for unautorized access attempts"
echo -e "-a always,exit -F arch=b64 -S creat,open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access \n-a always,exit -F arch=b32 -S creat -S open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access \n-a always,exit -F arch=b64 -S creat -S open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access \n-a always,exit -F arch=b32 -S creat,open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/ccdc.rules 

# Collect successful File system mounts (2619)
#echo "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts | -a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" >> /etc/audit/rules.d/ccdc.rules 
echo "[+] Create auditd rule to watch for file system mounts"
echo -e "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts \n-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" >> /etc/audit/rules.d/ccdc.rules 

# Collect file deletion events (2620)
#echo "-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete | -a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" >> /etc/audit/rules.d/ccdc.rules 
#echo -e "-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete \n-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" >> /etc/audit/rules.d/ccdc.rules 
echo "[+] Create auditd rule to watch for file deletion events"
echo -e "-a always,exit -F arch=b64 -S unlink,unlinkat,rename,renameat -F auid>=1000 -F auid!=4294967295 -k delete \n-a always,exit -F arch=b32 -S unlink,unlinkat,rename,renameat -F auid>=1000 -F auid!=4294967295 -k delete" >> /etc/audit/rules.d/ccdc.rules 

# Collect modifications to sudoers (2621)
#echo "-w /etc/sudoers -p wa -k scope | -w /etc/sudoers.d/ -p wa -k scope" >> /etc/audit/rules.d/ccdc.rules 
echo "[+] Create auditd rule to watch for modifications to the sudoers file"
echo -e "-w /etc/sudoers -p wa -k scope \n-w /etc/sudoers.d/ -p wa -k scope" >> /etc/audit/rules.d/ccdc.rules 

############# 2622

# Sudo log (all euid=0 from uid > 1000 that are not an unset uid.
# https://sudoedit.com/log-sudo-with-auditd/
echo "[+] Create auditd rule to watch for all sudo operations"
echo -e "-a always,exit -F arch=b32 -S execve -F euid=0 -F auid>=1000 -F auid!=-1 -F key=sudo_log \n-a always,exit -F arch=b64 -S execve -F euid=0 -F auid>=1000 -F auid!=-1 -F key=sudo_log" >> /etc/audit/rules.d/ccdc.rules

# Collect kernel module loading/unloading (2623)
#echo "-w /sbin/insmod -p x -k modules | -w /sbin/rmmod -p x -k modules | -w /sbin/modprobe -p x -k modules | -a always,exit -F arch=b64 -S init_module -S delete_module -k modules" >> /etc/audit/rules.d/ccdc.rules
echo "[+] Create auditd rule to watch for kernel module loading/unloading"
echo -e "-w /sbin/insmod -p x -k modules \n-w /sbin/rmmod -p x -k modules \n-w /sbin/modprobe -p x -k modules \n-a always,exit -F arch=b64 -S init_module -S delete_module -k modules" >> /etc/audit/rules.d/ccdc.rules

# Cron Audit
echo "[+] Create auditd rule to watch for cron/at modification"
echo -e "-w /var/spool/atspool -k cron\n-w /etc/at.allow -k cron\n-w /etc/at.deny -k cron\n-w /etc/cron.allow -p wa -k cron\n-w /etc/cron.deny -p wa -k cron\n-w /etc/cron.d/ -p wa -k cron\n-w /etc/cron.daily/ -p wa -k cron\n-w /etc/cron.hourly/ -p wa -k cron\n-w /etc/cron.monthly/ -p wa -k cron\n-w /etc/cron.weekly/ -p wa -k cron\n-w /etc/crontab -p wa\n-w /var/spool/cron/root -k cron\n" >> /etc/audit/rules.d/ccdc.rules

# UserFies
echo "[+] Create auditd rule to watch for user modifications or creations (groups, passwd, shado, ect.)"
echo -e "-w /etc/group -p wa -k user_groups\n-w /etc/passwd -p wa -k user_passwd\n-w /etc/shadow -k user_shadow\n-w /etc/login.defs -p wa -k logins\n" >> /etc/audit/rules.d/ccdc.rules

# Passwd - Ident 
echo "[+] Create auditd rule to watch for uses of programs to modify users infomration"
echo -e "-w /usr/bin/passwd -p x -k passwd_modification\n-w /usr/sbin/groupadd -p x -k group_modification\n-w /usr/sbin/groupmod -p x -k group_modification\n-w /usr/sbin/addgroup -p x -k group_modification\n-w /usr/sbin/useradd -p x -k user_modification\n-w /usr/sbin/userdel -p x -k user_modification\n-w /usr/sbin/usermod -p x -k user_modification\n-w /usr/sbin/adduser -p x -k user_modification\n" >> /etc/audit/rules.d/ccdc.rules

# Login configuration and information
echo "[+] Create auditd rule to watch for additional login information"
echo -e "-w /etc/securetty -p wa -k logins\n" >> /etc/audit/rules.d/ccdc.rules

# root ssh key tampering
echo "[+] Create auditd rule to watch for root ssh key tampering"
echo -e "-w /root/.ssh -p wa -k rootkey\n" >> /etc/audit/rules.d/ccdc.rules 

# Systemd
echo "[+] Create auditd rule to watch for systemd and system ctl modification"
echo -e "-w /bin/systemctl -p x -k systemd\n-w /etc/systemd/ -p wa -k systemd\n-w /usr/lib/systemd -p wa -k systemd\n"  >> /etc/audit/rules.d/ccdc.rules

## SSH configuration
echo "[+] Create auditd rule to watch for SSH configuration changes"
echo -e "-w /etc/ssh/sshd_config -k sshd\n-w /etc/ssh/sshd_config.d -k sshd\n" >> /etc/audit/rules.d/ccdc.rules 

## Pam configuration
echo "[+] Create auditd rule to watch for PAM configuration changes"
echo -e "-w /etc/pam.d/ -p wa -k pam\n-w /etc/security/limits.conf -p wa  -k pam\n-w /etc/security/limits.d -p wa  -k pam\n-w /etc/security/pam_env.conf -p wa -k pam\n-w /etc/security/namespace.conf -p wa -k pam\n-w /etc/security/namespace.d -p wa -k pam\n-w /etc/security/namespace.init -p wa -k pam\n" >> /etc/audit/rules.d/ccdc.rules 

## User or Process ID change (switching accounts) applications
echo "[+] Create auditd rule to watch for PID or UID changes"
echo -e "-w /bin/su -p x -k priv_esc\n-w /usr/bin/sudo -p x -k priv_esc\n" >> /etc/audit/rules.d/ccdc.rules

## Suspicious activity
echo "[+] Create auditd rule to watch for suspicious activity"
echo -e "-w /usr/bin/wget -p x -k susp_activity\n-w /usr/bin/curl -p x -k susp_activity\n-w /usr/bin/base64 -p x -k susp_activity\n-w /bin/nc -p x -k susp_activity\n-w /bin/netcat -p x -k susp_activity\n-w /usr/bin/ncat -p x -k susp_activity\n-w /usr/bin/ss -p x -k susp_activity\n-w /usr/bin/netstat -p x -k susp_activity\n-w /usr/bin/ssh -p x -k susp_activity\n-w /usr/bin/scp -p x -k susp_activity\n-w /usr/bin/sftp -p x -k susp_activity\n-w /usr/bin/ftp -p x -k susp_activity\n-w /usr/bin/socat -p x -k susp_activity\n-w /usr/bin/wireshark -p x -k susp_activity\n-w /usr/bin/tshark -p x -k susp_activity\n-w /usr/bin/rawshark -p x -k susp_activity\n-w /usr/bin/rdesktop -p x -k T1219_Remote_Access_Tools\n-w /usr/local/bin/rdesktop -p x -k T1219_Remote_Access_Tools\n-w /usr/bin/wlfreerdp -p x -k susp_activity\n-w /usr/bin/xfreerdp -p x -k T1219_Remote_Access_Tools\n-w /usr/local/bin/xfreerdp -p x -k T1219_Remote_Access_Tools\n-w /usr/bin/nmap -p x -k susp_activity\n" >> /etc/audit/rules.d/ccdc.rules

## Sbin suspicious activity
echo "[+] Create auditd rule to watch for suspicious activity with system binaries"
echo -e "-w /sbin/iptables -p x -k sbin_susp\n-w /sbin/ip6tables -p x -k sbin_susp\n-w /sbin/ifconfig -p x -k sbin_susp\n-w /usr/sbin/arptables -p x -k sbin_susp\n-w /usr/sbin/ebtables -p x -k sbin_susp\n-w /sbin/xtables-nft-multi -p x -k sbin_susp\n-w /usr/sbin/nft -p x -k sbin_susp\n-w /usr/sbin/tcpdump -p x -k sbin_susp\n-w /usr/sbin/traceroute -p x -k sbin_susp\n-w /usr/sbin/ufw -p x -k sbin_susp\n" >> /etc/audit/rules.d/ccdc.rules

## Suspicious shells ash
echo "[+] Create auditd rule to watch for suspicious shells"
echo -e "-w /bin/ash -p x -k susp_shell\n-w /bin/csh -p x -k susp_shell\n-w /bin/fish -p x -k susp_shell\n-w /bin/tcsh -p x -k susp_shell\n-w /bin/tclsh -p x -k susp_shell\n-w /bin/xonsh -p x -k susp_shell\n-w /usr/local/bin/xonsh -p x -k susp_shell\n-w /bin/open -p x -k susp_shell\n-w /bin/rbash -p x -k susp_shell\n" >> /etc/audit/rules.d/ccdc.rules
# Make audit logs immutable. (2624) -- ensure that this works
#echo "[+] Create auditd rule to make rules imutable unless there is a system restart 
#echo "-e 2" >> /etc/audit/rules.d/99-finalize.rules 

echo "[!!] Restarting Auditd"

if [ -f "/etc/redhat-release" ]; then 
    service auditd restart
else
    systemctl restart auditd
fi


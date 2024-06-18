#! /bin/bash

# Make a copy of the bash history before we harden this.
history > ~/copied-bash-history

if [ $EUID -ne 0 ]; then
    echo "Please run me as a superuser!"
    exit 1
fi

groupadd sugroup
echo "auth required pam_wheel.so use_uid group=sugroup" >> /etc/pam.d/su
apt-get -q purge autofs #disable automounting
apt-get -q install sudo #make sure sudo is installed
aa-enforce /etc/apparmor.d/* #Set AppArmor
#modify ownership and rwx permisions for message of the day. 
chown root:root /etc/motd
chmod u-x,go-wx /etc/motd 

# Make sure that all of the permissions on password files are correct. 
chown root:root /etc/group
chown root:shadow /etc/gshadow
chown root:root /etc/passwd
chown root:shadow /etc/shadow
chown root:root /etc/passwd-
chown root:shadow /etc/gshadow-
chown root:root /etc/group-
chown root:shadow /etc/shadow-

chmod 644 /etc/group
chmod 644 /etc/passwd
chmod o-rwx,g-wx /etc/gshadow
chmod o-rwx,g-wx /etc/shadow
chmod 644 /etc/group-
chmod 644 /etc/passwd-
chmod o-rwx,g-wx /etc/gshadow-
chmod o-rwx,g-wx /etc/shadow-

systemctl --now disable rsync #rsync is considered insecure
systemctl --now disable nis # to quote wazuh "NIS is inherently an insecure system"

apt purge telnet #I'm not going to explain this
#the next three are probably not installed but covering bases. 
apt purge nis
apt purge talk
apt purge rsh-client 

# Sudo logging and other stuff.
echo 'Defaults use_pty' | sudo EDITOR="tee -a" visudo


#Firewall stuff!
echo "[+] Firewall Rules being cleared."
apt-get -q install ufw

# Create a backup of the firewall rules in case a service goes down.
cp /etc/ufw/user.rules /etc/ufw/user.rules.backup
ufw default deny incoming
ufw default deny outgoing
ufw default deny routed
ufw allow in 22/tcp 
ufw allow in 443/tcp
ufw allow out 53/udp
ufw allow out 80/tcp
ufw allow out 443/tcp
ufw allow out 1514/tcp
ufw enable
ufw status verbose

echo "[+] Firewall rules cleared and backup made."

#disable ICMP broadcast
touch /etc/sysctl.d/ccdc.conf
chown root:root /etc/sysctl.d/ccdc.conf
chmod 644 /etc/sysctl.d/ccdc.conf
echo "net.ipv4.conf.all.log_martians = 1" >> /etc/sysctl.d/ccdc.conf #Log suspicious packets
echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.d/ccdc.conf #Ignore ICMP Broadcasts
echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> /etc/sysctl.d/ccdc.conf #Ignore bogus ICMP responses
echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.d/ccdc.conf # Reverse path filtering
echo "net.ipv4.conf.default.rp_filter = 1" >> /etc/sysctl.d/ccdc.conf #Reverse path filtering
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.d/ccdc.conf #Enable syn cookies 
echo "kernel.randomize_va_space = 2" >> /etc/sysctl.d/ccdc.conf #Enable ASLR

sysctl -w net.ipv4.route.flush=1
sysctl -w kernel.randomize_va_space=2



echo "[!] Do you want to set up auditd? (1 for yes, 0 for no) "
read AUD
if [ $AUD -ne 0 ]; then
    apt-get -q install auditd audispd-plugins
    systemctl --now enable auditd
    touch /etc/audit/rules.d/ccdc.rules
    chown root:root /etc/audit/rules.d/ccdc.rules

    echo "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change | -a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change | -a always,exit -F arch=b64 -S clock_settime -k time-change -a always,exit -F arch=b32 -S clock_settime -k time-change | -w /etc/localtime -p wa -k time-change" >> /etc/audit/rules.d/ccdc.rules # Log modifications to date and time. (2611)

    echo "-w /etc/group -p wa -k identity | -w /etc/passwd -p wa -k identity | -w /etc/gshadow -p wa -k identity | -w /etc/shadow -p wa -k identity | -w /etc/security/opasswd -p wa -k" >> /etc/audit/rules.d/ccdc.rules #Log group modifications (2612)

    echo "-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale   -a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale       -w /etc/issue -p wa -k system-locale          -w /etc/issue.net -p wa -k system-locale           -w /etc/hosts -p wa -k system-locale         -w /etc/network -p wa -k system-locale" >> /etc/audit/rules.d/ccdc.rules #log modifications to host/domain name (2613)

    echo "-w /etc/apparmor/ -p wa -k MAC-policy | -w /etc/apparmor.d/ -p wa -k MAC-policy" >> /etc/audit/rules.d/ccdc.rules # log modifications to AppArmor's Mandatory Acces Controls (2614)
    
    echo "-w /var/log/faillog -p wa -k logins | -w /var/log/lastlog -p wa -k logins | -w /var/log/tallylog -p wa -k logins" >> /etc/audit/rules.d/ccdc.rules #Collect login/logout information (2615)

    echo "-w /var/run/utmp -p wa -k session | -w /var/log/wtmp -p wa -k logins | -w /var/log/btmp -p wa -k logins" >> /etc/audit/rules.d/ccdc.rules # Collect session initiation info (2616)

    echo "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod | -a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/ccdc.rules #collect file permision changes (2617)

    echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access | -a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access | -a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access | -a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/ccdc.rules #Collect unsuccessful unauthorized file access attempts (2618)

    echo "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts | -a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" >> /etc/audit/rules.d/ccdc.rules #Collect successful File system mounts (2619)

    echo "-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete | -a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" >> /etc/audit/rules.d/ccdc.rules #Collect file deletion events (2620)

    echo "-w /etc/sudoers -p wa -k scope | -w /etc/sudoers.d/ -p wa -k scope" >> /etc/audit/rules.d/ccdc.rules #Collect modifications to sudoers (2621)

# 2622 goes here. Need to figure out what's up with sudo logging

    echo "-w /sbin/insmod -p x -k modules | -w /sbin/rmmod -p x -k modules | -w /sbin/modprobe -p x -k modules | -a always,exit -F arch=b64 -S init_module -S delete_module -k modules" >> /etc/audit/rules.d/ccdc.rules # Collect kernel module loading/unloading (2623)

    echo "-e 2" >> /etc/audit/rules.d/99-finalize.rules # Make audit logs immutable. (2624)
fi

echo "[!] Set up rsyslog? (1/0 for y/n) "
read RSYS
if [ $RSYS -ne 0 ]; then
    apt-get -q install rsyslog
    systemctl --now enable rsyslog
    sed -i '/FileCreateMode/c\$FileCreateMode 0640' /etc/rsyslog.conf
    sed -i '/FileCreateMode/c\$FileCreateMode 0640' /etc/rsyslog.d/*.conf
fi

# Cron stuff.
systemctl --now enable cron

chown root:root /etc/crontab
chown root:root /etc/cron.hourly
chown root:root /etc/cron.daily
chown root:root /etc/cron.weekly
chown root:root /etc/cron.monthly


chmod og-rwx /etc/crontab
chmod og-rwx /etc/cron.hourly
chmod og-rwx /etc/cron.daily
chmod og-rwx /etc/cron.weekly
chmod og-rwx /etc/cron.monthly

echo "[!] Switch to allow list for cron? (1/0 for y/n) "
echo "It is more secure but there may be additional modifications required"
read CRONALLOW
if [ $CRONALLOW -ne 0 ]; then
    rm /etc/at.deny
    rm /etc/cron.deny
    touch /etc/cron.allow
    touch /etc/at.allow
    chmod og-rwx /etc/cron.allow
    chmod og-rwx /etc/at.allow
    chown root:root /etc/cron.allow
    chown root:root /etc/at.allow
fi

apt-get -q update #download list of packages to update.
apt-get -q upgrade #install updated packages 

#Might have time to fix this up in time for deadline, but just in case

echo "[!] Will this machine be acting as an LDAP client? (1 for yes, 0 for no) "
read LDAP
if [ $LDAP -eq 0 ]; then
    apt purge ldap-utils
fi


echo "----------------- FINAL CONSIDERATIONS -----------------"
echo "You should manually check /etc/shadow and make sure that everyone has a password"
echo "You should check /etc/group and make sure that the shadow group is empty"
echo "You should check /etc/passwd and make sure that root is the only user with UID 0"
echo "Please make sure you modify the firewall rules to reenable your services"
echo "Please make sure you modify the firewall rules to reenable your services"
echo "Please make sure you modify the firewall rules to reenable your services"
echo "Please make sure you modify the firewall rules to reenable your services"
echo "Please make sure you modify the firewall rules to reenable your services"
echo "Please make sure you modify the firewall rules to reenable your services"
echo "Did you read the above messages?"
echo "Once these are done, you should restart this machine"

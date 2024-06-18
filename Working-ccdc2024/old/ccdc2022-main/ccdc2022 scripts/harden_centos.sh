#! /bin/bash

if [ $EUID -ne 0 ]; then
    echo "Please run me as a superuser!"
    exit 1
fi
yum erase autofs #disable automounting
yum install sudo #make sure sudo is installed
aa-enforce /etc/apparmor.d/* #Set AppArmor
#modify ownership and rwx permisions for message of the day. 
chown root:root /etc/motd
chmod u-x,go-wx /etc/motd 

chown root:root /etc/group
chmod 644 /etc/group
chown root:root /etc/passwd
chmod 644 /etc/passwd
chown root:shadow /etc/gshadow
chmod o-rwx,g-wx /etc/gshadow
chown root:shadow /etc/shadow
chmod o-rwx,g-wx /etc/shadow
chown root:root /etc/group-
chmod 644 /etc/group-
chown root:root /etc/passwd-
chmod 644 /etc/passwd-
chown root:shadow /etc/gshadow-
chmod o-rwx,g-wx /etc/gshadow-
chown root:shadow /etc/shadow-
chmod o-rwx,g-wx /etc/shadow-

systemctl --now disable rsync #rsync is considered insecure
systemctl --now disable nis # to quote wazuh "NIS is inherently an insecure system"

yum remove telnet #I'm not going to explain this
#the next three are probably not installed but covering bases. 
yum remove nis
yum remove talk
yum remove rsh-client 



#Firewall stuff!

yum install ufw


cp /etc/ufw/user.rules /etc/ufw/user.rules.backup
ufw default deny incoming
ufw default deny outgoing
ufw default deny 
ufw allow in 22/tcp 
ufw allow in 443/tcp
ufw allow out 53/udp
ufw allow out 80/tcp
ufw allow out 443/tcp
ufw enable
ufw status verbose


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

sysctl -w net.ipv4.route.flush=1




echo "Do you want to set up auditd? (1 for yes, 0 for no) "
read AUD
if [ $AUD -ne 0 ]; then
    yum install auditd audispd-plugins
    systemctl --now enable auditd
    touch /etc/audit/rules.d/ccdc.rules

    echo "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change | -a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change | -a always,exit -F arch=b64 -S clock_settime -k time-change -a always,exit -F arch=b32 -S clock_settime -k time-change | -w /etc/localtime -p wa -k time-change" >> /etc/audit/rules.d/ccdc.rules # Log modifications to date and time.

    echo "-w /etc/group -p wa -k identity | -w /etc/passwd -p wa -k identity | -w /etc/gshadow -p wa -k identity | -w /etc/shadow -p wa -k identity | -w /etc/security/opasswd -p wa -k" >> /etc/audit/rules.d/ccdc.rules #Log group modifications

    echo "-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale   -a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale       -w /etc/issue -p wa -k system-locale          -w /etc/issue.net -p wa -k system-locale           -w /etc/hosts -p wa -k system-locale         -w /etc/network -p wa -k system-locale" >> /etc/audit/rules.d/ccdc.rules #log modifications to host/domain name

    echo "-w /etc/apparmor/ -p wa -k MAC-policy | -w /etc/apparmor.d/ -p wa -k MAC-policy" >> /etc/audit/audit.rules # log modifications to AppArmor's Mandatory Acces Controls
    
    echo "-w /var/log/faillog -p wa -k logins | -w /var/log/lastlog -p wa -k logins | -w /var/log/tallylog -p wa -k logins" >> /etc/audit/rules.d/ccdc.rules #Collect login/logout information


    echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access | -a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access | -a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access | -a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/ccdc.rules #Collect unsuccessful unauthorized file access attempts

    echo "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts | -a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" >> /etc/audit/rules.d/ccdc.rules #Collect successful File system mounts

    echo "-w /etc/sudoers -p wa -k scope | -w /etc/sudoers.d/ -p wa -k scope" >> /etc/audit/audit.rules #Collect modifications to sudoers

    echo "-w /sbin/insmod -p x -k modules | -w /sbin/rmmod -p x -k modules | -w /sbin/modprobe -p x -k modules | -a always,exit -F arch=b64 -S init_module -S delete_module -k modules" >> /etc/audit/rules.d/ccdc.rules # Collect kernel module loading/unloading

    echo "-e 2" >> /etc/audit/rules.d/99-finalize.rules # Make audit logs immutable.
fi

echo "Set up rsyslog? (1/0 for y/n) "
read RSYS
if [ $RSYS -ne 0 ]; then
    yum install rsyslog
    systemctl --now enable rsyslog
    sed -n '/FileCreateMode/c$FileCreateMode 0640' /etc/rsyslog.conf
    sed -n '/FileCreateMode/c$FileCreateMode 0640' /etc/rsyslog.d/*.conf
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

echo "Switch to allow list for cron? (1/0 for y/n) "
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

yum update #download list of packages to update.
yum upgrade #install updated packages 

#Might have time to fix this up in time for deadline, but just in case

echo "Will this machine be acting as an LDAP client? (1 for yes, 0 for no) "
read LDAP
if [ $LDAP -eq 0 ]; then
    yum remove ldap-utils
fi


echo "You should manually check /etc/shadow and make sure that everyone has a password"
echo "You should check /etc/group and make sure that the shadow group is empty"
echo "You should check /etc/passwd and make sure that root is the only user with UID 0"
echo "Please make sure you modify the firewall rules to reenable your services"

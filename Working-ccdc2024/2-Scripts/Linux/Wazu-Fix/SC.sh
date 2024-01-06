#! /bin/bash

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
##############------------ Move commands to respective sections!


###############################################################

# auto mount -- Will this mess with docker or anything?
# Run one of the following commands:  Run the following command to disable autofs: # systemctl --now disable autofs    OR  Run the following command to remove autofs:  # apt purge autofs
systemctl --now disable autofs # Already handeled 

# Undo Prelinks
prelink -ua Uninstall prelink
# Remove Prelink -- System Specific?
apt purge prelink -y

####################################################
# Resttict core dumps 
if [ "$(grep 'End of file' /etc/security/limits.conf | wc -l)" -ne 0]; then
  sed -i 's/\(.* End of file\)/* hard core 0\n\1/g' /etc/security/limits.conf
else 
  echo "hard core 0\n# End of file" >> /etc/security/limits.conf
fi
echo "fs.suid_dumpable = 0" >> /etc/sysctl.d/ccdc.conf 
# Apply sysctl config ((This is in the file))

###################################################

# Time Synchronization 
#apt install chrony # -- UBUNTU 
# Add Server line to  /etc/chrony/chrony.conf
	#   server 0.us.pool.ntp.org
	#   server 1.us.pool.ntp.org
	#   server 2.us.pool.ntp.org
	#   server 3.us.pool.ntp.org
#systemctl --now mask systemd-timesyncd


# Remove XServer--Ubuntu
apt purge xserver-xorg*

# avahi automated network device discovery
# Stop disable
systemctl --now disable avahi-daemon
systemctl stop avahi-daemon.socket
# Remove --Ubuntu
apt purge avahi-daemon

# CUPS, no printers--Ubuntu
apt purge cups

# isc-dhcp-server -- Remove DHCP Serve capablilities --Ubuntu
apt purge isc-dhcp-server

# LDAP server removal --Ubuntu
apt purge slapd

# Remove Network File Server --Ubuntu
apt purge nfs-kernel-server

# Remove DNS -- Some
apt purge bind9

# Remove FTPserver -- All probably
apt purge vsftpd

# Remove apache server
apt purge apache2

# Dotcove --Ubuntu IMAP POP3 (mail access servers) --Some 
apt purge dovecot-imapd dovecot-pop3d

# Remove Samba server
apt purge samba

# Remove squid proxy server 
apt purge squid

# Remove simple network management server 
apt purge snmpd

# Remove RPC client
apt purge rpcbind

############## Disable IPv6
#Edit /etc/default/grub and add ipv6.disable=1 to the GRUB_CMDLINE_LINUX parameters: GRUB_CMDLINE_LINUX="ipv6.disable=1" Run the following command to update the grub2 configuration: # update-grub
if [ "$(grep 'GRUB_CMDLINE_LINUX=.*' | wc -l)" -ne 0 ]; then
  sed "s/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX=\"ipv6.disable=1\"/g"  /etc/default/grub
else
  echo "GRUB_CMDLINE_LINUX=\"ipv6.disable=1\"" >> /etc/default/grub
fi
update-grub

#Edit /etc/exim4/update-exim4.conf and and or modify following lines to look like the lines below: dc_eximconfig_configtype='local' dc_local_interfaces='127.0.0.1 ; ::1' dc_readhost='' dc_relay_domains='' dc_minimaldns='false' dc_relay_nets='' dc_smarthost='' dc_use_split_config='false' dc_hide_mailname='' dc_mailname_in_oh='true' dc_localdelivery='mail_spool' Restart exim4: # systemctl restart exim4


# Disable wireless interfaces 
# nmcli radio all off # Not needed?



# Set log level to verbose --already done
if [ "$(grep 'LogLevel' /etc/ssh/sshd_config | wc -l)" -ne 0 ]; then
  sed -i 's/.*\(LogLevel\).*/\1 VERBOSE/g' /etc/ssh/sshd_config
else
  echo "LogLevel=VERBOSE" >> /etc/ssh/sshd_config
fi
# Banner to Display
if [ "$(grep 'Banner' /etc/ssh/sshd_config | wc -l)" -ne 0 ]; then
  sed "s|.*Banner.*|Banner /etc/issue.net|g" /etc/ssh/sshd_config
else 
  echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
fi

# Root Group
usermod -g 0 root

################################# Auditd 
# Reloading the auditd config to set active settings may require a system reboot.
# Record events affecting the group , passwd (user IDs), shadow and gshadow (passwords) or /etc/security/opasswd
# The parameters in this section will watch the files to see if they have been opened for write or have had attribute
# changes (e.g. permissions) and tag them with the identifier "identity" in the audit log file.
echo " -w /etc/group -p wa -k identity | -w /etc/passwd -p wa -k identity | -w /etc/gshadow -p wa -k identity | -w /etc/shadow -p wa -k identity | -w /etc/security/opasswd -p wa -k identity" >> /etc/audit/rules.d/ccdc.rules

# Record changes to network environment files or system calls. Sethostname or setdomainnam system calls-- Already Done
#echo "-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale -w /etc/issue -p wa -k system-locale -w /etc/issue.net -p wa -k system-locale -w /etc/hosts -p wa -k system-locale -w /etc/network -p wa -k system-locale | -a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale -a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale -w /etc/issue -p wa -k system-locale -w /etc/issue.net -p wa -k system-locale -w /etc/hosts -p wa -k system-locale -w /etc/network -p wa -k system-locale." >> /etc/audit/rules.d/ccdc.rules

# Sudo log (all euid=0 from uid > 1000 that are not an unset uid.
# https://sudoedit.com/log-sudo-with-auditd/
echo "-a always,exit -F arch=b32 -S execve -F euid=0 -F auid>=1000 -F auid!=-1 -F key=sudo_log \n-a always,exit -F arch=b64 -S execve -F euid=0 -F auid>=1000 -F auid!=-1 -F key=sudo_log" >> /etc/audit/rules.d/ccdc.rules


# Change Lof file perms
# For all files and directories in /var/log execute chmod --- on what was found
#find /var/log -type f -exec chmod g-wx,o-rwx "{}" + -o -type d -exec chmod g-w,o-rwx "{}" +


#If any accounts in the /etc/shadow file do not have a password, run the following command to lock the account until it can be determined why it does not have a password: # passwd -l <em><username></em>. Also, check to see if the account is logged in and investigate what it is being used for to determine if it needs to be forced off.



# Single User Mode --> Look this up why did I do this, is it useful?
sed -i "s|ExecStart.*|ExecStart=-/bin/sh -c '/sbin/sulogin; /usr/bin/systemctl --fail --no-block default'|g" /usr/lib/systemd/system/rescue.service
sed -i "s|ExecStart.*|ExecStart=-/bin/sh -c '/sbin/sulogin; /usr/bin/systemctl --fail --no-block default'|g" /usr/lib/systemd/system/emergency.service
#<< They just want us to set a password on the root account...>>



#Run the following command to restore binaries to normal: # prelink -ua Uninstall prelink using the appropriate package manager or manual installation: # apt purge prelink	prelink is a program that modifies ELF shared libraries and ELF dynamically linked binaries in such a way that the time needed for the dynamic linker to perform relocations at startup significantly decreases.




# Security Update 
apt -s upgrade

# Time Synchronization NTP Install ntp or chrony
if [ "$(systemctl is-enabled systemd-timesyncd)" != "disabled" ]; then
    apt install chrony # Need to configure files and everything
    timedatectl set-ntp on
fi



#Ensure shadow group is empty.	 sh -c "awk -F: -v GID=\"$(awk -F: '($1==\"shadow\") {print $3}' /etc/group)\" '($4==GID) {print $1}' /etc/passwd"





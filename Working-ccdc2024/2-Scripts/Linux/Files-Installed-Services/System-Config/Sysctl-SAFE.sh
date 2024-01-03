#! /bin/bash

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Create a new Conf file, sysctl will read and parse any file ending in .conf
touch /etc/sysctl.d/ccdc.conf
# Change ownership (and group) to root
chown root:root /etc/sysctl.d/ccdc.conf
# Change permissons to read/write-U read-G,E
chmod 644 /etc/sysctl.d/ccdc.conf

# Log suspicious packets
echo "net.ipv4.conf.all.log_martians = 1" >> /etc/sysctl.d/ccdc.conf 
# Ignore ICMP Broadcasts --> Firewall could block this
echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.d/ccdc.conf 
# Ignore bogus ICMP responses
echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> /etc/sysctl.d/ccdc.conf 
# Reverse path filtering: Enable Source validation by reversed path
echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.d/ccdc.conf 
# Reverse path filtering: Controls source route verification
echo "net.ipv4.conf.default.rp_filter = 1" >> /etc/sysctl.d/ccdc.conf 
# Enable syn cookies: Prevents Syn Flooding Attacks 
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.d/ccdc.conf 
# Enable ASLR : mmap base, heap, stack and VDSO page are randomized
echo "kernel.randomize_va_space = 2" >> /etc/sysctl.d/ccdc.conf 


###### NEW
# Enable Reboot after Kernel Panic (Crash due to intenal Kernel Errors)
echo "kernel.panic=10" >> /etc/sysctl.d/ccdc.conf 
# Protect against possible symlink attacks 
echo "fs.protected_hardlinks=1" >> /etc/sysctl.d/ccdc.conf  
echo "fs.protected_symlinks=1" >> /etc/sysctl.d/ccdc.conf 

# load the configurations we wrote --> This was not in the previous scrip?
sysctl -p /etc/sysctl.d/ccdc.conf

# Flush the routing table
sysctl -w net.ipv4.route.flush=1

# Disable and Stop rsync it is considered insecure
systemctl --now disable rsync 
# Disable and Stop nis (If it is there) --> Not needed with purge?
systemctl --now disable nis 


# Enforce Defualt Apparmor Configuration --> will we use SELinux insted?
aa-enforce /etc/apparmor.d/* 

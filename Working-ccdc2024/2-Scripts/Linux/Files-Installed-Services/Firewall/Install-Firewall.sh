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
echo "[+] Installing IPTables"

if [ -f "/etc/debian_version" ]; 
    then 
        export DEBIAN_FRONTEND=noninteractive
        # Install IPTables if it is not already installed
        apt-get -q install iptables -y
        # Set preferences for iptables-persistance 
        echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
        echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
        # Download and install iptables-persistent
        apt-get -q install iptables-persistent -y 
    else yum install iptables-services -y
fi

echo "[!!] Disabiling Firewalld"
if [ "$(systemctl status firewalld | grep 'active' | wc -l)" -ne 0 ]; then
    # Disable 
    systemctl disable firewalld
    # Stop
    systemctl stop firewalld
    # Prevent Startup 
    systemctl mask firewalld
fi
echo "[!!] Starting IPTables"
systemctl start iptables && systemctl start ip6tables
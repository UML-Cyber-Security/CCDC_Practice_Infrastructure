#! /bin/bash

#**************************
# Written by a sad Matthew Harper
#**************************

#+++++++++++++++++++++++++++++++++++++++
# This is a script that is meant to
# Run all of the hardining scripts 
# So that we do not have to change dirs 
#+++++++++++++++++++++++++++++++++++++++


# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


# get os from /etc/os-release to touch the /etc/release file (Make it lowercase
OS_TYPE=$(grep 'ID_LIKE=.*' /etc/os-release | awk -F '=' -e '{print $2}' | tr '[:upper:]' '[:lower:]')

# make sure /etc/___-release file exists 
if [ $OS_TYPE = 'debian' ]
then
    touch /etc/debian_version
elif [[ $OS_TYPE = 'redhat' || $OS_TYPE = 'fedora' ]]
    touch /etc/redhat-release
fi

# Run the backup Script
#./Backup/Intial-Backup.sh
 find . -iname 'Intial-Backup.sh' -exec {} \;

# Run basic install and remove scripts
#./Files-Installed-Services/Install-Remove/Install-Remove-Service.sh
find . -iname 'Install-Remove-Service.sh' -exec {} \;

# Run the PAM Script
#./Password/PAM.sh
find . -iname 'PAM.sh' -exec {} \;

# Run a script to set ownership, permissions and enable
# the at and cron allow lists
#./Files-Installed-Services/Cron/cron-allow.sh
find . -iname 'cron-allow.sh' -exec {} \;

# Run file permisson scripts
#./Files-Installed-Services/Files-Perm-Integrity.sh
find . -iname 'Files-Perm-Integrity.sh' -exec {} \;

# Run SSH Setup Script
#./Files-Installed-Services/SSH-Setup.sh
find . -iname 'SSH-Setup.sh' -exec {} \;

# Run the Sudo Configuration Script 
#./Files-Installed-Services/Sudo-Config.sh
find . -iname 'Sudo-Config.sh' -exec {} \;

# Install and configure Auditd
#./Files-Installed-Services/Logs/Auditd/Auditd-Install.sh
find . -iname 'Auditd-Install.sh' -exec {} \;

# Install and basic configuration of rsyslog
#./Files-Installed-Services/Logs/rsyslog/rsys.sh
find . -iname 'rsys.sh' -exec {} \;

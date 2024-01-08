#! /bin/bash

#********************************
# Edited/Written by a sad Matthew Harper...
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
    apt-get install rsyslog -y
elif [ -f "/etc/redhat-release" ]; then
    yum install rsyslog -y
elif [ -f "/etc/arch-release" ]; then
    echo "Arch, Will this come up -- probably should do fedora"
fi
# Enable rsyslog
systemctl --now enable rsyslog
# Some settings -- Note
if [ "$(grep "FileCreateMode" /etc/rsyslog.conf | wc -l)" -ne 0 ]; then 
    sed -i '/FileCreateMode/c\$FileCreateMode 0640' /etc/rsyslog.conf
else 
    echo "\$FileCreateMode 0640"
fi
#
if [ "$(grep "FileCreateMode"  /etc/rsyslog.d/*.conf | wc -l)" -ne 0 ]; then 
    sed -i '/FileCreateMode/c\$FileCreateMode 0640' /etc/rsyslog.d/*.conf
else 
    echo "\$FileCreateMode 0640"
fi
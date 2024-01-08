#! /bin/bash

#********************************
# Written by a somone
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
    apt-get purge ldap-utils -y
elif [ -f "/etc/redhat-release" ]; then
    yum remove ldap-utils -y
elif [ -f "/etc/arch-release" ]; then
    echo "Arch, Will this come up -- probably should do fedora"
fi

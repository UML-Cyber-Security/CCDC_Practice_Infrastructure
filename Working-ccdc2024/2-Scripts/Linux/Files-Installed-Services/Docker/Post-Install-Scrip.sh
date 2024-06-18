#! /bin/bash

#********************************
# Written by a sad Matthew Harper...
#********************************

#+++++++++++++++
# This scrip takes one argument
# It creates the docker group if
# It is not already created
# The script adds the user 
# specified to the docker group
#+++++++++++++++

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Create Docker Group
echo "[+] Creating docker group" 
if [ "$(grep -q -E "^docker:" /etc/group | wc -l)" -eq 0 ]; then
    groupadd docker
fi

# Add the user to the group
echo "[+] Adding user $SUDO_USER to the group"
usermod -aG docker $SUDO_USER

# Reload the docker group. Applies canges
echo "[!!] Updating groups of $SUDO_USER"
sudo -H -u $SUDO_USER bash -c 'newgrp docker'
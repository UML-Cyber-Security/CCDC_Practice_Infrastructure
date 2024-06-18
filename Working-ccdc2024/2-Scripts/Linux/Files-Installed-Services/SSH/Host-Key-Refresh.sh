#! /bin/bash

#**************************
# Written by a sad Matthew Harper
#**************************


# This is meant to be a script that refreshes the host keys of the system
# Remove Host keys 
echo "[!!] Removing Host Keys"
rm -f /etc/ssh/ssh_host*
# Remake host keys
echo "[!!] Regenerating Host Keys"
ssh-keygen -A

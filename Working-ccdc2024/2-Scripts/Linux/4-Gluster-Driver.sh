#! /bin/bash

#**************************
# Written by a sad Matthew Harper
#**************************

#+++++++++++++++++++++++++++++++++++
# This is a script to drive the gluster scripts
# This will install gluster
# This will configure gluster
# This will set up the firewall to allow for gluster
#+++++++++++++++++++++++++++++++++++


# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# This script will set up a basic gluster instance 
# Install 
# Configure 
# Firewall

# Install Gluster
find . -iname 'Gluster-Install.sh' -exec {} \;

# Configure Gluster
# find . -iname 'XXXXXXXXXXXXXXX' -exec {} \;

# Set up gluster firewall (Limits the number of bricks)
#find . -iname 'Gluster-Firewall.sh' -exec {} \;
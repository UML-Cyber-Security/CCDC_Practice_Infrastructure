#! /bin/bash

#**************************
# Written by a sad Matthew Harper
#**************************

#++++++++++++++++++++++++++++++++++
# This script will install and set up docker
# I plan to have it fix basic misconfigurations
# This should alos announce when those misconfigurations
# Are Found.
# This script will also set up the iptables firewall for
# Docker.
#++++++++++++++++++++++++++++++++++


# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


# This script will run the scripts for docker 
# Configure 
# Set up firewall 

# Install Docker
find . -iname 'Docker-Install.sh' -exec {} \;

# Fix misconfigurations 
# find . -iname 'XXXXXXXXXXXX' -exec {} \;

# Set up docker group 
find -iname 'Post-Install-Script.sh' -exec {} \;

# Set up the firewall 
find -iname 'Firewall-Docker.sh' -exec {} \;
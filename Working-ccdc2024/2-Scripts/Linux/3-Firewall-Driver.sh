#! /bin/bash

#**************************
# Written by a sad Matthew Harper
#**************************

#+++++++++++++++++++++++++++++++++
# This is a script to run other scripts
# It will install IPTables and iptables presistance
# It will set up the basic configuration of IPTables
# It will save the new sonfiguration
#+++++++++++++++++++++++++++++++++



# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# This installs IPTablrs
find . -iname 'Install-Firewall.sh' -exec {} \;

# Configure IPTables
find . -iname 'Firewall-IPTables.sh' -exec {} \;







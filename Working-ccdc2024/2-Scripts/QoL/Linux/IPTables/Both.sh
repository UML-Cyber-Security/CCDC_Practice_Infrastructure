#! /bin/bash

#********************************
# Written by a sad Matthew Harper...
#********************************

#+++++++++++++++++++++
# This takes one argument 
# The IPTables Rule (as a string)
# This will create the rule for both IPv4 and IPV6 tables
#+++++++++++++++++++++

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if (( $# == 0 )); then 
    echo "Bad argc"
fi

iptables $1
ip6tables $1
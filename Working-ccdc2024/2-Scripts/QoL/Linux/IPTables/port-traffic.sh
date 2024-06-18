#! /bin/bash

#********************************
# Written by a sad Matthew Harper...
#********************************

#+++++++++++++++
# Takes three arguments
# First is the Port number
# The second is the protocol 
# The Third is the Target
#+++++++++++++++

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


re='^[0-9]+$'
if (( $# == 0 )) | [[ "$(cat $yournumber | grep $re | wc -l)" -ne 0 ]] ; then
   echo "Bad Argument" >&2; 
   exit 1
fi

iptables -A INPUT -p $2 --dport $1 -j $3
iptables -A OUTPUT -p $2 --sport $1  -j $3

ip6tables -A INPUT -p $2 --dport $1 -j $3
ip6tables -A OUTPUT -p $2 --sport $1  -j $3

# Ref
# https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash
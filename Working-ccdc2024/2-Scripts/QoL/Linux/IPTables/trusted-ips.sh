#! /bin/bash

#********************************
# Written by a sad Matthew Harper...
#********************************

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# This takes one argument 
# A file that contains a newline seperated list of IPs
# This will create a  rule for both IPv4 and IPV6 tables
# That allows traffic inbound from each IP and outbound 
# To each IP 
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Ensure there is atleast one arguemnt and the file exists
if (( $# == 0 )) || ! [ -f $1 ]; then 
    echo "Bad argc(s)"
    exit
fi

# Read in file of IPs as an array
readarray -t IPLIST < $1

for ip in IPLIST
do
# Add Accept for inbound (IPv4 and IPv6)
iptables -A INPUT -s $ip -j ACCEPT
ip6tables -A INPUT -s $ip -j ACCEPT

# Add Accept for outbound responces (IPv4 and IPv6)
iptables -A OUTPUT -d $ip -j ACCEPT
ip6tables -A OUTPUT -d $ip -j ACCEPT
done
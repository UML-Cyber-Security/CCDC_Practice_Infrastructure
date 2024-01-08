#! /bin/bash

#********************************
# Written by a sad Matthew Harper...
#********************************

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

## IPv4 -- Remove Islate Chain Rule from head of table
iptables -D INPUT 1
iptables -D FORWARD 1
iptables -D OUTPUT 1
## IPv6
ip6tables -D INPUT 1
ip6tables -D FORWARD 1
ip6tables -D OUTPUT 1

## IPv4 -- Flush Isolate Chains
iptables -F ISOLATE-IN
iptables -F ISOLATE-OUT
## IPv6
ip6tables -F ISOLATE-IN
ip6tables -F ISOLATE-OUT

## IPv4 -- Remove Isolate chains
iptables -X ISOLATE-IN
iptables -X ISOLATE-Out
## IPv6
ip6tables -X ISOLATE-IN
ip6tables -X ISOLATE-Out
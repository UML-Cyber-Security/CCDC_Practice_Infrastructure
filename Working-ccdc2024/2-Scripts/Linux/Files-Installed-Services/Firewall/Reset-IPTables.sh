#! /bin/bash
# Resets IPTables. Undoes work done by the Firewall-IPTables script

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
# Policies 
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

ip6tables -P INPUT ACCEPT
ip6tables -P OUTPUT ACCEPT
ip6tables -P FORWARD ACCEPT

# Flush 
## IPv4
iptables -F INPUT
iptables -F OUTPUT
iptables -F DOCKER-USER
iptables -t mangle -F PREROUTING

iptables -F DOCKER-LOG
iptables -F SSH-INITIAL-LOG
iptables -F ICMP-FLOOD
iptables -F GLUSTER-IN
iptables -F GLUSTER-OUT
iptables -t mangle -F INVALID-LOG

## IPv6 
ip6tables -F INPUT
ip6tables -F OUTPUT
# ip6tables -F DOCKER-USER
ip6tables -t mangle -F PREROUTING

ip6tables -F DOCKER-LOG
ip6tables -F SSH-INITIAL-LOG
ip6tables -F ICMP-FLOOD
ip6tables -F GLUSTER-IN
ip6tables -F GLUSTER-OUT
ip6tables -t mangle -F INVALID-LOG

# Remove User Chains 
## IPv4
iptables -X DOCKER-LOG
iptables -X SSH-INITIAL-LOG
iptables -X ICMP-FLOOD
iptables -X GLUSTER-IN
iptables -X GLUSTER-OUT
iptables -t mangle -X INVALID-LOG

## IPv6
ip6tables -X DOCKER-LOG
ip6tables -X SSH-INITIAL-LOG
ip6tables -X ICMP-FLOOD
ip6tables -X GLUSTER-IN
ip6tables -X GLUSTER-OUT
ip6tables -t mangle -X INVALID-LOG
 

echo "Removing Firewall Rules"
if [ -f "/etc/debian_version" ]; 
    then
      iptables-save > /etc/iptables/rules.v4
      ip6tables-save > /etc/iptables/rules.v6
    else
      iptables-save > /etc/sysconfig/iptables
      ip6tables-save > /etc/sysconfig/iptables
fi 

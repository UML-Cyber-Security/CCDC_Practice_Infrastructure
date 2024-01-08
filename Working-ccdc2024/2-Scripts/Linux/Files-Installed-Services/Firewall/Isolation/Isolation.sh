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

# Backup firewall rules 
if ! [ -d "/backups/firewall" ]; then
    mkdir -p /backups/firewall 
fi
iptables-save > /backups/firewall/iptables_isolate.rulesv4
ip6tables-save > /backups/firewall/iptables_isolate.rulesv6

# Create tables to log all dropped packets (in and out bound)
## IPv4
iptables -N ISOLATE-IN
iptables -N ISOLATE-OUT
## IPv6
ip6tables -N ISOLATE-IN
iptables -N ISOLATE-OUT

# Determine the port SSH is using 
PORT="$(awk -v re="^.*Port " '$0 ~ re {print $2}' /etc/ssh/sshd_config)"
## IPv6
# Create rules to allow SSH
iptables -A ISOLATE-IN -p tcp --dport $PORT -j ACCEPT
# Output ssh rules
iptables -A ISOLATE-OUT -p tcp --sport $PORT -j ACCEPT
## IPv6
ip6tables -A ISOLATE-IN -p tcp --dport $PORT -j ACCEPT
# Output ssh rules
ip6tables -A ISOLATE-OUT -p tcp --sport $PORT -j ACCEPT

## IPv4
iptables -A ISOLATE-OUT -p tcp --sport 1514 -j ACCEPT
iptables -A ISOLATE-OUT -p tcp --dport 1514 -j ACCEPT

## IPv6
ip6tables -A ISOLATE-OUT -p tcp --sport 1514 -j ACCEPT
ip6tables -A ISOLATE-OUT -p tcp --dport 1514 -j ACCEPT

# Drop all other packets

iptables -A ISOLATE-IN -j DROP
iptables -A ISOLATE-OUT -j DROP

# Insert at head of table so we can just remove this one, and not have to redo all other
iptables -I INPUT -j ISOLATE-IN
iptables -I FORWARD -j ISOLATE-IN
iptables -I OUTPUT -j ISOLATE-OUT
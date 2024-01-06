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

# Create Docker in chain, this is so we can debug easier if things go wrong.
iptables -N DOCKER-IN
# Secure Docker client communication
iptables -A DOCKER-IN -p tcp --dport 2376 -j ACCEPT
# This port is used for communication between the nodes of a Docker Swarm or cluster. It only needs to be opened on manager nodes
iptables -A  DOCKER-IN -p tcp --dport 2377 -j ACCEPT
# Communication among nodes -- Need UDP and TCP
iptables -A DOCKER-IN -p tcp --dport 7946 -j ACCEPT
iptables -A DOCKER-IN -p udp --dport 7946 -j ACCEPT
# Ingress network port
iptables -A DOCKER-IN -p udp --dport 4789 -j ACCEPT
iptables -A DOCKER-IN -j RETURN


# Create Docker out chain
iptables -N DOCKER-OUT
# Secure Docker client communication
iptables -A DOCKER-OUT -p tcp --dport 2376 -j ACCEPT
iptables -A DOCKER-OUT -p tcp --sport 2376 -j ACCEPT
# This port is used for communication between the nodes of a Docker Swarm or cluster. It only needs to be opened on manager nodes
iptables -A  DOCKER-OUT -p tcp --dport 2377 -j ACCEPT
iptables -A  DOCKER-OUT -p tcp --sport 2377 -j ACCEPT
# Communication among nodes -- Need UDP and TCP
iptables -A DOCKER-OUT -p tcp --dport 7946 -j ACCEPT
iptables -A DOCKER-OUT -p tcp --sport 7946 -j ACCEPT
iptables -A DOCKER-OUT -p udp --dport 7946 -j ACCEPT
iptables -A DOCKER-OUT -p udp --sport 7946 -j ACCEPT
# Ingress network port
iptables -A DOCKER-OUT -p udp --dport 4789 -j ACCEPT
iptables -A DOCKER-OUT -p udp --sport 4789 -j ACCEPT
iptables -A DOCKER-OUT -j RETURN

# Insert Chains into IN and OUT
sudo iptables -A INPUT -j DOCKER-IN
sudo iptables -A OUTPUT -j DOCKER-OUT



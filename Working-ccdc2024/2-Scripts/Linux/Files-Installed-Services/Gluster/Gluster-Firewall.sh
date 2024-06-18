#! /bin/bash

#********************************
# Written by a sad Matthew Harper...
#********************************

echo "Creating Gluster Firewall Rules"
# Make Chain for Gluster-IN Rules 
iptables -N GLUSTER-IN
# Make Chain for Gluster-OUT Rules
iptables -N GLUSTER-OUT
# Make Chain for Gluster-IN Rules
ip6tables -N GLUSTER-IN
# Make Chain for Gluster-OUT Rules 
ip6tables -N GLUSTER-OUT

# --------------------------------------    Setup GLUSTER Chain      ------------------------------------------------
## IPv4
### IN
# Gluster Management Ports -- they mention TCP and UDP
iptables -A GLUSTER-IN -p tcp -m multiport --dport 24007,24008 -m conntrack --ctstate NEW -j ACCEPT
# Gluster Brick Ports (May be randomized in range after gluster 10)
iptables -A GLUSTER-IN -p tcp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT
# iptables -A GLUSTER -p udp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT # UDP is not mentioned, we will see if it works without

### OUT --> Pain we may have to deal with traffic to a gluster management port, or from a gluster port (responce)
iptables -A GLUSTER-OUT -p tcp -m multiport --sport 24007,24008 -j ACCEPT
# Gluster Brick Ports (May be randomized in range after gluster 10)
iptables -A GLUSTER-OUT -p tcp -m multiport --sport 49152:49162 -j ACCEPT
# iptables -A GLUSTER -p udp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT # UDP is not mentioned, we will see if it works without
# Gluster Management Ports -- they mention TCP and UDP
iptables -A GLUSTER-OUT -p tcp -m multiport --dport 24007,24008 -j ACCEPT
# Gluster Brick Ports (May be randomized in range after gluster 10)
iptables -A GLUSTER-OUT -p tcp -m multiport --dport 49152:49251 -j ACCEPT
# iptables -A GLUSTER -p udp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT # UDP is not mentioned, we will see if it works without


## IPv6
### IN
# Gluster Management Ports -- they mention TCP and UDP
ip6tables -A GLUSTER-IN -p tcp -m multiport --dport 24007:24008 -m conntrack --ctstate NEW -j ACCEPT
# Gluster Brick Ports (May be randomized in range after gluster 10
ip6tables -A GLUSTER-IN -p tcp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT
# ip6tables -A GLUSTER -p udp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT # UDP is not mentioned, we will see if it works without

### OUT --> Pain we may have to deal with traffic to a gluster management port, or from a gluster port (responce)
# Gluster Management Ports -- they mention TCP and UDP
ip6tables -A GLUSTER-OUT -p tcp -m multiport --sport 24007:24008 -j ACCEPT
# Gluster Brick Ports (May be randomized in range after gluster 10
ip6tables -A GLUSTER-OUT -p tcp -m multiport --sport 49152:49162 -j ACCEPT
# ip6tables -A GLUSTER -p udp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT # UDP is not mentioned, we will see if it works without
# Gluster Management Ports -- they mention TCP and UDP
ip6tables -A GLUSTER-OUT -p tcp -m multiport --dport 24007:24008 -j ACCEPT
# Gluster Brick Ports (May be randomized in range after gluster 10
ip6tables -A GLUSTER-OUT -p tcp -m multiport --dport 49152:49162 -j ACCEPT
# ip6tables -A GLUSTER -p udp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT # UDP is not mentioned, we will see if it works without
# -------------------------------------------------------------------------------------------------------------------

echo "Appending Gluster Firewall Chains to the Firewall"
iptables -A INPUT -j GLUSTER-IN
iptables -A OUTPUT -j GLUSTER-OUT
ip6tables -A INPUT -j GLUSTER-IN
ip6tables -A OUTPUT -j GLUSTER-OUT

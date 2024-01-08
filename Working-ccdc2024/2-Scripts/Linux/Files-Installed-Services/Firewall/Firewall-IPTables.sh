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

# The following will be IPTable Commands

# -------------------------------------- Reset Chains chain ---------------------------------------------------------
# Flush the Input and Output chains of IPv4 Tables
iptables -t filter -F INPUT
iptables -t filter -F OUTPUT

# Flush the Input and Output chains of IPv6 Tables
ip6tables -t filter -F INPUT
ip6tables -t filter -F OUTPUT
# -------------------------------------------------------------------------------------------------------------------

# -------------------------------------- Create LOGGING chains ------------------------------------------------------
## IPv4
# Make Logging Chains (General)
# In filter table
iptables -N SSH-INITIAL-LOG
# In mangle table
iptables -t mangle -N INVALID-LOG
# Make Drop Packet Chain
# iptables -N DROP-LOG

## IPv6
# Make Logging Chains (General)
# In filter table
ip6tables -N SSH-INITIAL-LOG
# In mangle table
ip6tables -t mangle -N INVALID-LOG
# Make Drop Packet Chain
# ip6tables -N DROP-LOG
# -------------------------------------------------------------------------------------------------------------------

# -------------------------------------- Setup SSH-INITIAL-LOG chain ---------------------------------------------------------
## IPv4
# Use the limit module to limit the number of logs made
# Prefix with IPTables-SSH-INITIAL:
# Give it a log level of 5 (Notification) 
iptables -A SSH-INITIAL-LOG -m limit --limit 4/sec -j LOG --log-prefix "IPTables-SSH-INITIAL: " --log-level 5
iptables -A SSH-INITIAL-LOG -j RETURN 

## IPv6
# Use the limit module to limit the number of logs made
# Prefix with IPTables-SSH-INITIAL:
# Give it a log level of 5 (Notification) 
ip6tables -A SSH-INITIAL-LOG -m limit --limit 4/sec -j LOG --log-prefix "IP6Tables-SSH-INITIAL: " --log-level 5
ip6tables -A SSH-INITIAL-LOG -j RETURN 
# ----------------------------------------------------------------------------------------------------------------------------

# ------------------------------------------------ INVALID-LOG chain ---------------------------------------------------------
## IPv4
# Use the limit module to limit the number of logs made
# Prefix with IPTables-SSH-INITIAL:
# Give it a log level of 4 (Warning) 
# Drop the invalid packets
iptables -t mangle -A INVALID-LOG -m limit --limit 5/sec -j LOG --log-prefix "IPTables-INVALID-LOG: " --log-level 4
iptables -t mangle -A INVALID-LOG -j DROP 

## IPv6
# Use the limit module to limit the number of logs made
# Prefix with IPTables-SSH-INITIAL:
# Give it a log level of 4 (Warning) 
# Drop the invalid packets
ip6tables -t mangle -A INVALID-LOG -m limit --limit 5/sec -j LOG --log-prefix "IP6Tables-INVALID-LOG: " --log-level 4
ip6tables -t mangle -A INVALID-LOG -j DROP 
# ----------------------------------------------------------------------------------------------------------------------------

# -------------------------------------- Create General Chains chain ------------------------------------------------
## IPv4
# Make Chain to prevent ping flooding
iptables -N ICMP-FLOOD
# # Make Chain for Gluster-IN Rules (Optional)
# iptables -N GLUSTER-IN
# # Make Chain for Gluster-OUT Rules (Optional)
# iptables -N GLUSTER-OUT

## IPv6
# Make Chain to prevent ping flooding
ip6tables -N ICMP-FLOOD
# # Make Chain for Gluster-IN Rules (Optional)
# ip6tables -N GLUSTER-IN
# # Make Chain for Gluster-OUT Rules (Optional)
# ip6tables -N GLUSTER-OUT
# -------------------------------------------------------------------------------------------------------------------

# -------------------------------------- Setup ICMP-FLOOD Chain      ------------------------------------------------
## IPv4
# Use recent module, add the source address to the list (ICMP-FLOOD)
iptables -A ICMP-FLOOD -m recent --set --name ICMP-FLOOD --rsource
# If the source addr is in the ICMP-FLOOD list, and has sent packets in the last second, 6 or more times we will log this. 
# rttl narrows down the matches to those packets in the list for the address with the TTL of the packet that hit the set rule 
# The logging uses the limit module to 1 log a second with the prefix"IPTables-ICMP-FLOOD:"
iptables -A ICMP-FLOOD -m recent --update --seconds 1 --hitcount 6 --name ICMP-FLOOD --rsource --rttl -m limit --limit 1/sec --limit-burst 1 -j LOG --log-prefix "IPTables-ICMP-FLOOD: " --log-level 4
# If the conditions above are true, drop
iptables -A ICMP-FLOOD -m recent --update --seconds 1 --hitcount 6 --name ICMP-FLOOD --rsource --rttl -j DROP
# Otherwise Accept
iptables -A ICMP-FLOOD -j ACCEPT


## IPv6
# Use recent module, add the source address to the list (ICMP-FLOOD)
ip6tables -A ICMP-FLOOD -m recent --set --name ICMP-FLOOD --rsource
# If the source addr is in the ICMP-FLOOD list, and has sent packets in the last second, 6 or more times we will log this. 
# rttl narrows down the matches to those packets in the list for the address with the TTL of the packet that hit the set rule 
# The logging uses the limit module to 1 log a second with the prefix"IPTables-ICMP-FLOOD:"
ip6tables -A ICMP-FLOOD -m recent --update --seconds 1 --hitcount 6 --name ICMP-FLOOD --rsource --rttl -m limit --limit 1/sec --limit-burst 1 -j LOG --log-prefix "IPTables-ICMP-FLOOD: " --log-level 4
# If the conditions above are true, drop
ip6tables -A ICMP-FLOOD -m recent --update --seconds 1 --hitcount 6 --name ICMP-FLOOD --rsource --rttl
# Otherwise Accept
ip6tables -A ICMP-FLOOD -j ACCEPT
# -------------------------------------------------------------------------------------------------------------------

# # --------------------------------------    Setup GLUSTER Chain      ------------------------------------------------
# ## IPv4
# ### IN
# # Gluster Management Ports -- they mention TCP and UDP
# iptables -A GLUSTER-IN -p tcp -m multiport --dport 24007,24008 -m conntrack --ctstate NEW -j ACCEPT
# # Gluster Brick Ports (May be randomized in range after gluster 10)
# iptables -A GLUSTER-IN -p tcp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT
# # iptables -A GLUSTER -p udp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT # UDP is not mentioned, we will see if it works without

# ### OUT --> Pain we may have to deal with traffic to a gluster management port, or from a gluster port (responce)
# iptables -A GLUSTER-OUT -p tcp -m multiport --sport 24007,24008 -j ACCEPT
# # Gluster Brick Ports (May be randomized in range after gluster 10)
# iptables -A GLUSTER-OUT -p tcp -m multiport --sport 49152:49162 -j ACCEPT
# # iptables -A GLUSTER -p udp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT # UDP is not mentioned, we will see if it works without
# # Gluster Management Ports -- they mention TCP and UDP
# iptables -A GLUSTER-OUT -p tcp -m multiport --dport 24007,24008 -j ACCEPT
# # Gluster Brick Ports (May be randomized in range after gluster 10)
# iptables -A GLUSTER-OUT -p tcp -m multiport --dport 49152:49251 -j ACCEPT
# # iptables -A GLUSTER -p udp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT # UDP is not mentioned, we will see if it works without


# ## IPv6
# ### IN
# # Gluster Management Ports -- they mention TCP and UDP
# ip6tables -A GLUSTER-IN -p tcp -m multiport --dport 24007:24008 -m conntrack --ctstate NEW -j ACCEPT
# # Gluster Brick Ports (May be randomized in range after gluster 10
# ip6tables -A GLUSTER-IN -p tcp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT
# # ip6tables -A GLUSTER -p udp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT # UDP is not mentioned, we will see if it works without

# ### OUT --> Pain we may have to deal with traffic to a gluster management port, or from a gluster port (responce)
# # Gluster Management Ports -- they mention TCP and UDP
# ip6tables -A GLUSTER-OUT -p tcp -m multiport --sport 24007:24008 -j ACCEPT
# # Gluster Brick Ports (May be randomized in range after gluster 10
# ip6tables -A GLUSTER-OUT -p tcp -m multiport --sport 49152:49162 -j ACCEPT
# # ip6tables -A GLUSTER -p udp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT # UDP is not mentioned, we will see if it works without
# # Gluster Management Ports -- they mention TCP and UDP
# ip6tables -A GLUSTER-OUT -p tcp -m multiport --dport 24007:24008 -j ACCEPT
# # Gluster Brick Ports (May be randomized in range after gluster 10
# ip6tables -A GLUSTER-OUT -p tcp -m multiport --dport 49152:49162 -j ACCEPT
# # ip6tables -A GLUSTER -p udp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT # UDP is not mentioned, we will see if it works without
# # -------------------------------------------------------------------------------------------------------------------


# ------------------------------------------------ MANGLE tb, PREROUTING chain -----------------------------------------------
## IPv4
# Block all packets with syn set that are not new TCP messages (WINDOW SCAN)
iptables -t mangle -I PREROUTING -m conntrack -p tcp ! --syn --ctstate NEW -j INVALID-LOG
# Blocks all invlaid connections (XMAS SCAN)
iptables -t mangle -I PREROUTING -m conntrack --ctstate INVALID -j INVALID-LOG

## IPv6
# Block all packets with syn set that are not new TCP messages (WINDOW SCAN)
ip6tables -t mangle -I PREROUTING -m conntrack -p tcp ! --syn --ctstate NEW -j INVALID-LOG
# Blocks all invlaid connections (XMAS SCAN)
ip6tables -t mangle -I PREROUTING -m conntrack --ctstate INVALID -j INVALID-LOG
# ----------------------------------------------------------------------------------------------------------------------------

# ------------------------------------------------ INPUT chain ---------------------------------------------------------------

####### Loop back interface Impersonation (Would we like to log this?
#### IPv4
iptables -A INPUT -s 127.0.0.1/8 ! -i lo -j DROP
#### IPv6
ip6tables -A INPUT -s ::1/128 ! -i lo -j DROP

####### SSH
#### IPv4
# Log any SSH connection attempt
iptables -I INPUT -m conntrack -p tcp --dport 22 --ctstate NEW -j SSH-INITIAL-LOG
# Accept SSH Connections
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

#### IPv6
# Log any SSH connection attempt
ip6tables -I INPUT -m conntrack -p tcp --dport 22 --ctstate NEW -j SSH-INITIAL-LOG
# Accept SSH Connections
ip6tables -A INPUT -p tcp --dport 22 -j ACCEPT

####### INBOUND
#### IPv4
# Allows incoming connections from established outbound connections -- Do we want this
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

#### IPv6
ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

####### DNS
#### IPv4
# Zone Transfer
#iptables -A INPUT -p tcp --dport 53 -j ACCEPT
# Name Resolution
iptables -A INPUT -p udp --dport 53 -j ACCEPT

#### IPv4
# Zone Transfer 
# ip6tables -A INPUT -p tcp --dport 53 -j ACCEPT
# Name Resolution
ip6tables -A INPUT -p udp --dport 53 -j ACCEPT

####### Loop back interface (sudo and other things may be slow otherwise)
#### IPv4
iptables -A INPUT -i lo -j ACCEPT
#### IPv6
ip6tables -A INPUT -i lo -j ACCEPT

####### HTTPS -- needed for all? --- 
#### IPv4
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
#### IPv6
ip6tables -A INPUT -p tcp --dport 443 -j ACCEPT

####### ICMP Packets
#### IPv4
# Accept ICMP packets of type 3 - unreachable destination (NEW ESTB and RELATED conns)
iptables -A INPUT -m conntrack -p icmp --icmp-type 3 --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
# Accept ICMP packets of type 11 - Time exceded (TTL expired) (NEW ESTB and RELATED conns)
iptables -A INPUT -m conntrack -p icmp --icmp-type 11 --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
# Accept ICMP packets of type 12 - Bad IPheader packet (NEW ESTB and RELATED conns)
iptables -A INPUT -m conntrack -p icmp --icmp-type 12 --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT

# Ping rules
#iptables -A INPUT -p icmp --icmp-type 0 -m conntrack --ctstate ETABLISHED,RELATED,NEW -j ICMP-FLOOD
#iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate ETABLISHED,RELATED,NEW -j ICMP-FLOOD

#### IPv6
## General
# Accept ICMPv6 Type 1 - unreachable destination
ip6tables -A INPUT -p icmpv6 --icmpv6-type 1 -j ACCEPT
# Accept ICMPv6 Type 2 - Packet Too Big
ip6tables -A INPUT -p icmpv6 --icmpv6-type 2 -j ACCEPT
# Accept ICMPv6 Type 3 - Time Exceded
ip6tables -A INPUT -p icmpv6 --icmpv6-type 3 -j ACCEPT
# Accept ICMPv6 Type 4 - Parameter Problem With Packet Header
ip6tables -A INPUT -p icmpv6 --icmpv6-type 4 -j ACCEPT

## Tunneling (Ping!)
# Accept ICMPv6 Type 128 - echo req
ip6tables -A INPUT -p icmpv6 --icmpv6-type 128 -j ICMP-FLOOD
# Accept ICMPv6 Type 129 - echo rsp
ip6tables -A INPUT -p icmpv6 --icmpv6-type 129 -j ICMP-FLOOD

## Link-local Multicast Receiver Notification
# Accept ICMPv6 Type 130 - Multicast Listener Query
ip6tables -A INPUT -p icmpv6 --icmpv6-type 130 -j ACCEPT
# Accept ICMPv6 Type 131 - Multicast Listener Report
ip6tables -A INPUT -p icmpv6 --icmpv6-type 131 -j ACCEPT
# Accept ICMPv6 Type 132 - Multicast Listener Done
ip6tables -A INPUT -p icmpv6 --icmpv6-type 132 -j ACCEPT
# Accept ICMPv6 Type 143 - Multicast Listener Report v2
ip6tables -A INPUT -p icmpv6 --icmpv6-type 143 -j ACCEPT

## Neighbor and router discovery 
# Accept ICMPv6 Type 133 - Router Solicitation 
ip6tables -A INPUT -p icmpv6 --icmpv6-type 133 -j ACCEPT
# Accept ICMPv6 Type 134 - Router Advertisement
ip6tables -A INPUT -p icmpv6 --icmpv6-type 134 -j ACCEPT
# Accept ICMPv6 Type 135 - Neighbor Solicitation
ip6tables -A INPUT -p icmpv6 --icmpv6-type 135 -j ACCEPT
# Accept ICMPv6 Type 136 - Neighbor Advertisement
ip6tables -A INPUT -p icmpv6 --icmpv6-type 136 -j ACCEPT
# Accept ICMPv6 Type 141 - Inverse Neighbor Discovery Solicitation
ip6tables -A INPUT -p icmpv6 --icmpv6-type 141 -j ACCEPT
# Accept ICMPv6 Type 142 - Inverse Neighbor Discovery Advertisement
ip6tables -A INPUT -p icmpv6 --icmpv6-type 142 -j ACCEPT

## Secure Neighbor Discovery -- Look into
# Accept ICMPv6 Type 148 - Certification Path Solicitation Message
ip6tables -A INPUT -p icmpv6 --icmpv6-type 148 -j ACCEPT
# Accept ICMPv6 Type 148 - Certification Path Advertisement Message
ip6tables -A INPUT -p icmpv6 --icmpv6-type 149 -j ACCEPT

### Multicast Router Discovery 
# Accept ICMPv6 Type 151 - Inverse Neighbor Discovery Advertisement
ip6tables -A INPUT -p icmpv6 --icmpv6-type 151 -j ACCEPT
# Accept ICMPv6 Type 152 - Inverse Neighbor Discovery Advertisement
ip6tables -A INPUT -p icmpv6 --icmpv6-type 152 -j ACCEPT
# Accept ICMPv6 Type 153 - Inverse Neighbor Discovery Advertisement
ip6tables -A INPUT -p icmpv6 --icmpv6-type 153 -j ACCEPT


# ----------------------------------------------------------------------------------------------------------------------------


# ----------------------------------------------- OUTPUT chain ---------------------------------------------------------------
###### SSH
## IPv4
# Log any SSH connection attempt, this is here because it would be odd to do something like this in an outgoing connection
iptables -I OUTPUT -m conntrack -p tcp --dport 22 --ctstate NEW -j SSH-INITIAL-LOG
# Accept SSH Connections
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT 

##IPv6
# Log any SSH connection attempt, this is here because it would be odd to do something like this in an outgoing connection
ip6tables -I OUTPUT -m conntrack -p tcp --dport 22 --ctstate NEW -j SSH-INITIAL-LOG
# Accept SSH Connections
ip6tables -A OUTPUT -p tcp --sport 22 -j ACCEPT 

###### DNS
## IPv4
# Allow Outbound DNS
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
# Allow DNS responces 
iptables -A OUTPUT -p tcp --sport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 53 -j ACCEPT

## IPv6
# Allow Outbound DNS
ip6tables -A OUTPUT -p tcp --dport 53 -j ACCEPT
ip6tables -A OUTPUT -p udp --dport 53 -j ACCEPT
# Allow DNS responces 
ip6tables -A OUTPUT -p tcp --sport 53 -j ACCEPT
ip6tables -A OUTPUT -p tcp --sport 53 -j ACCEPT

###### Loop back interface (sudo and other things may be slow otherwise)
## IPv4
iptables -A OUTPUT -o lo -j ACCEPT
## IPv6
ip6tables -A OUTPUT -o lo -j ACCEPT


###### HTTP/ HTTPS
## IPv4
# Allow requests 
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
# Allow responses 
iptables -A OUTPUT -p tcp --sport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT

## IPv6
# Allow requests 
ip6tables -A OUTPUT -p tcp --dport 443 -j ACCEPT
ip6tables -A OUTPUT -p tcp --dport 80 -j ACCEPT
# Allow responses 
ip6tables -A OUTPUT -p tcp --sport 443 -j ACCEPT
ip6tables -A OUTPUT -p tcp --sport 80 -j ACCEPT

###### Wahzuh 
## IPv4
iptables -A OUTPUT -p tcp --sport 1514 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 1514 -j ACCEPT

## IPv6
ip6tables -A OUTPUT -p tcp --sport 1514 -j ACCEPT
ip6tables -A OUTPUT -p tcp --dport 1514 -j ACCEPT

###### ICMP 
#### IPv4
# Accept ICMP packets of type 3 - unreachable destination (NEW ESTB and RELATED conns)
iptables -A OUTPUT -m conntrack -p icmp --icmp-type 3 --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
# Accept ICMP packets of type 11 - Time exceded (TTL expired) (NEW ESTB and RELATED conns)
iptables -A OUTPUT -m conntrack -p icmp --icmp-type 11 --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
# Accept ICMP packets of type 12 - Bad IPheader packet (NEW ESTB and RELATED conns)
iptables -A OUTPUT -m conntrack -p icmp --icmp-type 12 --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT

# Ping rules
#iptables -A OUTPUT -p icmp --icmp-type 0 -m conntrack --ctstate NEW,ETABLISHED,RELATED -j ICMP-FLOOD
#iptables -A OUTPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW,ETABLISHED,RELATED -j ICMP-FLOOD

#### IPv6
## General
# Accept ICMPv6 Type 1 - unreachable destination
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 1 -j ACCEPT
# Accept ICMPv6 Type 2 - Packet Too Big
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 2 -j ACCEPT
# Accept ICMPv6 Type 3 - Time Exceded
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 3 -j ACCEPT
# Accept ICMPv6 Type 4 - Parameter Problem With Packet Header
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 4 -j ACCEPT

## Tunneling (Ping!)
# Accept ICMPv6 Type 128 - echo req
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 128 -j ICMP-FLOOD
# Accept ICMPv6 Type 129 - echo rsp
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 129 -j ICMP-FLOOD

## Link-local Multicast Receiver Notification
# Accept ICMPv6 Type 130 - Multicast Listener Query
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 130 -j ACCEPT
# Accept ICMPv6 Type 131 - Multicast Listener Report
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 131 -j ACCEPT
# Accept ICMPv6 Type 132 - Multicast Listener Done
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 132 -j ACCEPT
# Accept ICMPv6 Type 143 - Multicast Listener Report v2
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 143 -j ACCEPT

## Neighbor and router discovery 
# Accept ICMPv6 Type 133 - Router Solicitation 
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 133 -j ACCEPT
# Accept ICMPv6 Type 134 - Router Advertisement
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 134 -j ACCEPT
# Accept ICMPv6 Type 135 - Neighbor Solicitation
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 135 -j ACCEPT
# Accept ICMPv6 Type 136 - Neighbor Advertisement
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 136 -j ACCEPT
# Accept ICMPv6 Type 141 - Inverse Neighbor Discovery Solicitation
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 141 -j ACCEPT
# Accept ICMPv6 Type 142 - Inverse Neighbor Discovery Advertisement
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 142 -j ACCEPT

## Secure Neighbor Discovery -- Look into
# Accept ICMPv6 Type 148 - Certification Path Solicitation Message
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 148 -j ACCEPT
# Accept ICMPv6 Type 148 - Certification Path Advertisement Message
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 149 -j ACCEPT

### Multicast Router Discovery 
# Accept ICMPv6 Type 151 - Inverse Neighbor Discovery Advertisement
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 151 -j ACCEPT
# Accept ICMPv6 Type 152 - Inverse Neighbor Discovery Advertisement
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 152 -j ACCEPT
# Accept ICMPv6 Type 153 - Inverse Neighbor Discovery Advertisement
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type 153 -j ACCEPT
# ----------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------- POLICIES  ------------------------------------------------------------------
# Set defualt policy of All FILTER chains to DROP
## IPv4
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

##IPv6
ip6tables -P INPUT DROP
ip6tables -P OUTPUT DROP
ip6tables -P FORWARD DROP

# ----------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------- Docker Specific IPTables rules  --------------------------------------------
if ! [[ -x "$(command -v docker)" ]]; then
    echo "Docker is not installed, exiting script!"
    echo "Saving Firewall Rules"
    if [ -f "/etc/debian_version" ]; 
      then
        iptables-save > /etc/iptables/rules.v4
        ip6tables-save > /etc/iptables/rules.v6
      else
        iptables-save > /etc/sysconfig/iptables
        ip6tables-save > /etc/sysconfig/iptables
    fi 
    exit
fi 
# Create Docker Chain
iptables -N DOCKER-LOG

# Set log for all docker traffic 
# use limit module to limit logs generated to 3 packets a second
# Log with prefix "IPTables-DOCKER-LOG:"
# Set log level to 5 (Notification)
iptables -I DOCKER-LOG -m limit --limit 3/sec -j LOG --log-prefix "IPTables-DOCKER-LOG:" --log-level 5
# Return
iptables -A DOCKER-LOG -j RETURN


# Create rule to log (traffic to container)
# only logs traffic being forwarded to the container
# To limit the amount of logs generated we can limit it to new connections
iptables -I DOCKER-USER  -o docker0 -j DOCKER-LOG
# ----------------------------------------------------------------------------------------------------------------------------


# ------------------------------------------- Save Firewall Rules ------------------------------------------------------------
echo "Saving Firewall Rules"
if [ -f "/etc/debian_version" ]; 
    then
      iptables-save > /etc/iptables/rules.v4
      ip6tables-save > /etc/iptables/rules.v6
    else
      iptables-save > /etc/sysconfig/iptables
      ip6tables-save > /etc/sysconfig/iptables
fi 
# ----------------------------------------------------------------------------------------------------------------------------

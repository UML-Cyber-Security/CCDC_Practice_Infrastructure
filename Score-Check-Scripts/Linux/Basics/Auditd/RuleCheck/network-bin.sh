#!/bin/bash

auditout=$(auditctl -l)

if (( $(echo $auditout | grep -i "/usr/sbin/iptables"| wc -l ) == 0 )); then
    echo "You should consider auditing the use of networking commands like iptables"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/sbin/ip6tables"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of networking commands like ip6tables"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/sbin/arptables"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of networking commands like arptables"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/sbin/netplan"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of networking commands like netplan"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/sbin/tcpdump"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of networking commands like tcpdump"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/sbin/ufw"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of networking commands like ufw"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/sbin/nft"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of networking commands like nft"
    exit 1
fi
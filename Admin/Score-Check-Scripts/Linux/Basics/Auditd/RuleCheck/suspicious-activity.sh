#!/bin/bash

auditout=$(auditctl -l)

if (( $(echo $auditout | grep -i "/usr/bin/wget"| wc -l ) == 0 )); then
    echo "You should consider auditing the use of commands like wget"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/bin/curl"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of networking commands like curl"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/bin/base64"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of networking commands like base64"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/bin/nc"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of networking commands like nc"
    exit 1
elif (( $(echo $auditout | grep -i "/bin/netcat"| wc -l ) != 0  )); then 
    echo "You should consider auditing the use of networking commands like netcat"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/bin/ncat"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of networking commands like ncat"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/bin/ss"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of networking commands like ss"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/bin/netstat"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of networking commands like ss"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/bin/ssh"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of networking commands like ss"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/bin/scp"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of networking commands like ss"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/bin/sftp"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of networking commands like ss"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/bin/ftp"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of networking commands like ss"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/bin/wireshark"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of networking commands like ss"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/bin/tshark"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of networking commands like ss"
    exit 1
fi
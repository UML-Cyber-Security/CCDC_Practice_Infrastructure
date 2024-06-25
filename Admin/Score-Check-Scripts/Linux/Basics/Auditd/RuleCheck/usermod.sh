#!/bin/bash

auditout=$(auditctl -l)

if (( $(echo $auditout | grep -i "/etc/group" | wc -l ) == 0 )); then
    echo "You should consider auditing access and edits to /etc/group"
    exit 1
elif (( $(echo $auditout | grep -i "/etc/passwd"| wc -l ) == 0  )); then 
    echo "You should consider auditing the access and edits to /etc/passwd"
    exit 1
elif (( $(echo $auditout | grep -i "/etc/shadow"| wc -l ) == 0  )); then 
    echo "You should consider auditing the access and edits to /etc/shadow"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/bin/passwd"| wc -l ) == 0  )); then 
    echo "You should consider auditing the access and edits to /etc/passwd"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/sbin/groupadd"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of user modification commands like passwd"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/sbin/groupmod"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of user modification commands like groupmod"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/sbin/addgroup"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of user modification commands like addgroup"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/sbin/useradd"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of user modification commands like useradd"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/sbin/userdel"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of user modification commands like userdel"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/sbin/usermod"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of user modification commands like usermod"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/sbin/adduser"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of user modification commands like adduser"
    exit 1
fi

exit 0
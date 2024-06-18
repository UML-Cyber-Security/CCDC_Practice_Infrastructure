#!/bin/bash

auditout=$(auditctl -l)

if (( $(echo $auditout | grep -i "/bin/systemctl"| wc -l ) == 0 )); then
    echo "You should consider auditing the use of systemctl"
    exit 1
elif (( $(echo $auditout | grep -i "/etc/systemd"| wc -l ) == 0  )); then 
    echo "You should consider auditing the modifications made to the systemd configuration"
    exit 1
fi
exit 0
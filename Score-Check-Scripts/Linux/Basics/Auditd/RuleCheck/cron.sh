#!/bin/bash

auditout=$(auditctl -l)

if (( $(echo $auditout | grep -i "/etc/at.allow"| wc -l ) == 0 )); then
    echo "You should consider auditing the modifications made to the at.allow list"
    exit 1
elif (( $(echo $auditout | grep -i "/etc/cron.allow"| wc -l ) == 0  )); then 
    echo "You should consider auditing the modifications made to the cron allow list"
    exit 1
elif (( $(echo $auditout | grep -i "/etc/crontab"| wc -l ) == 0  )); then 
    echo "You should consider auditing the modifications made to the crontab (etc)"
    exit 1
fi
exit 0
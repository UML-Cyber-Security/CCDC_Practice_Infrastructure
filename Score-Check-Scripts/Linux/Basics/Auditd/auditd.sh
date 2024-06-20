#!/bin/bash

if(( $(systemctl status auditd | grep -i "running" | wc -l ) == 0 )); then
    echo "Auditd is not running, please consider running it to increase logging capabilities"
    exit 1
fi
exit 0


#!/bin/bash

# Sometimes nftables will be the thing not iptables
if(( $(systemctl status nftables | grep -i "running" | wc -l) == 0 )) || (( $(systemctl status iptables | grep -i "running" | wc -l) != 0 )); then
    echo "IPTables is not running"
    exit 1
fi
exit 0


#!/bin/bash

# Sometimes nftables will be the thing not iptables
if(( $(systemctl status firewalld | grep -i "running" | wc -l) != 0 )); then
    echo "Firewalld is running, you should consider disabling it for something better (and to avoid conflict)"
    exit 1
fi

if(( $(systemctl status firewalld | grep -i "masked" | wc -l) != 0 )); then
    echo "firewalld is not masked, you should consider masking it."
    exit 1
fi
exit 0
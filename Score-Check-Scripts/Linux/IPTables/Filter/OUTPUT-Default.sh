#!/bin/bash

if(( $(iptables -L | grep -i "CHAIN OUTPUT (policy ACCEPT)" | wc -l ) != 0 )); then
    echo "The INPUT Chain default policy is ACCEPT. For improved Security consider changing the default policy"
    exit 1
fi
exit 0


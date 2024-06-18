#!/bin/bash

#********************************
# Written by a sad Matthew Harper...
#********************************

if [ $EUID -ne 0 ]; then
    echo "Run me as a superuser"
    exit 1
fi

SERVICES=("docker" "auditd" "glusterd" "sshd" "cron" "wazuh-agent" "rsyslog")
SYSVALS_ZERO=("net.ipv4.conf.all.send_redirects" "net.ipv4.conf.default.send_redirects" "net.ipv4.conf.all.accept_source_route" "net.ipv4.conf.default.accept_source_route" "net.ipv6.conf.all.accept_source_route" "net.ipv6.conf.default.accept_source_route" "net.ipv4.conf.all.accept_redirects" "net.ipv4.conf.default.accept_redirects" "net.ipv6.conf.all.accept_redirects" "net.ipv6.conf.default.accept_redirects" "net.ipv4.conf.all.secure_redirects" "net.ipv4.conf.default.secure_redirects" "net.ipv6.conf.all.accept_ra" "net.ipv6.conf.default.accept_ra")
SYSVALS_ONE=("net.ipv4.conf.all.log_martians" "net.ipv4.conf.default.log_martians" "net.ipv4.icmp_echo_ignore_broadcasts" "net.ipv4.icmp_ignore_bogus_error_responses" "net.ipv4.conf.all.rp_filter" "net.ipv4.conf.default.rp_filter" "net.ipv4.tcp_syncookies")

# auditd -- make sure all rules are loaded
if [ "$(auditctl -l | wc -l )" -ne 41 ]; then 
    echo "[Health-Check-Auditd]: Service has malformed rules"
fi

for serv in $SERVICES
do
if [ "$(systemctl status $serv | grep "active (running)" | wc -l)" -eq 0 ]; then 
    echo "[Health-Check-$serv]: Service is incative"
fi
done

for value in $SYSVALS_ZERO
do
if [ "$(sysctl -n $value)" -ne 0 ]; then 
    echo "[Health-Check-sysctl]: Service has malformed rules $value"
fi
done

for value in $SYSVALS_ONE
do
if [ "$(sysctl -n $value)" -ne 1 ]; then 
    echo "[Health-Check-sysctl]: Service has malformed rules $value"
fi
done
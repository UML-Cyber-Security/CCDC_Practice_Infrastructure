#!/bin/bash
# First 15 min Linix Config Script
# This should configure firewall, sshd, auditd,
# 
# basic linux graylog loggin...?
# Must be run as superuser #

if [ "$EUID" -ne 0 ]; then
  echo "Must run as superuser"
  exit
fi

# Do we need full systems updates?
# most likely not

# debsums could verify integirty of all known system files?
debsums -e (only config files which are common modified)
debsums -g
Compile missing md5 hashes, which we can then reinstall??


# Auditd config here !!!
# Install and configure
# Can pipe into graylog??

# Configure ssh in this part


# Check these ufw rules
debian
    apt install -y ufw > /dev/null 
    ufw allow ssh
    ufw default deny incoming
    ufw default allow outgoing
    ufw logging on 
    ufw enable
    ufw reload
    systemctl start ufw
    systemctl enable ufw
rpm
    yum install -y epel-release > /dev/null
    yum install -y ufw > /dev/null
    ufw allow ssh
    ufw default deny incoming
    ufw default allow outgoing
    ufw logging on 
    echo "y" | ufw enable
    ufw reload
    systemctl start ufw
    systemctl enable ufw

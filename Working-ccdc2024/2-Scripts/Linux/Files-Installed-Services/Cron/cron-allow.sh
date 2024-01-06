#! /bin/bash

#********************************
# Written by a someone
# Edited by Matthew Harper
#********************************

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Remove deny file 
echo "[-] Removing cron/at deny files" 
rm /etc/at.deny 
rm /etc/cron.deny
echo "[+] Adding cron/at allow files"
touch /etc/cron.allow
touch /etc/at.allow
# ADD ADMIN TO ALLOW LIST
# For Both Cron and AT

echo "[+] Changing ownership and permissions to cron/at files"
chmod og-rwx /etc/cron.allow
chmod og-rwx /etc/at.allow
chown root:root /etc/cron.allow
chown root:root /etc/at.allow

# https://www.cyberciti.biz/faq/howto-linux-unix-start-restart-cron/
echo "[!!] Enable cron"
if [ -f "/etc/redhat-release" ] | [ -f "/etc/alpine-release" ] ; then 
  systemctl --now enable crond 
else
  systemctl --now enable cron
fi
  
#! /bin/bash

#********************************
# Written by a sad Matthew Harper...
#********************************

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ];
  then echo "Please run as root"
  exit
fi

################################## Journald
# Ensure Journald logs are sent to syslog
echo "[+] Set journald to forward logs to rsyslog"
if [ "$(grep "ForwardToSyslog" /etc/systemd/journald.conf | wc -l)" -ne 0 ]; then 
  sed -i 's/.*ForwardToSyslog.*/ForwardToSyslog=yes/g' /etc/systemd/journald.conf
else
  echo "ForwardToSyslog=yes" >> /etc/systemd/journald.conf
fi

# Compress large log files
echo "[+] Set journald to compress large files"
if [ "$(grep "Compress" /etc/systemd/journald.conf | wc -l)" -ne 0 ]; then
  sed -i 's/.*Compress.*/Compress=yes/g' /etc/systemd/journald.conf
else
  echo "Compress=yes" >> /etc/systemd/journald.conf
fi

# Logs written to disk rather than stored in volitile mem (RAM?)
echo "[+] Set journald to write logs to disk (immidately)"
if [ "$(grep "Storage" /etc/systemd/journald.conf | wc -l)" -ne 0 ]; then 
  sed -i 's/.*Storage.*/Storage=persistent/g' /etc/systemd/journald.conf
else
  echo "Storage=persistent" >> /etc/systemd/journald.conf
fi
#!/bin/bash
# Script adds rsyslog logging from Linux machine into Graylog
# Run this on the "AGENT" machine!

if [ "$EUID" -ne 0 ]; then
  echo "Must run as superuser"
  exit
fi

echo -e "\n-----------------------------------------"
echo -e "\n-----------------------------------------\nSetting up rsyslogging by UDP port 5140...\n"

if [[ -e "/etc/rsyslog.conf" ]]; then
    read -p "Enter GRAYLOG manager machine ip: " manager_ip
else
    echo "ERROR: /etc/rsyslog.conf is NOT found! Install rsyslog first"
    exit 1
fi

if tail /etc/rsyslog.conf -n 1 | grep -q "RSYSLOG_SyslogProtocol23Format"; then
    echo -e "\n\nERROR: /etc/rsyslog.conf already has some logging set up."
    echo "Current config: "
    cat /etc/rsyslog.conf | grep -i RSYSLOG_SyslogProtocol23Format | head -n 1
    exit 1
else
    echo "*.*@$manager_ip:5140;RSYSLOG_SyslogProtocol23Format" >> "/etc/rsyslog.conf"
    echo -e "Configuration added successfully."
fi

# Ensure Journald logs are sent to syslog
echo -e "\n-----------------------------------------\nForwarding journald logs to rsyslog...\n"
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

systemctl restart rsyslog

echo -e "\n-----------------------------------------\nFinished\n"
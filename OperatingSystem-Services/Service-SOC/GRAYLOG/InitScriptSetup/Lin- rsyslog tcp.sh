#!/bin/bash
# Script adds rsyslog logging from Linux machine into Graylog
# Run this on the "AGENT" machine!

if [ "$EUID" -ne 0 ]; then
  echo "Must run as superuser"
  exit
fi

echo -e "\n-----------------------------------------"
echo -e "\n-----------------------------------------\nSetting up rsyslogging by TCP port 5140...\n"

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
    echo "*.*@@$manager_ip:5140;RSYSLOG_SyslogProtocol23Format" >> "/etc/rsyslog.conf"
    echo -e "Configuration added successfully."
fi
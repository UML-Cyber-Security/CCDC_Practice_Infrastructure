#!/bin/bash

sudo pacman -Syu fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

#Hardening systemctl
touch override.conf

sudo cat <<EOF > override.conf

[Service]
PrivateDevices=yes
PrivateTmp=yes
ProtectHome=read-only
ProtectSystem=strict
NoNewPrivileges=yes
ReadWritePaths=-/var/run/fail2ban
ReadWritePaths=-/var/lib/fail2ban
ReadWritePaths=-/var/log/fail2ban
ReadWritePaths=-/var/spool/postfix/maildrop
CapabilityBoundingSet=CAP_AUDIT_READ CAP_DAC_READ_SEARCH CAP_NET_ADMIN CAP_NET_RAW

EOF

sudo rm /etc/systemd/system/fail2ban.service.d/override.conf
sudo cp override.conf /etc/systemd/system/fail2ban.service.d/
sudo rm override.conf

#Log set up
touch fail2ban.local 

sudo cat <<EOF > fail2ban.local 

[Definition]
logtarget = /var/log/fail2ban/fail2ban.log

EOF

sudo rm /etc/fail2ban/fail2ban.local 
sudo cp fail2ban.local /etc/fail2ban/
sudo rm fail2ban.local 

/etc/fail2ban/fail2ban.local 

sudo systemctl restart fail2ban.service
sudo systemctl status fail2ban

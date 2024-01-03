#! /bin/bash

#********************************
# Written by a someone
# Fixed and edited by a sad Matthew Harper
#********************************

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Prevent ICMP IPv4 Redirects (Use when a system is not acting as a router)
echo "[+] Configuring system to not send icmp redirects!"
echo "net.ipv4.conf.all.send_redirects = 0" >> /etc/sysctl.d/ccdc.conf 
echo "net.ipv4.conf.default.send_redirects = 0" >> /etc/sysctl.d/ccdc.conf 


# Run the following command to restore the default parameter and set the active kernel parameter: # grep -Els "^\s*net\.ipv4\.ip_forward\s*=\s*1" /etc/sysctl.conf /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /run/sysctl.d/*.conf | while read filename; do sed -ri "s/^\s*(net\.ipv4\.ip_forward\s*)(=)(\s*\S+\b).*$/# *REMOVED* \1/" $filename; done; sysctl -w net.ipv4.ip_forward=0; sysctl -w net.ipv4.route.flush=1 IF IPv6 is enabled: Run the following command to restore the default parameter and set the active kernel parameter: # grep -Els "^\s*net\.ipv6\.conf\.all\.forwarding\s*=\s*1" /etc/sysctl.conf /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /run/sysctl.d/*.conf | while read filename; do sed -ri "s/^\s*(net\.ipv6\.conf\.all\.forwarding\s*)(=)(\s*\S+\b).*$/# *REMOVED* \1/" $filename; done; sysctl -w net.ipv6.conf.all.forwarding=0; sysctl -w net.ipv6.route.flush=1
 
# In networking, source routing allows a sender to partially or fully specify the route packets take through a network. 
# In contrast, non-source routed packets travel a path determined by routers in the network. In some cases, 
# systems may not be routable or reachable from some locations (e.g. private addresses vs. Internet routable), 
# and so source routed packets would need to be used.
###### Disable source routing 
echo "[+] Configuring system to deny source routing"
echo "net.ipv4.conf.all.accept_source_route = 0">> /etc/sysctl.d/ccdc.conf 
echo "net.ipv4.conf.default.accept_source_route = 0 " >> /etc/sysctl.d/ccdc.conf 
echo "net.ipv6.conf.all.accept_source_route = 0" >> /etc/sysctl.d/ccdc.conf 
echo "net.ipv6.conf.default.accept_source_route = 0" >> /etc/sysctl.d/ccdc.conf 
# Load conf values refresh 
# sysctl -w net.ipv6.route.flush=1


# ICMP redirect messages are packets that convey routing information and tell your host (acting as a router) to send packets 
# via an alternate path. It is a way of allowing an outside routing device to update your system routing tables. By setting 
# net.ipv4.conf.all.accept_redirects and net.ipv6.conf.all.accept_redirects to 0, the system will not accept any ICMP redirect 
# messages, and therefore, won't allow outsiders to update the system's routing tables.

# Disable IPv4 redirects
echo "[+] Configuring system to deny ICMP redirects"
echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.d/ccdc.conf 
echo "net.ipv4.conf.default.accept_redirects = 0" >> /etc/sysctl.d/ccdc.conf 
# IPv6 Redirects 
echo "net.ipv6.conf.all.accept_redirects = 0"  >> /etc/sysctl.d/ccdc.conf 
echo "net.ipv6.conf.default.accept_redirects = 0"  >> /etc/sysctl.d/ccdc.conf 
# Load conf values refresh 
#sysctl -w net.ipv6.route.flush=1

# Disable secure redirects, same as normal redirects but from known gateways
echo "[+] Configuring system to deny secure redirects"
echo "net.ipv4.conf.all.secure_redirects = 0" >> /etc/sysctl.d/ccdc.conf 
echo "net.ipv4.conf.default.secure_redirects = 0" >> /etc/sysctl.d/ccdc.conf 
# Load Conf values sysctl -p // --> see sysctl-AA.sh
#sysctl -w net.ipv4.route.flush=1

# Log packets with unroutable destinations
echo "[+] Configuring system to log suspicious packets (invalid addresses)"
echo "net.ipv4.conf.all.log_martians = 1" >> /etc/sysctl.d/ccdc.conf # -- Done in script
echo "net.ipv4.conf.default.log_martians = 1" >> /etc/sysctl.d/ccdc.conf 
# Load conf
#sysctl -w net.ipv4.route.flush=1

# Ignore all echo and timestamp broadcast requests 
echo "[+] Configuring system to ignore echo broadcasts"
echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.d/ccdc.conf # Already done I think
# Load conf
#sysctl -w net.ipv4.route.flush=1

# Prevent kernel from logging bogus responces
echo "[+] Configuring system to ignore bogus error responces"
echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> /etc/sysctl.d/ccdc.conf # Already done I think
# Load conf
#sysctl -w net.ipv4.route.flush=1

# forces the Linux kernel to utilize reverse path filtering on a received packet to determine if the packet was valid.
# Essentially, with reverse path filtering, if the return packet does not go out the same interface that the corresponding 
# source packet came from, the packet is dropped (and logged if log_martians is set).
echo "[+] Configuring system to utilize reverse path filtering"
echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.d/ccdc.conf # Already done I think
echo "net.ipv4.conf.default.rp_filter = 1" >> /etc/sysctl.d/ccdc.conf # Already done I think
# Load congig
#sysctl -w net.ipv4.route.flush=1

# Prevent Syn Flooding
echo "[+] Configuring system to be resistant to Syn Flooding"
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.d/ccdc.conf
# Load conf
#sysctl -w net.ipv4.route.flush=1

# IF IPv6 is enabled disable the system's ability to accept IPv6 router advertisements.
#It is recommended that systems do not accept router advertisements as they could be tricked into routing traffic to compromised machines. Setting hard routes within the system (usually a single default route to a trusted router) protects the system from bad routes.
echo "[+] Configuring system to reject router advertisements (IPv6)"
echo "net.ipv6.conf.all.accept_ra = 0" >> /etc/sysctl.d/ccdc.conf #--> May not recomend, but most traffic will be over IPv4 so this may be good? O.W IPv6 router needs to be hard set
echo "net.ipv6.conf.default.accept_ra = 0" >> /etc/sysctl.d/ccdc.conf

echo "[!!] Load configurations from /etc/sysctl.d/ccdc.conf"
sysctl -p /etc/sysctl.d/ccdc.conf

sysctl -w net.ipv4.route.flush=1
sysctl -w net.ipv6.route.flush=1

# Disable and Stop rsync it is considered insecure
echo "[!!] disable rsync"
systemctl --now disable rsync 
# Disable and Stop nis (If it is there) --> Not needed with purge?
echo "[!!] disable nis"
systemctl --now disable nis 


# Enforce Defualt Apparmor Configuration --> will we use SELinux insted?
if [ "$(systemctl is-active apparmor)" = "active" ]; then 
  echo "[!!] set apparmor to encforce"
  aa-enforce /etc/apparmor.d/* 
fi
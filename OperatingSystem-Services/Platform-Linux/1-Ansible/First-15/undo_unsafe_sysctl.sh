#!/bin/bash
# Undo the security hardening configuration

# Enable sending of ICMP redirects
sysctl -w net.ipv4.conf.all.send_redirects=1
sysctl -w net.ipv4.conf.default.send_redirects=1

# Enable source routing
sysctl -w net.ipv4.conf.all.accept_source_route=1
sysctl -w net.ipv4.conf.default.accept_source_route=1
sysctl -w net.ipv6.conf.all.accept_source_route=1
sysctl -w net.ipv6.conf.default.accept_source_route=1

# Enable acceptance of ICMP redirects
sysctl -w net.ipv4.conf.all.accept_redirects=1
sysctl -w net.ipv4.conf.default.accept_redirects=1
sysctl -w net.ipv6.conf.all.accept_redirects=1
sysctl -w net.ipv6.conf.default.accept_redirects=1

# Enable secure ICMP redirects
sysctl -w net.ipv4.conf.all.secure_redirects=1
sysctl -w net.ipv4.conf.default.secure_redirects=1

# Disable martian packet logging
sysctl -w net.ipv4.conf.all.log_martians=0
sysctl -w net.ipv4.conf.default.log_martians=0

# Disable ignoring broadcast ICMP requests
sysctl -w net.ipv4.icmp_ignore_broadcasts=0

# Disable ignoring bogus ICMP error responses
sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=0

# Disable reverse path filtering
sysctl -w net.ipv4.conf.all.rp_filter=0
sysctl -w net.ipv4.conf.default.rp_filter=0

# Disable SYN cookies
sysctl -w net.ipv4.tcp_syncookies=0

# Enable acceptance of router advertisements
sysctl -w net.ipv6.conf.all.accept_ra=1
sysctl -w net.ipv6.conf.default.accept_ra=1

# Persist settings across reboots
cat << EOF > /etc/sysctl.d/undo_hardening.conf
net.ipv4.conf.all.send_redirects=1
net.ipv4.conf.default.send_redirects=1
net.ipv4.conf.all.accept_source_route=1
net.ipv4.conf.default.accept_source_route=1
net.ipv6.conf.all.accept_source_route=1
net.ipv6.conf.default.accept_source_route=1
net.ipv4.conf.all.accept_redirects=1
net.ipv4.conf.default.accept_redirects=1
net.ipv6.conf.all.accept_redirects=1
net.ipv6.conf.default.accept_redirects=1
net.ipv4.conf.all.secure_redirects=1
net.ipv4.conf.default.secure_redirects=1
net.ipv4.conf.all.log_martians=0
net.ipv4.conf.default.log_martians=0
net.ipv4.icmp_ignore_broadcasts=0
net.ipv4.icmp_ignore_bogus_error_responses=0
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0
net.ipv4.tcp_syncookies=0
net.ipv6.conf.all.accept_ra=1
net.ipv6.conf.default.accept_ra=1
EOF

# Reload sysctl configuration
sysctl --system

echo "Security hardening settings undone."
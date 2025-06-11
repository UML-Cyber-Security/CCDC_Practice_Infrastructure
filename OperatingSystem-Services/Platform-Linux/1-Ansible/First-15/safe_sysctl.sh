#!/bin/bash
# Apply security-hardening sysctl settings

echo "Applying security-hardening sysctl settings..."

# Set sysctl parameters
sysctl -w net.ipv4.conf.all.log_martians=1
sysctl -w net.ipv4.icmp_ignore_broadcasts=1
sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w net.ipv4.conf.default.rp_filter=1
sysctl -w net.ipv4.tcp_syncookies=1
sysctl -w kernel.randomize_va_space=2
sysctl -w kernel.panic=10
sysctl -w fs.protected_hardlinks=1
sysctl -w fs.protected_symlinks=1

# Persist settings across reboots
cat << EOF > /etc/sysctl.d/security_hardening.conf
net.ipv4.conf.all.log_martians=1
net.ipv4.icmp_ignore_broadcasts=1
net.ipv4.icmp_ignore_bogus_error_responses=1
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.default.rp_filter=1
net.ipv4.tcp_syncookies=1
kernel.randomize_va_space=2
kernel.panic=10
fs.protected_hardlinks=1
fs.protected_symlinks=1
EOF

# Reload sysctl settings
sysctl --system

echo "Security-hardening sysctl settings applied."
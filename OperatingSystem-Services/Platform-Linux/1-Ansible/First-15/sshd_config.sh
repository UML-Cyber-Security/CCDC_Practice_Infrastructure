#!/bin/bash

# Backup existing SSH configuration files
echo "Backing up /etc/ssh/sshd_config to /etc/ssh/sshd_config.bak..."
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
cp -r /etc/ssh/sshd_config.d /etc/ssh/sshd_config_bak.d

# Create backup directory if it doesn't exist
mkdir -p /etc/ssh/sshd_config_bak.d
mkdir -p /etc/ssh/sshd_config_bak_danger.d

# SSH Configurations - Apply the hardening settings
echo "Applying SSH hardening configurations..."

# Disable root login
sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

# Use only Protocol 2
sed -i 's/^#Protocol.*/Protocol 2/' /etc/ssh/sshd_config

# Set log level to verbose
sed -i 's/^#LogLevel.*/LogLevel VERBOSE/' /etc/ssh/sshd_config

# Set MaxAuthTries to 4
sed -i 's/^#MaxAuthTries.*/MaxAuthTries 4/' /etc/ssh/sshd_config

# Ignore Rhosts
sed -i 's/^#IgnoreRhosts.*/IgnoreRhosts yes/' /etc/ssh/sshd_config

# Disable host-based authentication
sed -i 's/^#HostBasedAuthentication.*/HostBasedAuthentication no/' /etc/ssh/sshd_config

# Disable PermitUserEnvironment
sed -i 's/^#PermitUserEnvironment.*/PermitUserEnvironment no/' /etc/ssh/sshd_config

# Disable empty passwords
sed -i 's/^#PermitEmptyPasswords.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config

# Set ClientAliveInterval to 300 seconds
sed -i 's/^#ClientAliveInterval.*/ClientAliveInterval 300/' /etc/ssh/sshd_config

# Set ClientAliveCountMax to 0
sed -i 's/^#ClientAliveCountMax.*/ClientAliveCountMax 0/' /etc/ssh/sshd_config

# Set LoginGraceTime to 60 seconds
sed -i 's/^#LoginGraceTime.*/LoginGraceTime 60/' /etc/ssh/sshd_config

# Set MaxStartups to 10:30:60
sed -i 's/^#MaxStartups.*/MaxStartups 10:30:60/' /etc/ssh/sshd_config

# Set MaxSessions to 10
sed -i 's/^#MaxSessions.*/MaxSessions 10/' /etc/ssh/sshd_config

# Configure Ciphers for secure SSH
sed -i 's/^#Ciphers.*/Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr/' /etc/ssh/sshd_config

# Configure MACs for secure SSH
sed -i 's/^#MACs.*/MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256/' /etc/ssh/sshd_config

# Configure KEX algorithms for secure SSH
sed -i 's/^#KexAlgorithms.*/KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group14-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256/' /etc/ssh/sshd_config

# Disable TCP forwarding
sed -i 's/^#AllowTcpForwarding.*/AllowTcpForwarding no/' /etc/ssh/sshd_config

# Disable X11 forwarding
sed -i 's/^#X11Forwarding.*/X11Forwarding no/' /etc/ssh/sshd_config

# Restart SSH service again to apply changes
echo "Restarting SSH service again to apply forwarding changes..."
systemctl restart sshd

echo "SSH hardening and configurations are complete."
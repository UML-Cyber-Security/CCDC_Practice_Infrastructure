#!/bin/bash

#********************************
# Written by a Chris?
# Expanded by a sad Matthew Harper
#********************************
if [ $EUID -ne 0 ]; then
    echo "Run me as a superuser"
    exit 1
fi

cp /etc/ssh/sshd_config /backups/configs

echo "[+] Changing protocol to 2 (V1 is insecure)"
if [ $(cat /etc/ssh/sshd_config | grep Protocol | wc -l) -eq 0 ]; then
    echo "Protocol 2" >> /etc/ssh/sshd_config
else
    sed -i '/Protocol /c\Protocol 2' /etc/ssh/sshd_config
fi

echo "[+] Setting Logging Level to Verbose"
if [ $(cat /etc/ssh/sshd_config | grep LogLevel | wc -l) -eq 0 ]; then
    echo "LogLevel VERBOSE" >> /etc/ssh/sshd_config
else
    sed -i '/LogLevel /c\LogLevel VERBOSE' /etc/ssh/sshd_config
fi
echo "[+] Disabling X11 Forwarding"
if [ $(cat /etc/ssh/sshd_config | grep X11Forwarding | wc -l) -eq 0 ]; then
    echo "X11Forwarding no" >> /etc/ssh/sshd_config
else
    sed -i '/X11Forwarding /c\X11Forwarding no' /etc/ssh/sshd_config
fi
echo "[+] Setting Max Auth Tries to 4"
if [ $(cat /etc/ssh/sshd_config | grep MaxAuthTries | wc -l) -eq 0 ]; then
    echo "MaxAuthTries 4" >> /etc/ssh/sshd_config
else
    sed -i '/MaxAuthTries /c\MaxAuthTries 4' /etc/ssh/sshd_config
fi
echo "[+] Ignoring RHosts"
if [ $(cat /etc/ssh/sshd_config | grep IgnoreRhosts | wc -l) -eq 0 ]; then
    echo "IgnoreRhosts yes" >> /etc/ssh/sshd_config
else
    sed -i '/IgnoreRhosts /c\IgnoreRhosts yes' /etc/ssh/sshd_config
fi
echo "[+] Disabling HostbasedAuthentication"
if [ $(cat /etc/ssh/sshd_config | grep HostBasedAuthentication | wc -l) -eq 0 ]; then
    echo "HostBasedAuthentication no" >> /etc/ssh/sshd_config
else
    sed -i '/HostBasedAuthentication /c\HostBasedAuthentication no' /etc/ssh/sshd_config
fi
echo "[+] Disabling Root login"
if [ $(cat /etc/ssh/sshd_config | grep PermitRootLogin | wc -l) -eq 0 ]; then
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config
else
    sed -i '/PermitRootLogin /c\PermitRootLogin no' /etc/ssh/sshd_config
fi
echo "[+] Disabling PermitUserEnvironment"
if [ $(cat /etc/ssh/sshd_config | grep PermitUserEnvironment | wc -l) -eq 0 ]; then
    echo "PermitUserEnvironment no" >> /etc/ssh/sshd_config
else
    sed -i '/PermitUserEnvironment /c\PermitUserEnvironment no' /etc/ssh/sshd_config
fi
echo "[+] Disabling PermitEmptyPasswords"
if [ $(cat /etc/ssh/sshd_config | grep PermitEmptyPasswords | wc -l) -eq 0 ]; then
    echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config
else
    sed -i '/PermitEmptyPasswords /c\PermitEmptyPasswords no' /etc/ssh/sshd_config
fi
echo "[+] Setting ClientAliveInterval to 5 minutes"
if [ $(cat /etc/ssh/sshd_config | grep ClientAliveInterval | wc -l) -eq 0 ]; then
    echo "ClientAliveInterval 300" >> /etc/ssh/sshd_config
else
    sed -i '/ClientAliveInterval /c\ClientAliveInterval 300' /etc/ssh/sshd_config
fi
echo "[+] Setting no reprompt for idle sessions"
if [ $(cat /etc/ssh/sshd_config | grep ClientAliveInterval | wc -l) -eq 0 ]; then
    echo "ClientAliveCountMax 0" >> /etc/ssh/sshd_config
else
    sed -i '/ClientAliveCountMax /c\ClientAliveCountMax 0' /etc/ssh/sshd_config
fi
echo "[+] Setting LoginGraceTime to 1 Minute"
if [ $(cat /etc/ssh/sshd_config | grep LoginGraceTime | wc -l) -eq 0 ]; then
    echo "LoginGraceTime 60" >> /etc/ssh/sshd_config
else
    sed -i '/LoginGraceTime /c\LoginGraceTime 60' /etc/ssh/sshd_config
fi
echo "[+] Enabling PAM"
if [ $(cat /etc/ssh/sshd_config | grep LoginGraceTime | wc -l) -eq 0 ]; then
    echo "UsePAM yes" >> /etc/ssh/sshd_config
else
    sed -i '/UsePAM /c\UsePAM yes' /etc/ssh/sshd_config
fi

### May not want this if we are going to use SSH tunneling
echo "[+] Disabling TCP Forwarding"
if [ $(cat /etc/ssh/sshd_config | grep AllowTcpForwarding | wc -l) -eq 0 ]; then
    echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config
else
    sed -i '/AllowTcpForwarding /c\AllowTcpForwarding no' /etc/ssh/sshd_config
fi
echo "[+] Configuring MaxStartups"
if [ $(cat /etc/ssh/sshd_config | grep maxstartups | wc -l) -eq 0 ]; then
    echo "maxstartups 10:30:60" >> /etc/ssh/sshd_config
else
    sed -i '/maxstartups /c\maxstartups 10:30:60' /etc/ssh/sshd_config
fi
echo "[+] Configuring MaxSessions"
if [ $(cat /etc/ssh/sshd_config | grep MaxSessions | wc -l) -eq 0 ]; then
    echo "MaxSessions 10" >> /etc/ssh/sshd_config
else
    sed -i '/MaxSessions /c\MaxSessions 10' /etc/ssh/sshd_config
fi
echo "[+] Configuring Ciphers"
if [ "$(grep '.*Ciphers.*' /etc/ssh/sshd_config | wc -l)" -eq 0 ]; then
    echo "Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128- gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr" >> /etc/ssh/sshd_config
else
    sed -i 's/.*Ciphers.*/Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr/g' /etc/ssh/sshd_config
fi
echo "[+] Configuring MACS"
if [ "$(grep '.*MACs.*' /etc/ssh/sshd_config | wc -l)" -eq 0 ]; then
    echo "MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256" >> /etc/ssh/sshd_config
else
    sed -i 's/.*MACs.*/MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256/g' /etc/ssh/sshd_config
fi
echo "[+] Configuring KEX"
if [ "$(grep '.*KexAlgorithms.*' /etc/ssh/sshd_config | wc -l)" -eq 0 ]; then
    echo "KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group14-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256" >> /etc/ssh/sshd_config
else
    sed -i 's/.*KexAlgorithms.*/KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group14-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256/g' /etc/ssh/sshd_config
fi

if [ "$(sshd -t | wc -l)" -ne 0 ]; then
    echo "Error in configuration file aborting"
    exit
fi

echo "[+] Restarting SSH to apply changes"
# See how this affects ansible 
# Need to restart SSHD not SSH?
sudo systemctl restart sshd # Originally SSH...
sudo systemctl restart ssh # Originally SSH...

#!/bin/bash
if [ $EUID -ne 0 ]; then
    echo "Run me as a superuser"
    exit 1
fi
echo "[+] Backing up old config to /etc/ssh/sshd_config.backup"
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
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

echo "[+] Restarting SSH to apply changes"
sudo systemctl restart ssh

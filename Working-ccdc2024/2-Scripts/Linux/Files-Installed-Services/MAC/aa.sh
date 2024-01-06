# If Debian
# If there exists this file, it is a debian based system. Use APT
if [ -f "/etc/debian_version" ]; then
    apt-get install apparmor -y 
    systemctl enable --now apparmor
fi

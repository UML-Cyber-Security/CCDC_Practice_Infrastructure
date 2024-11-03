#!/bin/bash

# Simple Bash script for Linux to install a default config of a Wazuh Agent
read -p "Select your Linux system type:
1. Debian
2. RPM
Enter your choice (1 or 2): " linux_system

# Validate the user input
if [ "$linux_system" != "1" ] && [ "$linux_system" != "2" ]; then
    echo "Invalid input. Please enter 1 or 2."
    exit 1
fi

# taek input from user for agent name and manager IP
read -p "Enter the name of your machine: " machine_name

read -p "Enter the Wazuh machine's IP adress: " manager_ip

# pull latest stable repo and install agent
if [ "$linux_system" == "1" ]; then
    curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg
    echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
    apt-get update
    WAZUH_MANAGER=$manager_ip WAZUH_AGENT_NAME=$machine_name apt-get install wazuh-agent
elif [ "$linux_system" == "2" ]; then
    rpm --import https://packages.wazuh.com/key/GPG-KEY-WAZUH
    cat > /etc/yum.repos.d/wazuh.repo << EOF
[wazuh]
gpgcheck=1
gpgkey=https://packages.wazuh.com/key/GPG-KEY-WAZUH
enabled=1
name=EL-\$releasever - Wazuh
baseurl=https://packages.wazuh.com/4.x/yum/
protect=1
EOF
    WAZUH_MANAGER=$manager_ip WAZUH_AGENT_NAME=$machine_name yum install wazuh-agent
fi

sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
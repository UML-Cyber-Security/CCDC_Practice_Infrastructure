#!bin/bash

# Replace this command with the one given by SOC team
sudo WAZUH_MANAGER='192.168.0.99' WAZUH_AGENT_GROUP='default' yum install https://packages.wazuh.com/4.x/yum/wazuh-agent-4.3.10-1.x86_64.rpm

# Enables and starts the wazuh-agent
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
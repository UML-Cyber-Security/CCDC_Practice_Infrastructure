#!/bin/bash

# Replace this command with the command SOC team has given you 

curl -so wazuh-agent-4.3.10.deb https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.3.10-1_amd64.deb && sudo WAZUH_MANAGER='192.168.0.121' WAZUH_AGENT_GROUP='default' dpkg -i ./wazuh-agent-4.3.10.deb

# Restarts and enables the agent
 systemctl daemon-reload
 systemctl enable wazuh-agent
 systemctl start wazuh-agent

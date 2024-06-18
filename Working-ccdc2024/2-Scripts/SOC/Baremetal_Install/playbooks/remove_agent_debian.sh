#!/bin/bash

apt-get remove --purge wazuh-agent -y
systemctl disable wazuh-agent
systemctl daemon-reload
rm wazuh-agent-4.3.10.deb

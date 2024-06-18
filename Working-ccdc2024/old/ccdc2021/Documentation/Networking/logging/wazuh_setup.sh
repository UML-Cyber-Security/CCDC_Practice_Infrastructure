#!/bin/bash

#add repo
apt-get update
apt-get install vim curl apt-transport-https lsb-release gnupg2
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
echo "deb https://packages.wazuh.com/3.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
apt-get update

#install manager
apt-get install wazuh-manager

#install API
curl -sL https://deb.nodesource.com/setup_10.x | bash -
apt-get install nodejs
apt-get install wazuh-api

#set API password
node /var/ossec/api/configuration/auth/htpasswd -c user wazuh

#install filebeat
apt-get install curl apt-transport-https
curl -s https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
apt-get update

apt-get install filebeat=7.5.2
curl -so /etc/filebeat/filebeat.yml https://raw.githubusercontent.com/wazuh/wazuh/v3.11.3/extensions/filebeat/7.x/filebeat.yml
curl -so /etc/filebeat/wazuh-template.json https://raw.githubusercontent.com/wazuh/wazuh/v3.11.3/extensions/elasticsearch/7.x/wazuh-template.json
curl -s https://packages.wazuh.com/3.x/filebeat/wazuh-filebeat-0.1.tar.gz | sudo tar -xvz -C /usr/share/filebeat/module
vim /etc/filebeat/filebeat.yml
systemctl daemon-reload
systemctl enable filebeat.service
systemctl start filebeat.service

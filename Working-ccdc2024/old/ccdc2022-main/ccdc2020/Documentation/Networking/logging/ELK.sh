if [ -z "$1" ]
  then
    echo "enter logstash config dir as argument"
fi

## Install Java
apt install -y openjdk-11-jdk --no-install-recommends
## Install ELK
wget -P /tmp/ https://artifacts.elastic.co/downloads/logstash/logstash-7.5.2.deb & \\
wget -P /tmp/ https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.5.2-amd64.deb & \\
wget -P /tmp/ https://artifacts.elastic.co/downloads/kibana/kibana-7.5.2-amd64.deb
dpkg -i /tmp/logstash-7.5.2.deb
dpkg -i /tmp/elasticsearch-7.5.2-amd64.deb
dpkg -i /tmp/kibana-7.5.2-amd64.deb

chown -R elasticsearch:elasticsearch /usr/share/elasticsearch
chown -R elasticsearch:elasticsearch /var/log/elasticsearch
chown -R elasticsearch:elasticsearch /var/lib/elasticsearch
chown -R elasticsearch:elasticsearch /etc/default/elasticsearch
chown -R elasticsearch:elasticsearch /etc/elasticsearch

# this line might need to be run again if there's a permission error when starting LS
chown -R logstash:logstash /usr/share/logstash/

# install wazuh kibana plugin
# compatibility matrix for different ELK versions
# https://github.com/wazuh/wazuh-kibana-app/#older-packages
sudo -u kibana /usr/share/kibana/bin/kibana-plugin install https://packages.wazuh.com/wazuhapp/wazuhapp-3.11.2_7.5.2.zip

# set wazuh server settings according to API install
vim /usr/share/kibana/plugins/wazuh/wazuh.yml

systemctl enable elasticsearch.service
systemctl enable kibana.service
systemctl start elasticsearch.service
systemctl start kibana.service

# Start logstash
su -u logstash /usr/share/logstash/bin/logstash -f $1

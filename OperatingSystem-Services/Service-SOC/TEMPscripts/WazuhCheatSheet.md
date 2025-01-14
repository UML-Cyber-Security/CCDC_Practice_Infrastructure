## SOC Sheet ##

### Basic Linux ###
- ```passwd <username>``` pass change
- ```apt-get install``` ubuntu package
- ```dnf install``` redhat package
- ```sudo crontab -l``` root user crontabs (active)
- ```sudo crontab -l -u <username>``` user crontabs
- ```sudo userdel -r <username>``` delete user+directory
- ```sudo adduser <username>```
- ```sudo usermod -aG <group> <user>```
- ```source ~/.bashrc``` .bashrc reload

## SERVICE CHECKS ##
- ```systemctl list-units --type=service --state=running``` all running services
- ```ps -p <PID> -o pid,ppid,cmd,%cpu,%mem,etime``` info on PID service
- ```status service.name```
- ```sudo kill -9 (PID)```

## All running PROCESSES ##
- ```ps waux```
- ```ps waux | grep <keyword>```

## ALL PORTS ##
- ```lsof -i```
- ```sudo netstat -tuln```

## GRAYLOG PORTS USED ##
9000 - Browser Dashboard  
1468 - Syslog tcp  
5044 - Beats tcp

9200 - Graylog to Opensearch  
9300 - Opensearch cluster

## Wazuh AGENT STARTERS ##
```
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

## WINDOWS AGENT STARTERS ##
```
Start-Service Wazuh
Stop-Service Wazuh
```

## PASSWORD MNGMNT ##
https://documentation.wazuh.com/current/user-manual/user-administration/password-management.html  
- ```curl -so wazuh-passwords-tool.sh https://packages.wazuh.com/4.9/wazuh-passwords-tool.sh```
  All user pass change:
- ```bash wazuh-passwords-tool.sh -a```
- Update Admin pass in Filebeat + Wazuh Server
- Update Kibanaserver in Dashboard
- Update Wazuh-wui in Dashboard

## MANAGING AGENTS FROM MANAGER ##
- ```/var/ossec/bin/manage_agents```
- Upgrading Agents: https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/agent-upgrade.html
- Configuring a database: https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/database-output.html
- Configuring email alerts: https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/email-alerts.html
- Uninstall
```
apt-get remove --purge wazuh-agent
```
```
sudo yum remove wazuh-agent
```

## Wazuh Cert Locations ##
```
 <certificate_authorities>
        <ca>/etc/filebeat/certs/root-ca.pem</ca>
 </certificate_authorities>
      <certificate>/etc/filebeat/certs/wazuh-server.pem</certificate>
      <key>/etc/filebeat/certs/wazuh-server-key.pem</key>
```
## SSH TUNNEL ##
```
ssh -L [local_port]:[remote_host]:[remote_port] [user]@[ssh_server]
```

## DOCKER EXEC ##
- ```sudo docker exec -it single-node-wazuh.manager-1 bash```
- ```sudo docker ps -a```

### Storage Checks ###
- ```df -h ``` basic
- ```du -sh .``` current directory
- ```du -ah /path/to/folder | sort -rh``` BEST smart check
- ```du -h / | grep '[0-9\.]\+G'```BEST check from mr g
- ```du -h /var/log/* | sort -h``` (/var/log/*) DIRECTORY HERE

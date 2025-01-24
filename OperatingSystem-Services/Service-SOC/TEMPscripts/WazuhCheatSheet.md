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
- ```sudo debsums <arg> <arg>``` -a (all + configs), -e (config only), -s (only report error)
- ```sudo freshclam``` update clamAV scans
- ```sudo clamscan -r -i/ &``` background scan displaying bad file

### Graylog Passes ###
- ```< /dev/urandom tr -dc A-Z-a-z-0-9 | head -c${1:-96};echo;``` secret gen.
- ```echo -n "Enter Password: " && head -1 </dev/stdin | tr -d '\n' | sha256sum | cut -d" " -f1``` SHA2 pass gen.

### SERVICE CHECKS ###
- ```systemctl list-units --type=service --state=running``` all running services
- ```ps -p <PID> -o pid,ppid,cmd,%cpu,%mem,etime``` info on PID service
- ```status service.name```
- ```sudo kill -9 (PID)```

### All running PROCESSES ###
- ```ps waux```
- ```ps waux | grep <keyword>```
- ```ps auxf```

### ALL PORTS ###
- ```lsof -i```
- ```sudo netstat -tuln```

### GRAYLOG PORTS USED (default) ###
```yaml
:443 and/or :80
:9000
:9515
:514
:1514
:4739
:5044 - beats input
:5555
:9515
:27017

with docker also uses?(these are for log inputs):
:5140 - syslog tcp + udp
:12201 - GELF input
:13301 - forwarder data
:13302 - forwarder config
```
### Wazuh AGENT STARTERS ###
```bash
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

### WINDOWS AGENT STARTERS ###
```ps1
Start-Service Wazuh
Stop-Service Wazuh
```

### Wazuh PASSWORD MNGMNT ###
https://documentation.wazuh.com/current/user-manual/user-administration/password-management.html  
- ```curl -so wazuh-passwords-tool.sh https://packages.wazuh.com/4.9/wazuh-passwords-tool.sh```
  All user pass change:
- ```bash wazuh-passwords-tool.sh -a```
- Update Admin pass in Filebeat + Wazuh Server
- Update Kibanaserver in Dashboard
- Update Wazuh-wui in Dashboard

### MANAGING AGENTS FROM MANAGER ###
- ```/var/ossec/bin/manage_agents```
- Upgrading Agents: https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/agent-upgrade.html
- Configuring a database: https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/database-output.html
- Configuring email alerts: https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/email-alerts.html

### Wazuh Agent Uninstall ###
```
apt-get remove --purge wazuh-agent
```
```
sudo yum remove wazuh-agent
```

### Wazuh Cert Locations ###
```
 <certificate_authorities>
        <ca>/etc/filebeat/certs/root-ca.pem</ca>
 </certificate_authorities>
      <certificate>/etc/filebeat/certs/wazuh-server.pem</certificate>
      <key>/etc/filebeat/certs/wazuh-server-key.pem</key>
```
### SSH TUNNEL ###
```bash
ssh -L [local_port]:[remote_host]:[remote_port] [user]@[ssh_server]
```

### DOCKER EXEC ###
```bash
sudo docker exec -it single-node-wazuh.manager-1 bash
```

### Storage Checks ###
- ```df -h ``` Basic
- ```du -sh .``` current directory
- ```du -ah /path/to/folder | sort -rh``` BEST smart check
- ```du -h / | grep '[0-9\.]\+G'``` BEST check from mr g
- ```du -h /var/log/* | sort -h``` (/var/log/*) DIRECTORY HERE
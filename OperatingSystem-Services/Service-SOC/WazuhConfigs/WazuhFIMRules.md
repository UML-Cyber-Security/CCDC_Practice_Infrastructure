# Wazuh FIM Rule Setup with AutoRestart 

Sets up correct FIM rules for Wazuh on linux and windows and adds an autorestart function to the agent.\
This needs to be run on every agent separately!

## 1. Overview  

### For Linux 

1. Download auditd to monitor more information on file changes (optional)

2. Make sure that FIM is enabled (syscheck)

3. Copy over all important FIM rules

4. Sets a sudo crontab that will run auto-restart script every minute

5. Add bash script that will check and run the auto-restart


## 2. Full Procedure for Linux

Change to sudo

Install auditd (optional)
```
apt-get install auditd
```

File location for the agent configuration file

```
nano /var/ossec/etc/ossec.conf
```

Right under `syscheck` - make sure its enabled

Can paste the following
```
<ignore>/root/.bash_history</ignore>

<directories realtime="yes">/etc/update-motd.d/</directories>
<directories realtime="yes">/etc/motd</directories>
<directories realtime="yes">/etc/sudoers</directories>
<directories realtime="yes">/etc/ssh/sshd_config</directories>
<directories realtime="yes">/etc/sudoers.d</directories>
<directories realtime="yes">/etc/bash/bashrc</directories>
<directories realtime="yes">/var/ossec/etc/ossec.conf</directories>
<directories realtime="yes">/var/spool/cron/crontabs/</directories>
<directories realtime="yes">/etc/security/</directories>
<directories realtime="yes">/etc/hosts.allow</directories>
<directories realtime="yes">/home/*/.ssh/authorized_keys</directories>
<directories realtime="yes">/home/*/.bashrc</directories>
<directories realtime="yes">/var/ossec/etc/wazuh-auto-restart.sh</directories>
<directories realtime="yes">/etc/group</directories>

<directories realtime="yes">/etc/shadow</directories>
<directories realtime="yes">/etc/passwd</directories>
<directories realtime="yes" check_all="yes" restrict=".sh$">/home</directories>
```

BROKEN RULE?
```
<directories realtime="yes">/root</directories>
```

Save and exit, then restart the agent
```
systemctl restart wazuh-agent
```

Change back directory and create new auto bash script
```
cd ~
nano /var/ossec/etc/wazuh-auto-restart.sh

#!/bin/bash
SERVICE_NAME="wazuh-agent"
sudo systemctl start $SERVICE_NAME
```

Save, and add execute permissions
```
cd /var/ossec/etc/
chmod +x wazuh-auto-restart.sh
```

Add a new sudo crontab
```
sudo crontab -e
```

Add following line
```
*/1 * * * * /var/ossec/etc/wazuh-auto-restart.sh
```

## Contributors

Author: Viktor Akhonen
Position: SOC person

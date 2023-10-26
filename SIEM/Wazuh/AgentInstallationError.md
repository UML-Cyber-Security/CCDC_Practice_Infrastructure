## Wazuh installing agents Error: 

## Commands run: 

sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent

## Error Recieved:

Synchronizing state of wazuh-agent.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable wazuh-agent
Job for wazuh-agent.service failed because the control process exited with error code.
See "systemctl status wazuh-agent.service" and "journalctl -xeu wazuh-agent.service" for details.

## FURTHER DEBUGGING: 
systemctl status wazuh-agent.service

```
× wazuh-agent.service - Wazuh agent
     Loaded: loaded (/lib/systemd/system/wazuh-agent.service; enabled; vendor preset: enabled)
     Active: failed (Result: exit-code) since Wed 2023-10-25 23:51:33 UTC; 1min 5s ago
    Process: 16485 ExecStart=/usr/bin/env /var/ossec/bin/wazuh-control start (code=exited, status=1/FAILURE)
        CPU: 12ms

Oct 25 23:51:33 team1proxydns systemd[1]: Starting Wazuh agent...

Oct 25 23:51:33 team1proxydns env[16493]: 2023/10/25 23:51:33 wazuh-agentd: ERROR: (4112): __Invalid server address found: 'MANAGER_IP'__

Oct 25 23:51:33 team1proxydns env[16493]: 2023/10/25 23:51:33 wazuh-agentd: CRITICAL: (1215): No client configured. Exiting.

Oct 25 23:51:33 team1proxydns env[16485]: wazuh-agentd: Configuration error. Exiting

Oct 25 23:51:33 team1proxydns systemd[1]: wazuh-agent.service: Control process exited, code=exited, status=1/FAILURE

Oct 25 23:51:33 team1proxydns systemd[1]: wazuh-agent.service: Failed with result 'exit-code'.

Oct 25 23:51:33 team1proxydns systemd[1]: Failed to start Wazuh agent.
```

## Main Problem:

__Invalid server address found: 'MANAGER_IP'__

## How to fix:
 Edit the file /var/ossec/etc/ossec.conf

Change where it says "MANAGER_IP" to the server ip.

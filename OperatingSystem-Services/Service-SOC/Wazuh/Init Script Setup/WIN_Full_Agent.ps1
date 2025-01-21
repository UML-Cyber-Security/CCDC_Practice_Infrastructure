# WHAT IS THIS: 
# Script that should be run to reinstall + configure ALL Wazuh agents. This script should work for 
# WINDOWS OS's and should automatically uninstall and reinstall a Wazuh agent
# THIS IS WIP

Invoke-WebRequest -Uri https://packages.wazuh.com/4.x/windows/wazuh-agent-4.9.2-1.msi -OutFile $env:tmp\wazuh-agent; msiexec.exe /i $env:tmp\wazuh-agent /q WAZUH_MANAGER='172.16.1.248' WAZUH_AGENT_GROUP='windows' WAZUH_AGENT_NAME='winDC'  
NET START WazuhSvc
# How to Completely Remove Wazuh Agent #

## RHEL ##

```bash
yum remove wazuh-agent 
```

## Linux ##

```
apt-get remove wazuh-agent
apt-get remove --purge wazuh-agent
```

## Windows ##

```
msiexec.exe /x wazuh-agent-4.7.1-1.msi /qn
```
# What is checked 

* Docker
* Gluster
* SSHD
* AUDITD
  * number of rules
* CRON
* Sysctl
  * Set rules and values

There is a log-*.sh script which will log to the systems log file (/var/etc/syslog equivalent)

There is a echo-*.sh scrip which we can use to see if theses systems are running, or if the proper rules are configured.


## Logging Prefixes
* "\[Health-Check-Docker:\]" - Indicates docker is not running
* "\[Health-Check-Auditd\]" - Indicates Auditd is not running
* "\[Health-Check-Glusterd\]" - Indicates Gluster is not running -- likely not needed.
*  "\[Health-Check-SSHD\]" - Indicates SSH server is not running -- bad...
*  "\[Health-Check-Cron\]" - Indicates Cron is not running
*   "\[Health-Check-Wazuh-Agent\]" - Indicates Wazuh is not running
*   "\[Health-Check-Rsyslog\]" - Indicates rsyslog is not running
*   "\[Health-Check-Auditd\]" - Indicates malformed auditd rules
    *   Need to change the value when deployed.
*   "\[Health-Check-sysctl\]" - Indicates malformed systemctl rule

## Cron Job
To schedule this we can use the provided setup-schedule script. This creates a cron job that will run every 5 minutes 
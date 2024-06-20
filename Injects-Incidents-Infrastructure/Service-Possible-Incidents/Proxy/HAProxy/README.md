# HAProxy
This is a reverse proxy service that gives access to the internal network services. This is an application and transport layer proxy. This is critical to the infrastructure, as we would otherwise not be able to service scoring check requests.


## Possible Misconfigurations 
* Removal of Proxy Entries
* Modification of Proxy entries to Null-Route
* Removal or modification of SSL certificates

## Impact
All of the mentioned compromises would lead to service or score check failures.

Additionally to restart the service or apply the configuration we would require *sudo* privileges meaning the attacker likely has root access and has possibly compromised passwords.

## Indicators of Compromise
This would again be based on the modifications of the configuration files which can be monitored by something like auditd. 
# Linux DNS
This is a Linux DNS server, there are many programs that could provide this. From the simpler [DNSMASQ](https://thekelleys.org.uk/dnsmasq/doc.html), to the more complicated [Bind9](https://wiki.debian.org/Bind9) services. This may be a critical services as it will be used for either internal DNS resolution for inter-service communications, or the external DNS resolution for score checks! 

## Possible Misconfigurations 
* This service could be configured to use DNSSec with a compromised certificate.
* This service could be configured to respond with a Null-Route for critical services.
* This service could have it's DNS entries wiped, or modified to no longer reflect the original and working configuration
* This service could be exposed to additional ports and interfaces
* This service could simply be stopped. 
## Impact
* This service could be configured to use DNSSec with a compromised certificate.
  * Attackers could impersonate the DNS server
* This service could be configured to respond with a Null-Route for critical services.
  * The score checks or internal services would no longer function properly since their communications are no longer being routed to the correct place. 
* This service could have it's DNS entries wiped, or modified to no longer reflect the original and working configuration
  * The score checks or internal services would no longer function properly since their communications are no longer being routed to the correct place; Or they may be routed to a malicious service. 
* This service could be exposed to additional ports and interfaces
  * This could allow Attackers to pull Information off the server from an unexpected and unmonitored interface
* This service could simply be stopped. 
  * There would be no DNS resolution.


Since you need *sudo* pillages to modify the configuration files this means the attacker has root access and likely has compromised passwords. 
## Indicators of Compromise
Generally this would be done by monitoring the DNS configuration files for changes using something like auditd. 

The only other method would be auditing the logs of services for failed connections.
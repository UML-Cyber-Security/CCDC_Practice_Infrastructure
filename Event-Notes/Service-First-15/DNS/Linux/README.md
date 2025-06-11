# Linux DNS
This is a Linux DNS server, there are many programs that could provide this. From the simpler [DNSMASQ](https://thekelleys.org.uk/dnsmasq/doc.html), to the more complicated [Bind9](https://wiki.debian.org/Bind9) services. This can be used for internal or external DNS resolution, which can provide easy access to machines, or more importantly will be used in the score checks.

## Dependencies
The only service that this may rely on is the a proxy if we are exposing a DNS server to the external networks, and the firewalls that will be configured to grant access to the DNS service. Of course it is dependent on the Host Linux System.

## First 15
* Make Backup of DNS Entires
  * Redteam may delete them!
* Make Backup of DNS Configurations
* Audit DNS Entries and Config
  * Are all those that are expected to be there located there.
  * What ports and interfaces is the DNS server listening on?
  * In the event the DNS server offers additional services (Like DNSMASQ), are any enabled (DHCP, etc).

## First 30 
* Audit the DNS Server each machine is configured to use (/etc/resolv.conf, nmtui)
  * Can Wazuh do this? What about Zabbix
* Question(Need to look into): Is DNSSec something that is good?
## Stretch Goals
Enable DNSSec.
# Beta Planning

Show up for 9:00 AM, the beta will be from 10 AM - 12 Noon

Load certificate into Cyber Range Desktop. SSH into the desktop and then pull info from then.


## Specific Roles
### Network Topology
* Externally outside the subnet - What is visible publicly
* Internal NMap Scan from each subnet
    * (Optional) Go to each system and do NMAPS there, see what each system was

What port is available on the Ansible Machine
### Proxy

### SOC
List all packaged
Structure of COMP (sudo tee / > )

### Ansible

### General Services

Determine what machines have what services installed, is it bare metal  or is it on the K8s Cluster.

Look at the version of the machine you are using (/etc/os_release)

Look at the configuration of the service (How accessible are they), what is the base configuration.

Are there Open source auditing tools for the systems, install get the report and pull it off

Get the versions of all services
### Vault

### CA
* Current Certificates
* Check if CA is the only certificate
* IIS Website

### Domain/AD
GET ADDOMAIN
GET ADORG...whit
GET ADUSER
GET ADGROUP
GET GPO
-- Script Get AD/DOMAIN Info

### DNS
* What DNS is used
Domain Names
* DNS-Lookup Info
* If it is the Domain Controller
Get-DangerZone
Get-DNSServer Resources Record
Get DNS Server Address

### Proxy

### K8s

- Deployment method? (Manual, kubeadm, etc)
- /etc/kubernetes
- /etc/systemd/kubernetes
- Services?
- CNI?
- CSI?
- Ingress?
- Balancer?
- 


### Windows
* Pull all Firewall Configurations
* Get Audit Tools install and run

### Linux
* List all installed services
* Get all config Files
* Get all ports that are open.
* Get Audit Tool install and run
* Check all running processes (?)


## Questions

* 12 or 8 certs: Will most likely be 8

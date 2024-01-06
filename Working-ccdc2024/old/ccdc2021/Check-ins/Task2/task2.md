Task 2
Setup a small network infrastructure with the following specifications. We will use them as baseline for future tasks - 
Network Setup - 
* Single entrypoint with IP address 192.168.7.x/24 (over DHCP)
* Two subnets S1 and S2 with IP ranges 10.0.1.0/24 and 10.0.2.0/24, resp
Subnet 1 (DMZ) -
* Hosts a Windows 2012 server and a CentOS 7.0 (CLI only) server
* Secure the servers from well-known host- and network- based attacks
* Should use static IP addresses based on subnet specifications
* Servers can only be administered (SSH) from Subnet 2 clients
* We will build upon the setup in future tasks
Subnet 2 (Internal) -
* Hosts a Windows 10 OS and a Ubuntu 20.04 (with GUI) OS
* Secure the OSs from well-known host-based attacks
* Should use DHCP for IP address allocation
* Should not be accessible from Subnet 1 or external network
* Hosts a Kali Linux VM for testing security of infrastructure

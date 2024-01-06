# IPtables
##### Written by a sad Matthew Harper
I (Matt) Made life painful by chosing to use IPTables... Trust me it is fun to use. When it works.

This "front end" to netfilters is available and can be run on most (any really) linux distribution. 

Most of the time when you use IPTables you are actually interacting with a NFTables backend. Why we did not just use NFTables? Probbaly because docker integrates with IPTables, and to affect the docker containers we need to edit the Docker User chain (Part of the FORWARD chain in the FILTER table). 

When Running IPTables, you cannot have Firewalld running. **NOTE** that the Install script for IPTables will install IPTables-Persistance. This means we cannot use ufw... as it does not interact with iptables all that well.

We can uninstall **iptables-persistance** and just run the firewall script on startup (Reference Cron). Then UFW can be used for quick fixes, but IPTables is not that bad.

**REMEMBER IPTABLES HAS SEPARATE TABLES FOR IPv4 AND IPv6**

# Common commands
Flush all the rules in a chain of a specified table
iptables -t \<table\> -F \<chain\>

Delete a rule 
iptables -t \<table\> -D \<chain\> \<rule-number\>

Append a rule 
iptables -t \<table\> -A \<chain\> \<rule\>

Insert a rule 
iptables -t \<table\> -A \<chain\> \<rule\>

-p /<protocol> can be paired with a --dport or --sport (des to source). Ports must be associated with a protocol

-i specifies a inbound interface -o specifies an outbound interface

-s specifies a source -d a destination IP

We may make additional use of the -m conntrack module which has the --ctstate flags. This allow use to make use of the fact that IPTables is a stateful firewall and we can use the stat of a connection as an additional parameter.

# Debugging

There are a variety of tools that we can use to debug a firewall. 

**IPTables**: We can use the list and verbose function of IPTables to see the number of packets (and bytes) that a rule has applied to. This can be usefull to see if a ACCEPT rule is being applied properly. Or to see if a DROP/REJECT rule is causing issues. (We can also see if a defualt policy is catching it, and what chain is blocking the traffic)

**ss**: This is a usefull command line untility for finding out what process may be doing, as we can see the port and IP a packet is being sent t0. We can also see if it has been established or if only a SYN has been sent. If we see only a SYN and no established connection we may need to whitelist the port of the destination or source. This would be in the OUTPUT chain of the machine we are using **ss** on. The machine the packet is being sent to would need to whitelist our IP or the port the packet is being sent from in the INPUT chain. 

**netstat** -- Just use ss



Since as we mentioned this "IPtables" Is really using NFTables we can use the following command to trace all packet and the rules being applied. We should redirect this to a file and stop it after a bit.
```sh
sudo xtables-monitor --trace


# redirect it to a file
xtables-monitor --trace > trace-file.txt
```

## OLD 
We can add a modified version of the following rules to create logs of every rule that waS appiled to a specific type of packet.
```
iptables -t raw -A PREROUTING -p tcp --destination 192.168.0.0/24 --dport 80 -j TRACE
iptables -t raw -A OUTPUT -p tcp --destination 192.168.0.0/24 --dport 80 -j TRACE
```

The RAW table is the first table a packet enters. These logs will be stored in the location that IPTables logs are stored. **I have see this as /var/log/kern.log and syslog**

# Ref
* https://linux.die.net/man/8/iptables
* https://serverfault.com/questions/385937/how-to-enable-iptables-trace-target-on-debian-squeeze-6
* https://developers.redhat.com/blog/2020/08/18/iptables-the-two-variants-and-their-relationship-with-nftables
* 
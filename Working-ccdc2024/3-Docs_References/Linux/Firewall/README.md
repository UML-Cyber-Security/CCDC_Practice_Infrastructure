# Intro
This is hopefully to be a short read/presentation less than the suggested 20 - 30 minuets Manoj suggested lol!

As we are concerned with Docker and how the containers interact with the host firewall, and this will (essentially) always be a Linux based host-based firewall we will need to discuss them. One of the more common firewall "Frontends" we will run into is IPTables, this is the firewall that docker will always work with. If other frontends like NFTables or Firewalld are used workarounds will need to be used to emulate the IPTables environment so that it will still work. I do say frontend as these often interact with the Netfilter 

For example in the case of Firewalld the --iptables option must be enabled otherwise docker will not be able to function properly. I am not focusing on Firewalld but you can easily find [guides online](https://docs.rockylinux.org/guides/security/firewalld/) relating IPTables to Firewalld. 

Do note that only one firewall manager can be running at a time!

# IPTables

AS mentioned IPTables is technically a "Frontend" to Netfilter, however most people usually would not consider IPTables a frontend tool.

There are a number of [tables](#tables) that are the largest organizational unit in IPTables, each table is made up of [chains](#chains) these chains are where [rules](#rules) are made and "stored". You can think of it like packets are sent to a table, where they go through a chain, and the rules are checked against the packet and applied. There will be a separate set of tables and chain for IPv4 and IPv6. As this presentation is not focused on IPTables I will not go into the destination, (And I will not be able to)


If a rule is added to a table the entire ruleset (all tables) needs to be reloaded before it is applied.

## Tables
There are a number of tables that make up IPTables.

* raw 
* filter 
* nat
* mangle 
* security 

The **raw** table is used to configure packets to make them exempt from tracking, this is done using the NOTRACK target in IPTabels making it so ip_conntrack is not called. (State of connection is not tracked)

The **filter** table is the one we often are the most concerned with. It is the default table where as the name implies it filters packets and does the actions we traditionally associate with a firewall.

The **nat** table is used for Network Address Translation. This is for outgoing connections. Only the first packet in a stream hists the table, the rest have the same actions as the first applied.

The **mangle** table is for special packet alterations.
  * You can change the Type Of Service (TOS) field
  * You can change the Time To Live field (TTL)
  * MARK sets special mark values on the packet
  * SECMARK can set security context fields on the packet(used in SE LINUX)
  * CONNSECMARK will copy the SECMARK on a single packet to the whole connection

The **security** table is used for Mandatory Access Controls 
## Chains
These are what make up tables. They are lists of [rules](#rules) that are checked and applied in order (top down, FIFO). Tables have built in default chains which can be modified, where we add or remove rules. It is also possible for users to create their own chain, as we can jump from one chain, or table to another at any point.


Chains will have no rules by default, they also will have a default policy, which likely is accept.  (Note that user created chains cannot have a default policy, however you can append a rule that has no matches. This means we will jump back to the calling chain, and attempt to apply the rule right after the calling rule. Then if no preceding rules apply we will apply the default policy.

I will only mention the chains in the forward tables for now!

 * INPUT - This is for packets destined to local sockets, this is things going to the machine this hosted on.
 * FORWARD - This is for packets destined that are being routed through the machine (Forwarded onward!)
 * OUTPUT - This is for locally-generated packets



We can create new **USER DEFINED** chains using the **-N** flag
```sh
$ sudo iptables -N <chain>
```

We can remove a user defined chain using the **-X** flag
```sh
$ sudo iptables -X <chain>
```
## Rules

This is what we would primarily be concerned with, as this is where we define the state of a packet and what actions to take when that rule is matched.

### Listing Rules
The default table that we act on is the **filter** table, to specify different tables we us the **-t** flag.

```sh
# Run command on specified table
$ sudo iptables -t <table> <COMMAND>
```

We can look at the rules a table and its chain contain using the **-L** flag, the **-n** flag specifies we do not want resolved IPs this avoids long recursive lookups.
```sh
# List all rules in a table, do not resolve hostnames.
$ sudo iptables -t <table> -n -L
```
The **--line-numbers** flag can be added to include the rules position in the chain as part of the output so the command would look as follows 
We can look at the rules a table and its chain contain using the **-L** flag, the **-n** flag specifies we do not want resolved IPs this avoids long recursive lookups.
```sh
# List all rules in a table, do not resolve hostnames, and include the chain numbers.
$ sudo iptables -t <table> -n --line-numbers -L
```

The **-v** flag can be used to give more (verbose) output for the system
```
$ sudo iptables -t <table> -n --line-numbers -v -L
```

### Creating Rules
We can insert rules at the beginning or end of a chain. This is done using the **-I** and **-A** flags respectively.

```sh
# Insert rule at start of the chain (-I flag)
$ sudo iptables -I <RULE>
# Insert rule at the end of the chain (-A flag)
$ sudo iptables -A <RULE>
```

We can filter traffic using the interface as condition to check. This is done using the little **-i** flag in the rule definition for incoming traffic, the **-o** flag would be used for outgoing traffic. 
``` sh
# This rule allows use of the loopback interface  
# We specify the interface with the -i lo sequence to allow incoming traffic on the interface
$ sudo iptables -I INPUT -i lo -j ACCEPT
# We specify the interface with the -o sequence to allow for outbound traffic
$ sudo iptables -I OUTPUT -o lo -j ACCEPT
```

We can filter traffic based on the protocol and port number specified. This uses the **-p** flag, **--sport**, and **--dport** flags where the **sport** and **dport** flags are used to filter source and destination port values. Valid arguments for the **-p** flag include **all**, **tcp**, **udp**, **udplite**, **icmp**, **sctp**, and  **icmpv6**. The default argument unless one is specified with -p is **all**.
*Notice that flags using more than one character use two "-"s* 
```sh
# This is a rule that allows tcp communication to port 22 (SSH generally)
$ sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
```

We can filter traffic based on the source address without the use of **modules**. This is done using the **-s** flag. This can be a network name or hostname. Specifying anything that has to be resolved with an external DNS query is a bad idea for obvious reasons. We can specify a network mask can also be provided in the form of CIDR notation or a number specifying the number of 1's from the left. (24 == 255.255.255.0)

```sh
# Accept only tcp packets to port 22 from the 192.168.1.0/24 network
$ sudo iptables -A INPUT -p tcp --dport 22 -s 192.168.1.0/24 -j ACCEPT
```

We can filter traffic by destination using the **-d** flag. The same conditions and rules apply to this flag as the **-s** source flag above.
```sh
## If the destination is X.X.X.X/Y and it is over tcp to port 80 it will be accepted (outbound)
$ sudo iptables -A OUTPUT -p tcp --dport 80 -d X.X.X.X/Y -j ACCEPT
```
You will have seen a **-j** flag previously, this is the jump flag and it defines what the should be done once the conditions in the rule are met. The target of the jump can be a **USER CREATED**, one of the built in targets. The following are the built in targets and what they do.
  * **ACCEPT** - Let the packet through 
  * **DROP** - Drop the packet (No response)
  * **REJECT** - Drop the packet (send response)
  * **QUEUE** - Send packet to user space 
  * **RETURN** - Stop processing in this chain and resume processing in the calling chain

We can jump to a **USER CREATED** chain using the **-g** goto flag, as long as the user chain is a part of the table this rule is in.
```sh
## If the destination is X.X.X.X/Y and it is over tcp to port 80 it will be accepted (outbound)
$ sudo iptables -A INPUT -s X.X.X.X/Y -g <USER_CHAIN>
```
### Replacing Rules 
This is the same as creating rules except you use the **-R** flag to specify the chain and rule you would like to replace 

```sh
# Replaces rule 1 in the INPUT chain with the specified rule
$ sudo iptables -R INPUT 1 <Rule>
```
### Modules

There are a number of built in modules that can be used to increase the granularity of the rules that we are defining. There are quite a lot of them that can be found on various [man pages](https://manpages.ubuntu.com/manpages/xenial/man8/iptables-extensions.8.html).

To use a module you set the module using the **-m** flag, then you can use the flags and options defined by that module.

Some useful modules include [conntrack](https://manpages.ubuntu.com/manpages/xenial/man8/iptables-extensions.8.html#:~:text=before%20the%20comparison\).-,conntrack,-This%20module%2C%20when) which allows you to look at the state of the connection, and use that as a condition to be met in the rule.

We are most likely going to use the **--ctstate** (Connection State) flag this can analyze the packet for the following states
  * NEW
  * ESTABLISHED
  * RELATED - New connection related to an established one 
  * UNTRACKED - From explicit untracking with -j CT --notrack in the raw table
  * INVALID
  * (Two others that likely will not be used)
```sh
# Accept all incoming connections that are already established (Outgoing connections made first)
$ sudo iptables -A INPUT -m conntrack -ctstate ESTABLISHED -j ACCEPT
```

We could also use the [iprange](https://manpages.ubuntu.com/manpages/xenial/man8/iptables-extensions.8.html#:~:text=ipv6%2Dicmp%20%2Dh-,iprange,-This%20matches%20on) module to accept IPs in an explicit range. This uses the **--src-range** and **--dst-range** flags.

```sh
# Accept connections from a source range
$ sudo iptables -A INPUT -m iprange --src-range 192.168.1.100-192.168.1.110 --dst-range 192.168.2.100-192.168.2.200 -j ACCEPT
```

### Deleting Rules

We can flush the entire rule set using the **-F** flag 
```sh
# Flush IPTables, remove all rules 
$ sudo iptables -F
```

We can remove individual rules using the **-D** flag
```sh
# Delete <RuleNumber> rule in the specified table and chain
$ sudo iptables -t <table> -D <CHAIN> <RuleNumber>
```
### Persistance and IPv6

The changes that we make in IPTables are not persistant they are in memory changes, so the next time the machine reboots all of it will be lost. We need to use a built in tool to save these rules.

```sh
sudo /sbin/iptables-save
```

You can restore it using the following command 
```sh
iptables-restore /etc/iptables/iptables.rules
```
Additionally all of these rules are for IPv4 we need to redo, and slightly change them for IPv6.

# Docker 
Appears to be, use DOCKER-USER to filter outbound traffic and some Inbound?



Use the INPUT to block inbound traffic from the same machine as this will not go through the forward table.

Examples:
```sh
# Block traffic to port 80 on port mapped container
# (Container created with -p 80:80 flag)
sudo iptables -I DOCKER-USER -p tcp --dport 80 -j REJECT
```
```sh
# This does not block traffic to port 80 on the host to the container
sudo iptables -I INPUT -p tcp --dport 80 -j REJECT
```
```sh
# This will reject ICP packets between containers, and if possible to the containers
sudo iptables DOCKER-USER -p icmp -REJECT
```
```sh
# This will reject ICP packets to the host machine. We cannot ping the container from the host machine now.
sudo iptables INPUT -p icmp -REJECT
```
# Sources
IPTables:

https://www.hostinger.com/tutorials/iptables-tutorial

https://www.cyberciti.biz/faq/linux-iptables-insert-rule-at-top-of-tables-prepend-rule/

https://linux.die.net/man/8/iptables

https://wiki.archlinux.org/title/Iptables

https://book.huihoo.com/iptables-tutorial/x4192.htm

https://www.digitalocean.com/community/tutorials/iptables-essentials-common-firewall-rules-and-commands 

https://manpages.ubuntu.com/manpages/xenial/man8/iptables-extensions.8.html

Logging:
https://wiki.archlinux.org/title/Iptables#:~:text=Router-,Logging,-The

Docker:
https://docs.docker.com/network/iptables/

# TODO
* Check if UFW appends or inserts 
  * Depending on this people can use UFW more than IPTables
* Save rules to cfg yum. --> service iptables save


# IPTables (IPv4)
## Logging
Currently there is additional logging for SSH-INITAL connections,  INVALID packets (indicative of a scan), and ICMP-FLOOD packets (possible)

* SSH-INITAL will result in logs prefixed at log-level 5 (Notice) with 
  * "IPTables-SSH-INITIAL: "
* INVALID packets will result in logs prefixed at log-level 4 (Warning) with 
  * "IPTables-INVALID-LOG: "
* ICMP-FLOOD will result in logs prefixed at log-level 4 (warning) with
  * "IPTables-ICMP-FLOOD: " 
* Traffic to Docker containers will result in logs prefixed at log-level 5 (Notice) with
  * "IPTables-DOCKER-LOG:"

## INPUT Chain
* Allows all established connections (Established,Related)
* Allows inbound https connections (443) -- if the system is not hosing a web server this should be removed 
* Allows Communications on loopback
* Disallows 127.0.0.0/8 traffic on interfaces other then lo
* Allows DNS, port 53
  * Does not allow zone transfers (port 53 over tcp), may be necissary if we are running a DNS server.
* Accept unreachable destination (3), time exceeded (11) and bad ip header (12) ICMP for IPv4
* Accept ICMPv6 types 1,2,3,4,128,129,130,131,132,133,134,135,136,141,142,143,148,149,151,152,153. Which are described as necessary for IPv6 to function.


If we need to enable zone transfers we would need to do the following:
```sh
# DNS Zone Transfers
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
ip6tables -A INPUT -p tcp --dport 53 -j ACCEPT
```
### ICMP
Ping is not automatically allowed (over IPv4). uncomment the following in the scrip to remove this. You can also run them manually
``` sh
# Ping rules
iptables -A INPUT -m conntrack -p icmp --icmp-type 0 --ctstate NEW,ESTABLISHED,RELATED -j ICMP-FLOOD
iptables -A INPUT -m conntrack -p icmp --icmp-type 8 --ctstate NEW,ESTABLISHED,RELATED -j ICMP-FLOOD
```

IPv6 needs a large number of ICMPv6 packets enabled to function properly.

### Established.
Established connections are automatically allowed. Comment the following in the script to remove it 
```
# Allows incoming connections from established outbound connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```


## Outbound 
* Allows outbound SSH (responses and new conns), logs new connections
* Allows DNS (requests and responses) quires and zone transfers 
* Allows loopback interface traffic 
* Allows HTTP, and HTTPS requests and responses 
* Allows Wahzuh (port 1514)
* ICMP as in inbound

## Rules are saved using IPTables-persistance 
This means there can be conflict with ufw. 
# Notes 
VSCode connections work with the current setup so Justin may be happy

## Gluster --LIKELY NOT NEEDED--
Gluster Chains (GLUSTER-IN, GLUSTER-OUT) are created with the necessary rules to support 10 blocks on a system. (Arbitrarily Chosen)
We can enable the Gluster rules by adding the chains to the INPUT and OUTPUT chains respectively.

We provide no conditions as this is just a patchwork rule, so this will exist on all systems and can be enabled with 2 lines.

```sh
# Add Gluster to the system
iptables -A INPUT -j GLUSTER-IN
ip6tables -A OUTPUT -j GLUSTER-OUT
```

Note: It will be necessary to limit the range to that which is provided.
> Gluster-10 onwards, the brick ports will be randomized. A port is randomly selected within the range of base_port to max_port as defined in glusterd.vol file and then assigned to the brick. For example: if you have five bricks, you need to have at least 5 ports open within the given range of base_port and max_port. To reduce the number of open ports (for best security practices), one can lower the max_port value in the glusterd.vol file and restart glusterd to get it into effect.

The other alternative is we accept all traffic from trusted source address. As currently we accept all traffic to and from a Gluster port.

The Output Chain for gluster is bloated as it may have to handle outbound requests and outbound responses... 


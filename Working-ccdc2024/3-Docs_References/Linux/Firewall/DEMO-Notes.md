# IPTables Demo Notes
##### Written by a sad Matthew Harper

This is the list of commands used in the IPTables Demo, This is because I cannot type!

This is meant to be done on a system running docker
# Part One
```sh
# All the flags seperated out
sudo iptables -L -n -v --line-number

# We can do it this way too, but the L must be at the end
sudo iptables -nvL --line-number
```
Output
```
Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
num   pkts bytes target     prot opt in     out     source               destination         

Chain FORWARD (policy DROP 0 packets, 0 bytes)
num   pkts bytes target     prot opt in     out     source               destination         
1        0     0 DOCKER-USER  all  --  *      *       0.0.0.0/0            0.0.0.0/0           
2        0     0 DOCKER-ISOLATION-STAGE-1  all  --  *      *       0.0.0.0/0            0.0.0.0/0           
3        0     0 ACCEPT     all  --  *      docker0  0.0.0.0/0            0.0.0.0/0            ctstate RELATED,ESTABLISHED
4        0     0 DOCKER     all  --  *      docker0  0.0.0.0/0            0.0.0.0/0           
5        0     0 ACCEPT     all  --  docker0 !docker0  0.0.0.0/0            0.0.0.0/0           
6        0     0 ACCEPT     all  --  docker0 docker0  0.0.0.0/0            0.0.0.0/0           
7        0     0 ACCEPT     all  --  *      docker_gwbridge  0.0.0.0/0            0.0.0.0/0            ctstate RELATED,ESTABLISHED
8        0     0 DOCKER     all  --  *      docker_gwbridge  0.0.0.0/0            0.0.0.0/0           
9        0     0 ACCEPT     all  --  docker_gwbridge !docker_gwbridge  0.0.0.0/0            0.0.0.0/0           
10       0     0 DROP       all  --  docker_gwbridge docker_gwbridge  0.0.0.0/0            0.0.0.0/0           

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
num   pkts bytes target     prot opt in     out     source               destination         

Chain DOCKER (2 references)
num   pkts bytes target     prot opt in     out     source               destination         

Chain DOCKER-ISOLATION-STAGE-1 (1 references)
num   pkts bytes target     prot opt in     out     source               destination         
1        0     0 DOCKER-ISOLATION-STAGE-2  all  --  docker0 !docker0  0.0.0.0/0            0.0.0.0/0           
2        0     0 DOCKER-ISOLATION-STAGE-2  all  --  docker_gwbridge !docker_gwbridge  0.0.0.0/0            0.0.0.0/0           
3        0     0 RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0           

Chain DOCKER-ISOLATION-STAGE-2 (2 references)
num   pkts bytes target     prot opt in     out     source               destination         
1        0     0 DROP       all  --  *      docker0  0.0.0.0/0            0.0.0.0/0           
2        0     0 DROP       all  --  *      docker_gwbridge  0.0.0.0/0            0.0.0.0/0           
3        0     0 RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0           

Chain DOCKER-USER (1 references)
num   pkts bytes target     prot opt in     out     source               destination         
1        0     0 RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0           
```

We can see all the different chains, their rules and the use they have gone through.

# Start Container
Before we start making any new rules we should start a container. The one I will use is a simple nginx container as it has a default web page I can use. (No I am not using the airforce one Justin).

```
docker run --rm -d -p 80:80 --name IPTEST1 nginx
```

See if it is running 
```
docker ps
```

Now we can access the webpage, and see that it is indeed working as expected.

# Look at firewall again 
 
 Again use the following command

 ```
 sudo iptables -nvL
 ```

 We will see output that looks something like the following.
 ```
Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
num   pkts bytes target     prot opt in     out     source               destination         

Chain FORWARD (policy DROP 0 packets, 0 bytes)
num   pkts bytes target     prot opt in     out     source               destination         
1       26  3475 DOCKER-USER  all  --  *      *       0.0.0.0/0            0.0.0.0/0           
2       26  3475 DOCKER-ISOLATION-STAGE-1  all  --  *      *       0.0.0.0/0            0.0.0.0/0           
3       12  1280 ACCEPT     all  --  *      docker0  0.0.0.0/0            0.0.0.0/0            ctstate RELATED,ESTABLISHED
4        2   104 DOCKER     all  --  *      docker0  0.0.0.0/0            0.0.0.0/0           
5       12  2091 ACCEPT     all  --  docker0 !docker0  0.0.0.0/0            0.0.0.0/0           
6        0     0 ACCEPT     all  --  docker0 docker0  0.0.0.0/0            0.0.0.0/0           
7        0     0 ACCEPT     all  --  *      docker_gwbridge  0.0.0.0/0            0.0.0.0/0            ctstate RELATED,ESTABLISHED
8        0     0 DOCKER     all  --  *      docker_gwbridge  0.0.0.0/0            0.0.0.0/0           
9        0     0 ACCEPT     all  --  docker_gwbridge !docker_gwbridge  0.0.0.0/0            0.0.0.0/0           
10       0     0 DROP       all  --  docker_gwbridge docker_gwbridge  0.0.0.0/0            0.0.0.0/0           

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
num   pkts bytes target     prot opt in     out     source               destination         

Chain DOCKER (2 references)
num   pkts bytes target     prot opt in     out     source               destination         
1        2   104 ACCEPT     tcp  --  !docker0 docker0  0.0.0.0/0            172.17.0.2           tcp dpt:80

Chain DOCKER-ISOLATION-STAGE-1 (1 references)
num   pkts bytes target     prot opt in     out     source               destination         
1       12  2091 DOCKER-ISOLATION-STAGE-2  all  --  docker0 !docker0  0.0.0.0/0            0.0.0.0/0           
2        0     0 DOCKER-ISOLATION-STAGE-2  all  --  docker_gwbridge !docker_gwbridge  0.0.0.0/0            0.0.0.0/0           
3       26  3475 RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0           

Chain DOCKER-ISOLATION-STAGE-2 (2 references)
num   pkts bytes target     prot opt in     out     source               destination         
1        0     0 DROP       all  --  *      docker0  0.0.0.0/0            0.0.0.0/0           
2        0     0 DROP       all  --  *      docker_gwbridge  0.0.0.0/0            0.0.0.0/0           
3       12  2091 RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0           

Chain DOCKER-USER (1 references)
num   pkts bytes target     prot opt in     out     source               destination         
1       26  3475 RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0 
```

Notice the packet and byte values changed.

# Go into the continer, Update
```sh
docker exec -it <CONTAINER-NAME/ID> /bin/bash

$ apt update
$  exit
```

We then **Look at** the firewall rules and stats again 

```
sudo iptables -nvL --line-number
```

And we will see an increase from the value before in the FORWARD CHAIN.
This hopefully demonstraits that all traffic to and from a container passes through the FORWARD chain. 
You can also see no changes in the values processed by the DEFUALT POLICIES of the other chains

# Making Rules

```sh
# make a rule to allow for HTTP Traffic 
sudo iptables -I DOCKER-USER -i eth0 -p tcp --dport 80 -j REJECT

# ORDER MATTERS, SPECIFY A PROTOCOL AND PORT LIKE ABOVE
sudo iptables -I DOCKER-USER -i eth0 --dport 80 -p tcp -j REJECT
```

See if the rule has been properly made
```
sudo iptables -nvL
```

Make another rule, but this time to Accept HTTP traffic **USE I**
```
sudo iptables -A DOCKER-USER -i eth0 -p tcp --dport 80 -j ACCEPT
```

Example output
```
Chain DOCKER-USER (1 references)
num   pkts bytes target     prot opt in     out     source               destination         
1        0     0 ACCEPT     tcp  --  eth0   *       0.0.0.0/0            0.0.0.0/0            tcp dpt:80
2        0     0 REJECT     tcp  --  eth0   *       0.0.0.0/0            0.0.0.0/0            tcp dpt:80 reject-with icmp-port-unreachable
3     1164 8674K RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0           
```

 **NOTICE** that if you use -A you may not get the desired result 
 **REPEAT ONE OF ABOVE WITH -A NOT -I**

# Testing 

Access Website again 

Look at IPTables

Remove Rule 

Access Website again

Look at rules

# Inter container limitations

**Blank out counters**
```sh
sudo iptables -Z
```  
I do not think this would be a intentional thing, but it is something to know of so that we dont break a system


**Start another nginx container** I am lazy so I am not using a UBUNTU one
Intall ping on one of the containers
```sh
# Docker exec into the container first
apt install iputils-ping
```

Find the IP of the other container 
```sh
# Outside of the container
docker inspect <CONTAINER-NAME/ID>
```

Ping the other cotnainer from the one hat has ping installed 
```sh
# Exec into the container
ping <IP>
```

Look at the table results!

```
Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
num   pkts bytes target     prot opt in     out     source               destination         

Chain FORWARD (policy DROP 0 packets, 0 bytes)
num   pkts bytes target     prot opt in     out     source               destination         
1       10   840 DOCKER-USER  all  --  *      *       0.0.0.0/0            0.0.0.0/0           
2       10   840 DOCKER-ISOLATION-STAGE-1  all  --  *      *       0.0.0.0/0            0.0.0.0/0           
3        9   756 ACCEPT     all  --  *      docker0  0.0.0.0/0            0.0.0.0/0            ctstate RELATED,ESTABLISHED
4        1    84 DOCKER     all  --  *      docker0  0.0.0.0/0            0.0.0.0/0           
5        0     0 ACCEPT     all  --  docker0 !docker0  0.0.0.0/0            0.0.0.0/0           
6        1    84 ACCEPT     all  --  docker0 docker0  0.0.0.0/0            0.0.0.0/0           
7        0     0 ACCEPT     all  --  *      docker_gwbridge  0.0.0.0/0            0.0.0.0/0            ctstate RELATED,ESTABLISHED
8        0     0 DOCKER     all  --  *      docker_gwbridge  0.0.0.0/0            0.0.0.0/0           
9        0     0 ACCEPT     all  --  docker_gwbridge !docker_gwbridge  0.0.0.0/0            0.0.0.0/0           
10       0     0 DROP       all  --  docker_gwbridge docker_gwbridge  0.0.0.0/0            0.0.0.0/0           

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
num   pkts bytes target     prot opt in     out     source               destination         

Chain DOCKER (2 references)
num   pkts bytes target     prot opt in     out     source               destination         
1        0     0 ACCEPT     tcp  --  !docker0 docker0  0.0.0.0/0            172.17.0.2           tcp dpt:80
2        0     0 ACCEPT     tcp  --  !docker0 docker0  0.0.0.0/0            172.17.0.3           tcp dpt:80

Chain DOCKER-ISOLATION-STAGE-1 (1 references)
num   pkts bytes target     prot opt in     out     source               destination         
1        0     0 DOCKER-ISOLATION-STAGE-2  all  --  docker0 !docker0  0.0.0.0/0            0.0.0.0/0           
2        0     0 DOCKER-ISOLATION-STAGE-2  all  --  docker_gwbridge !docker_gwbridge  0.0.0.0/0            0.0.0.0/0           
3       10   840 RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0           

Chain DOCKER-ISOLATION-STAGE-2 (2 references)
num   pkts bytes target     prot opt in     out     source               destination         
1        0     0 DROP       all  --  *      docker0  0.0.0.0/0            0.0.0.0/0           
2        0     0 DROP       all  --  *      docker_gwbridge  0.0.0.0/0            0.0.0.0/0           
3        0     0 RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0           

Chain DOCKER-USER (1 references)
num   pkts bytes target     prot opt in     out     source               destination         
1       10   840 RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0 
```
Notice that inter container traffic also gets routed through the FORWARD chain, this is why specifying the interface may be important

Look at the output 
```
ip a
```
You will see alot of interfaces and docker has its own, and out internet facing interface in this case is eth0. We may want to consider this when making rules.

# Defualt policy changes 

I will simply change the policy for the FORWARD table as I do not want to be here all night..

```
sudo iptables -P FORWARD DROP
```

look at rules

# User Created Chains LOGGING 
Make a chain for logging
``` 
sudo tables -N Logging 
```

Add rule in docker user to jump to logging chain
```
sudo iptables -I DOCKER-USER -j LOGGING
```

Add rule in LOGGING chain to do the actual logging (non blocking, it will return)
```
sudo iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "IPTables-DOCKER: " --log-level 4
```
**limit** is a module used to limit the number of logs for similar packets, we allow 2 per minuet, this can be seconds hours ect
**-j LOG** specifies we are going to log something 
**--log-prefix** is what is appended to the logs 
**--log-level** is the log level specified 0 - 7 

Normally this is used for dropped packets, so we would just drop them, but I dont what to compleately remove functionality so I will use the **RETURN** target
```
sudo iptables -A LOGGING -j RETURN
```

Look at tables rules

Look at logs at /var/log/messages or 
/var/log/syslog (UBUNTU)

grep 'IPTables-DOCKER' syslog

Taken some info and commands from: https://www.thegeekstuff.com/2012/08/iptables-log-packets/


**limit**


# Quick mention of module conntrack

Allow SSH
```
sudo iptables -I INPUT -p tcp --dport 22 -j ACCEPT

sudo iptables -I output -p tcp --sport 22 -j ACCEPT
```

Set Policy to DROP (HOPE SSH WORKS TOO)
```
sudo iptables -P INPUT DROP
```
Note that VSCode will stop working at this point, but SSH still works
Try pinging anything

Add allow established connections 
``` 
sudo iptables -I INPUT -m conntrack -i eth0 --ctstate ESTABLISHED -j ACCEPT
```





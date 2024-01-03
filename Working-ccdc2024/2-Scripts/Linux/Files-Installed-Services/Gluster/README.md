# GlusterFS

## TODO

* Generalize Install Script
* Make it easier to add peers (File of IPs)
  * Sudo privlage
  * 

## Limit Brick Ports used

Located in glusterd.vol, min is defined by base-port and max is defined by max-port, only change max port. (Firewall autoconfigured to support 10 bricks).

Default Min = 49152
Default Max = 60999

**This is done by the install script!**


The install script will also create the Gluster chains created and append them to the IPTables chains to allow for access.

The script also creates a **/gluster** directory in the root directory (/) this is where we can mount bricks as, we will not be using the partitions method... 

## Installation and Setup

Install and Enable with the provided Script.

(Ensure I did not leave the Firewall up)

Probe (not that kind) the Machines you would like to link in the Gluster System

```
sudo gluster peer probe <IP/HostName>
```

> Script takes file of IPs, runs through all entries?

IPs:
192.168.0.62
192.168.0.107
192.168.0.135

Check Status of peers

```
sudo gluster peer status
```

Check filesystem (is it free)?

```
df 
```

# Use directories over partitions for simplicity

Make a directory, in this case we make a new directory in the root dir

```sh
# -p will make all the directories in the path specified
sudo mkdir -p /gluster/brick
```

So the command will generally look like the following. the force at the end is since we are storing the brick in the root partition

```
gluster volume create \<VOLUME NAME\> \<type\> \<brick-replication\> \<IP/Hostname\>:\<Path-To-Brick(Dire/Partition)\> force 
```

Which I will use

```sh
# This creates a replicated volume named Demo1. Each file is replicated on atleast 3 bricks (the use of 2 is prone to splitbrain -- bad)
sudo gluster volume create Demo1 replica 3 192.168.0.62:/gluster/brick 192.168.0.107:/gluster/brick 192.168.0.135:/gluster/brick force
```

We need to start the volume and authorize hosts to access the volume

```sh
# Start the volume 
sudo gluster volume  start <Volume-Name>

# Authorize Hosts 
sudo gluster volume set <Volume-Name> auth.allow <hostname>
```

So what I will use is...

```
sudo gluster volume start Demo1

sudo gluster volume set Demo1 auth.allow 192.168.0.62
sudo gluster volume set Demo1 auth.allow 192.168.0.107
sudo gluster volume set Demo1 auth.allow 192.168.0.135

```

As this machine is a gluster server and client we can use the following command

```
sudo mount.glusterfs localhost:/Demo1 /mnt
```

If this client were not a server aswell we would use the following syntax

```
mount -t glusterfs HOSTNAME-OR-IPADDRESS:/VOLNAME MOUNTDIR
```

Make the Mount perm (ubuntu)

```
echo 'localhost:/HAS /mnt glusterfs defaults,_netdev,backupvolfile-server=localhost 0 0' >> /etc/fstab
```

See Volume info

```
sudo gluster volume info all
```

## Reset

```
sudo gluster volume delete \<volume name\>
```

```
sudo gluster volume stop \<volume name\>
```

```
sudo uount mount-point
```

# Create swarm

docker swarm init

Join the swarm

use the edited compose file

see the machine the postgress is hosted on
Take it down
does it still work (hopefully)


# General Gluster Information


## Commands


### General Commands 

Here are a bunch of random commands: 

- Check the status of the cluster `gluster peer status`
- Detach a peer from the cluster `gluster peer detach <IP/Hostname>`
- Attach a peer to the cluster: `gluster peer probe <IP/Hostname>`

### Fix "Peer in Cluster (Disconnected)" State

If a peer is in the cluster but is disconnected, you can use the following command to fix it:

1. Stop glusterd: `systemctl stop glusterd`
2. In /var/lib/glusterd, delete everything except glusterd.info (the UUID file): `find /var/lib/glusterd ! -name 'glusterd.info' -type f -exec rm -f {} +`
3. Start glusterd: `systemctl start glusterd`
4. Probe one of the good peers: `gluster peer probe <IP/Hostname>`
5. Restart glusterd, check 'gluster peer status': `systemctl restart glusterd`
6. You may need to restart glusterd another time or two, keep checking peer status.

Taken from here (commands aside): https://staged-gluster-docs.readthedocs.io/en/release3.7.0beta1/Administrator%20Guide/Resolving%20Peer%20Rejected/
# Install Docker and container image
`sudo systemctl start docker`  
`docker images`  
`sudo apt install docker`  
`docker pull ubuntu:latest`  
`docker images`   
To remove existing image:  
`docker image rm -f <image ID>`  
 
# Create Dockerfile 
`mkdir docker`  
`cd docker`  
`vim Dockerfile`  
```
FROM ubuntu:latest

RUN apt update && apt install  openssh-server sudo -y

# -r creates service account, -m and -d create home directory, -s sets default shell, -g and -G set groups
RUN useradd -rm -d /home/test -s /bin/bash -g root -G sudo test

RUN  echo 'test:test' | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]

CMD ["service", "ssh", "start"]
```
To build an image from a dockerfile:  
`docker build -t ubuntu:latest .`  
`docker network create -d bridge my_network`  
`docker run -it --name ub-test --network=my_network -P <image ID> bash `# the P publishes all exposed ports, including the one we published in the Dockerfile  
`docker inspect ub-test | grep IPAddress`  
`ssh test@<IP address>`  

# How to get back into a stopped container
`docker start <container ID>`  
`docker exec -it <container ID> bash`   
Note: if you exit a container, it will stop   

# Inside container
`apt install -y vim iproute2` 
`ip a`  
`service ssh status` 

## Setting up HAProxy
`/etc/haproxy/haproxy.cfg`  
```
defaults
  timeout client 10s
  timeout connect 5s
  timeout server 10s 

global
  chroot /var/lib/haproxy
  user haproxy
  group haproxy


frontend ssh1_fe
  mode tcp
  bind :2222
  use_backend ssh1_be

backend ssh1_be
  mode tcp
  server server1 127.0.0.1:22 check
```

# Setting up Ucomplicated Firewall (UFW)
```
$ apt install ufw
$ sudo ufw status
Status: inactive
$ sudo ufw default deny incoming
$ sudo ufw default deny outgoing
$ sudo ufw allow in 2222/tcp
$ sudo ufw enable
$ sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), deny (outgoing), disabled (routed)
New profiles: skip
To Action From
-- ------ ----
443/tcp ALLOW IN Anywhere
```

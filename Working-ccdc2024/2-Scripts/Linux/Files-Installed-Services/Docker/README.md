# TODO
1. Make Quality Of Life Scripts
   1. Script to add user to docker group


# Rhel
RHEL based systems may install and setup podman, docker based cli commands will still work
 
We use the line 
```
        yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```
instead of the traditional **yum install -y docker** 
# Docker Group
sudo groupadd docker && sudo usermod -aG docker <User>
sudo groupadd docker && sudo gpasswd -a ${USER} docker && sudo service docker restart

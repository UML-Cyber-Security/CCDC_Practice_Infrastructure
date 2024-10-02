# How to install Docker For Wazuh Purposes
Documentation showing how to install Docker for a Wazuh install. A default docker installation will most likely not work.  
In case anything gets outdated more information can be found here: [Offical Wazuh Installation Docs](https://documentation.wazuh.com/current/deployment-options/docker/docker-installation.html)  

> [!IMPORTANT]
>DISCLAMER:  Do not follow docker docs, follow provided steps!


## Increase max_map_count on your Docker host:
This increases the maximum allows of "memmory mapping" a process is allowed to have. 
`sudo sysctl -w vm.max_map_count=262144`

> [!NOTE]
> Or you can use the following steps to make this operation permanent.
> 
> 1. Open `/etc/sysctl.conf` file, 
> 2. Add `vm.max_map_count=262144` to the end of the file
> 3. Run `sysctl vm.max_map_count` to make sure the number is 262144.

## Check Kernel Version

Run: `sudo uname -r`

Make sure kernel version is greater than 3.10.  
Example output: `6.5.6-300.fc39.x86_64` (Kernal version is 6.5.6)


## Run docker installation script:

`sudo curl -sSL https://get.docker.com/ | sh`

## Start Docker:

`sudo systemctl start docker`

## Install the Docker Compose Binary
Check if this is latest version before copying command.

`curl -L "https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`

## Grant Execute Permissions:

`chmod +x /usr/local/bin/docker-compose`

## Make sure it installed fine

`docker-compose --version`

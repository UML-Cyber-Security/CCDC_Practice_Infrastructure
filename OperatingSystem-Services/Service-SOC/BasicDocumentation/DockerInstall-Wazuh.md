# How to install Docker For Wazuh Purposes

## DISCLAIMER: Do not follow docker docs, follow provided steps


Follow these steps:

## Increase max_map_count on your Docker host:

`sudo sysctl -w vm.max_map_count=262144`

### Or to do this permenantly do: 

Edit `/etc/sysctl.conf` file, 

Add `vm.max_map_count=262144` to the end of the file

Run `sysctl vm.max_map_count` to make sure the number is 262144

## Check Kernel Version

Run: `sudo uname -r`

Make sure kernel version is greater than 3.10


## Run docker installation script:

`sudo curl -sSL https://get.docker.com/ | sh`

## Start Docker:

`sudo systemctl start docker`

# Install Docker Compose

## Docker Compose Binary
Check if this is latest version before copying command.

`curl -L "https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`

## Grant Execute Permissions:

`chmod +x /usr/local/bin/docker-compose`

## Make sure it installed fine

`docker-compose --version`

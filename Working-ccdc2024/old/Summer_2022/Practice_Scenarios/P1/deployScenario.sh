#!/bin/sh

# Build the images
sh buildImages.sh

# Build the networks
sh buildNetworks.sh

# Create the attacker machine
# Name on DOCKER is "attacker"
# Name on DNS/NETWORK is "attacker"
# Use the "publicNetwork" DOCKER NETWORK
# Use the image "p1-attacker"
docker run -d --name attacker --hostname attacker --network p1-publicNetwork p1-attacker

# Create the FTP Server
docker run -d --name ftpserver --hostname ftpserver --network p1-publicNetwork p1-ftpserver

# The FTP server needs to be accessible by the developer and the attacker.
# The developer will be connected to the "privateNetwork" DOCKER network.
# The attacker is on the "publicNetwork" DOCKER network.
# It needs both. Only one can be attacked in the "docker run" command.
# This command will add a second adapter.
docker network connect p1-privateNetwork ftpserver

# Create the developer machine
# Connect to the "privateNetwork" DOCKER network
docker run -d --name developer --hostname developer --network p1-privateNetwork p1-developer

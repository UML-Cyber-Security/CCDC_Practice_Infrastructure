#!/bin/sh

# Remove the containers based on the name given in the 
# deployment script
docker rm -f attacker
docker rm -f developer
docker rm -f ftpserver

# Remove the networks
docker network rm p1-publicNetwork
docker network rm p1-privateNetwork

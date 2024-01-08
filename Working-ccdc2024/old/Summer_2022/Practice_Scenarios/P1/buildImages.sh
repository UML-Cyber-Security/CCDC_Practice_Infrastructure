#!/bin/sh

# Build the images of the scenario. Give the tag (-t) of each 
# And then give the directory housing the Dockerfile
docker build -t p1-attacker Attacker/
docker build -t p1-ftpserver FTPServer/
docker build -t p1-developer Developer/

#!/bin/sh

##########################
# Variables
##########################
# New directory name
dirName="$(date +"%d-%m-%Y_%H:%m:%s")-Docker-Info"

# Running containers log
runningContainersLog="running-containers.log"
# Inspect directory
inspectDirectory="Inspect-Outputs"
# Network output log
networkLog="networks.log"
# Docker images log
imagesLog="images.log"
# All containers summarized info
allContainersSummarized="all-containers-summaried.log"

##########################
# Create directory for run
##########################

# Create a directory for this run
mkdir $dirName

# Change into the directory and do work in there
cd $dirName

# Get the IDs of the containers running (a small substring of them)
IDs=$(docker ps -q)

#############################################
# Print out the list of running containers.
#############################################
echo "[!] Running containers..." >> $runningContainersLog
# Now print out the corresponding entries
for val in $IDs; do
	echo $val ...... online >> $runningContainersLog
done


#############################################
# Print out the list of running containers.
#############################################
docker ps -a >> $allContainersSummarized


#################################################
# Print out the information about the containers
#################################################

# Print out information per machine. Do an inspect
AllIDs=$(docker ps -a -q)

# Create the inspect directory
mkdir $inspectDirectory
cd $inspectDirectory

for val in $AllIDs; do
	echo "$val\n\tInspect" >> $val.log
	info=$(docker inspect $val)
	echo "\t\t$info" >> $val.log
	psInfo=$(docker ps -a --filter "id=$val")
	echo "$psInfo" >> $val.log
done

################################################
# Gather all networks made
################################################
cd ..

docker network list >> $networkLog


################################################
# Gather all images
################################################
docker images >> $imagesLog

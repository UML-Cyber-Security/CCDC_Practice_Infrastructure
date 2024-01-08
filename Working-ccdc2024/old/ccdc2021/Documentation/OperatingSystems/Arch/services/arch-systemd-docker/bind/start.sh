#!/bin/bash

#This places us into the pwd to execute the command, do file paths are relative to this file
#parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
#cd "$parent_path"

#If you're re running the script to test, it fails if there's another container with this name
echo ">>>Stopping the last docker container with this name, if existed"
sudo docker container stop archWithBIND

#We gotta build the source image above
echo
echo ">>>Making the docker image that has sshd installed"
sudo docker build . -t archbindimage --no-cache

#This makes systemd works...really unclear on the specifics
echo
echo ">>>Starting a container from the previous image"
sudo docker run \
--entrypoint=/usr/lib/systemd/systemd \
--env container=docker \
--mount type=bind,source=/sys/fs/cgroup,target=/sys/fs/cgroup \
--mount type=tmpfs,destination=/tmp \
--mount type=tmpfs,destination=/run \
--mount type=tmpfs,destination=/run/lock \
--detach \
-p 5353:53 \
--name archWithBIND \
--rm \
archbindimage --log-level=info --unit=sysinit.target

#We couldn't use systemd until not, so run all of your systemd commands with execs
echo
echo ">>>start the named.service service to begin listening for dns queries"
sudo docker exec archWithBIND systemctl start named.service

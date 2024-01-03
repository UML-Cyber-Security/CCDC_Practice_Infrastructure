#!/bin/bash

#This places us into the pwd to execute the command, do file paths are relative to this file
#parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
#cd "$parent_path"

#If you're re running the script to test, it fails if there's another container with this name
echo ">>>Stopping the last docker container with this name, if existed"
sudo docker container stop archWithSSH

#We gotta build the source image above
echo
echo ">>>Making the docker image that has sshd installed"
sudo docker build . -t archsshimage

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
--name archWithSSH \
--rm \
-p 2222:22 \
archsshimage --log-level=info --unit=sysinit.target

#We couldn't run this command until systemd was set up, so just exec it
echo
echo ">>>start the sshd service to begin listening for ssh"
sudo docker exec archWithSSH systemctl start sshd

#!/bin/bash

# remove old exited containers
docker rm $(docker ps -q -f status=exited) >/dev/null 2>&1

# start a new jail for current user
docker run -it \
	-v /etc/group:/etc/group:ro \
	-v /etc/passwd:/etc/passwd:ro \
	-v $HOME:$HOME \
	-u $(id -u $USER):$(id -g $USER) \
	--workdir $HOME \
	--hostname $(hostname) \
	jail

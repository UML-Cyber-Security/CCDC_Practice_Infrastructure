#!/bin/bash

echo "Usage: $ ./docker-isolate.sh <container> (optional)<isolation network>"
echo "If isolation network is not provided isolation-net will be created."

if test "$#" -ne 1; then
    echo "Must provide container ID or name. Please try again"
    exit 2
fi
echo ""
container=$1

if test "$#" -ne 2; then
    docker network create isolation-net
    net="isolation-net"
    echo "Created network: isolation-net"
else
    docker network create $2
    net=$2
    echo "created network: $2"
fi
echo ""

connected_nets=("$(docker container inspect --format '{{range $net,$v := .NetworkSettings.Networks}}{{printf "%s " $net}}{{end}}' $container)")
echo "Found connected networks:"
echo "$connected_nets"
echo " "

for i in $connected_nets
do
    docker network disconnect -f $i $container
    echo "Disconnected $container from network: $i ..."
done
echo ""

docker network connect $net $container
echo "Connected $container to $net"

# Sources:
#
# https://stackoverflow.com/questions/43904562/docker-how-to-find-the-network-my-container-is-in
# https://www.cyberciti.biz/faq/bash-for-loop-array/
# https://stackoverflow.com/questions/24890764/store-grep-output-in-an-array

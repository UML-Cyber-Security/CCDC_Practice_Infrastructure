#!/bin/sh

# Usage: ./install-editors <container name>

docker exec $1 sh -c "apt update && apt install -y vim && apt install -y nano"

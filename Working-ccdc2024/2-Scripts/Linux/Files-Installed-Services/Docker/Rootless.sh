#! /bin/bash

#********************************
# Started by a sad Matthew Harper...
#********************************

# Untested -- argument 1 is the user we are goint to run the docker daemon from.

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ -f /etc/debian_version ]; then 
  export DEBIAN_FRONTEND=noninteractive
  apt-get install -y dbus-user-session
  apt-get install -y docker-ce-rootless-extras
elif [ -f /etc/redhat-release ]; then
  dnf install -y fuse-overlayfs
  # The docs still use apt, so I just changed that to dnf
  dnf install -y docker-ce-rootless-extras
fi

# Setup rootless daemon
/bin/dockerd-rootless-setuptool.sh install

# Run a command as a non-root user from a script ran as root.
sudo -u $1 systemctl --user start docker

# A user manager is spawned for the user at boot and kept around after logouts. This allows users who are not logged in to run long-running services
loginctl enable-linger $1

 export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
 docker context use rootless

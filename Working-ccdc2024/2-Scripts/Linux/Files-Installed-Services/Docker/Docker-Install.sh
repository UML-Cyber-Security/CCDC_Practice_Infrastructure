#! /bin/bash

#********************************
# Written by a sad Matthew Harper...
#********************************

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Stolen from online. Differnet package managers
# Declare an array, and map values 
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/debian_version]=apt-get
osInfo[/etc/alpine-release]=apk
#osInfo[/etc/SuSE-release]=zypp
#osInfo[/etc/gentoo-release]=emerge
echo "[+] Install Docker"

PKG="apt-get"
for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        PKG=${osInfo[$f]}
    fi
done


if [ "$PKG" = "apt-get" ]; then
    export DEBIAN_FRONTEND=noninteractive
    # Remove old versions
    apt-get remove -y  docker docker.io containerd runc 
    # This one needs to be seperated otherwise the command will not run.
    # This may not even exists so it can cause errors.
    apt-get remove -y docker-engine
    # Install necissary packages to run apt over HTTPS
    apt-get -y install ca-certificates curl gnupg lsb-release
    
    # Create file structure and pull Docker's GPG key
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    #  Setup repository 
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update to load in changes
    apt-get update

    # install docker engine and compose
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    #apt-get install docker.io -y # This is what we do if we are not using docker's repository 

    # Automated install may give issues... Manual time
    # apt-get install docker-compose-plugin
    # Setup file structure 
    mkdir -p /usr/local/lib/docker/cli-plugins
    # Pull the files from Docker's Github repository 
    curl -SL https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose

    # Change file permissions
    chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

    # Start docker 
    systemctl start docker
elif  [ "$PKG" = "yum" ]; then
    # Remove old versions?
    yum remove docker \ docker-client \ docker-client-latest \ docker-common \ docker-latest \ docker-latest-logrotate \ docker-logrotate \ docker-engine

    # Install yumutils and add repository for docker 
    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

    # install docker engine and compose -- installs podman
    #yum install -y docker 
    #yum install -y docker-compose-plugin
    
    # installs docker
    yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    # start docker # RHEL installs podman
    systemctl enable --now docker

elif [ "$PKG" = "apk" ]; then
    # Install Docker
    apk add --update docker openrc
    
    # Start Docker Service
    service docker start
elif [ "$PKG" = "pacman" ]; then
    # Download -- Need to specify version and architecture 
   #pacman -U ./docker-desktop-<version>-<arch>.pkg.tar.zst
    echo "No"
    # Start service 
    #systemctl --user start docker-desktop
fi
echo "[!!] Docker has been enabled" 

# Need to run the Script to setup the Docker Firewall.
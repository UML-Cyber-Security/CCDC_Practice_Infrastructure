#! /bin/bash

#********************************
# Edited by a sad Matthew Harper...
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

PKG="apt-get"
for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then # Could move the ifs in here.
        PKG=${osInfo[$f]}
    fi
done

#################### UPDATE
# Download list of packages to update.

##################### Instalations
# Install Python
# Make sure sudo is installed
# Install UFW -- not done 

##################### Remove 
# Remove automounting untility
# Remove telnet from machine
# Remove Network Information Service from machine 
# Remove Talk Service from machine 
# Remove rshell client from machine 
if [ "$PKG" = "apt-get" ]; then
    # Mak Apt act in non-interactive mode 
    $PKG update
    export DEBIAN_FRONTEND=noninteractive
    $PKG upgrade -y # Need to check if this works.
    export DEBIAN_FRONTEND=noninteractive

    apt-get install python3 -y
    apt-get install sudo -y
    apt-get install libpam-google-authenticator -y
    # $PKG install ufw -y

    sudo apt-get purge ftp -y
    apt-get purge autofs -y
    apt-get purge telnet -y
    apt-get purge nis -y
    apt-get purge talk -y 
    apt-get purge rsh-client -y
elif [ "$PKG" = "yum" ]; then

    $PKG update -y
    $PKG upgrade -y # Need to check if this works.

    yum install python3 -y
    yum install sudo -y
    
    yum install google-authenticator -y
    
    yum remove ftp -y
    yum remove autofs -y
    yum remove telnet -y
    yum remove nis -y
    yum remove talk -y
    yum remove rsh-client -y
elif [ "$PKG" = "apk" ]; then
    $PKG update
    $PKG upgrade -y # Need to check if this works.
    # NEED TO ENABLE COMMUNITY REPOSITORY
    sed -i 's/^#\(.*community\)/\1/g' /etc/apk/repositories
    # Install Python and Pip3
    apk add --no-cache python3 py3-pip -y
    apk add sudo  -y
    # Edit sudoers file with basic allow.
    # Sudeoers need to be in the wheel group
    echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers.d/wheel

    # Appears that apk will not ask for confirmation unless you use the --interactive flag
    apk del ftp
    apk del autofs 
    apk del telnet
    apk del nis
    apk del talk
    apk del rsh-client
elif [ "$PKG" = "pacman" ]; then
    echo "We probably have other problems..." 
fi

#! /bin/bash

USERS=(rose justin eduardo andrew chris matt manoj than christa)
password=jollysloth68

if [ $EUID -ne 0 ]; then
    echo  "Please run this script with sudo or as root."
    exit 1
fi

for user in ${USERS[*],,}; do
    id -u $user &>/dev/null
    if [ $? -eq 1 ]; then
        adduser --quiet --disabled-password $user
        usermod -aG sudo $user
	echo $user:$password | chpasswd
        echo "created sudo user $user successfully..."
    else
        echo "$user already exists, skipping..."

    fi
done

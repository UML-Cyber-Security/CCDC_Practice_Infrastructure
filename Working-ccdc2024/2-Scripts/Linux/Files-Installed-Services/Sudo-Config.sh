#!/bin/bash

#********************************
# Copied from somewhere 
#********************************

if [ $EUID -ne 0 ]; then
    echo "Run me as a superuser"
    exit 1
fi

# This was in the other script forgot to move it over 
echo "[+] Configure sudo to execute commands in a psudo termial (pty)"
echo 'Defaults use_pty' | EDITOR="tee -a" visudo

# Change defualt log for SUDO -- can simplify auditing!
echo "[+] Configure sudo to log to a sepaerate file"
echo 'Defaults logfile="/var/log/sudo.log"' | EDITOR='tee -a' visudo
# Another thing, chaneg logs locations or sudo stuff --> good for soc.

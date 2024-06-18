#! /bin/bash

#********************************
# Written by a sad Matthew Harper...
#********************************

#++++++++++++++++++++++++++++++++
# This script adds a user to the at and cron allow lists
# The first argument is a username.
#++++++++++++++++++++++++++++++++

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "$1" >> /etc/cron.d/cron.allow 
echo "$1" >> /etc/at.allow

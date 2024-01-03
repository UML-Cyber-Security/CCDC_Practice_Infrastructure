#! /bin/bash

#**************************
# Written by a sad Matthew Harper
#**************************

#++++++++++++++++++++++++++++++++++++
# This script will set up the healthchecks 
# It will move them to a known location 
# It will set up the cron job
#++++++++++++++++++++++++++++++++++++


# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Move healthchecks to some known location
find . -iname 'log-coreservice.sh' -exec cp {} /usr/local/bin/log-coreservice.sh \;
# Set up the cron job for the healthchecks
find .. -iname 'setup-schedule.sh' -exec {} /usr/local/bin/log-coreservice.sh \;
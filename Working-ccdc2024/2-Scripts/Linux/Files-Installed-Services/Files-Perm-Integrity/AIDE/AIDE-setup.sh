#! /bin/bash

#********************************
# Started by a sad Matthew Harper...
#********************************

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
# This may not be able to be fully automated

# install aide -- Can this be automated
# ubuntu
#echo aide-common aideinit/copynew boolean false | debconf-set-selections
#echo aide-common aide/aideinit boolean false | debconf-set-selections
#echo aide-common aideinit/overwritenew boolean true | debconf-set-selections

# Install AIDE
export DEBIAN_FRONTEND=noninteractive
apt install aide aide-common -y # Works

# Initalize AIDE database
aideinit # Works

# Move new database to working set
mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db # Works

# Configure AIDE service
aide --config /etc/aide/aide.conf --init # This works



# Not needed after this for basic usage
cp ./config/aidecheck.service /etc/systemd/system/aidecheck.service
cp ./config/aidecheck.timer /etc/systemd/system/aidecheck.timer   
chmod 0644 /etc/systemd/system/aidecheck.*  
systemctl reenable aidecheck.timer  
systemctl restart aidecheck.timer  
systemctl daemon-reload    
#OR  If cron will be used to schedule and run aide check, run the following command:    # 
#crontab -u root -e    Add the following line to the crontab:    0 5 * * * /usr/bin/aide.wrapper --config /etc/aide/aide.conf --check

# Create Cron monitoring 
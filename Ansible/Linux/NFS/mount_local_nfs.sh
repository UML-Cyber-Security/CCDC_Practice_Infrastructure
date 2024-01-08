#!bin/bash


apt update
apt install nfs-common

#Mounting the share

##Creating a local directory
cd /mnt
mkdir /mnt/localCCDC2024Storage

##Edit Fstab - Ensures auto mounting on restart
echo "192.168.0.68:/mnt/ccdc2024Storage  /mnt/localCCDC2024Storage nfs defaults 0 0" >> /etc/fstab
cat /etc/fstab/

##Mount the file share
mount /mnt/localCCDC2024Storage
mount 192.168.0.68:/mnt/ccdc2024Storage


##Restart System to ensure changes
restart

# This will be a simple infinate loop verions which will periodically write to one of two archived files, we can expand it to do more 
#! /bin/bash

#++++++++++++++++
# First argument $1 is the path to the brick to copy
# Second Argument is the Identifier we wish to associate 
# with it
#++++++++++++++++


# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# If necissary make the file structure 
if ! [ -d "/backups/gluster/active/gluster-brick$2" ]; then 
    mkdir -p /backups/gluster/active/gluster-brick-$2
fi

while true
do
    #https://superuser.com/questions/188240/how-to-verify-that-file2-is-newer-than-file1-in-bash
    # Replace the older of the two backups that we keep
    tar -C $1/.. -cvpf /backups/gluster/active/gluster-brick-$2/gluster-backup1.tar "$(basename $1)"
    sleep 30m
    tar -C $1/.. -cvpf /backups/gluster/active/gluster-brick-$2/gluster-backup2.tar "$(basename $1)"
    sleep 30m
    
done
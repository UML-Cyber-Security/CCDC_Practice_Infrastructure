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
if ! [ -d "/backups/gluster/active/gluster-brick-$2" ]; then 
    mkdir -p /backups/gluster/active/gluster-brick-$2
fi

# See if there are 2 (or more) files in the directory
if (( "$(ls /backups/gluster/active/gluster-brick-$2 | wc -l)" <= 2 )); then
        # Does the backup one file exist
        echo "Here"
        if ! [ -f "/backups/gluster/active/gluster-brick-$2/gluster-backup1.tar" ]; then
                tar -C $1/.. -cvpf /backups/gluster/active/gluster-brick-$2/gluster-backup1.tar "$(basename $1)"
                exit
        fi
        # Does the backup two file exist
        if ! [ -f "/backups/gluster/active/gluster-brick-$2/gluster-backup2.tar" ]; then
                tar -C $1/.. -cvpf /backups/gluster/active/gluster-brick-$2/gluster-backup2.tar "$(basename "$1")"
                exit
        fi
fi

#https://superuser.com/questions/188240/how-to-verify-that-file2-is-newer-than-file1-in-bash

# Replace the older of the two backups that we keep
if [ "/backups/gluster/active/gluster-brick-$2/gluster-backup2.tar" -nt "/backups/gluster/active/gluster-brick-$2/gluster-backup1.tar" ]; then
        tar -C $1/.. -cvpf /backups/gluster/active/gluster-brick-$2/gluster-backup1.tar "$(basename $1)"

else    
        tar -C $1/.. -cvpf /backups/gluster/active/gluster-brick-$2/gluster-backup2.tar "$(basename $1)"
fi
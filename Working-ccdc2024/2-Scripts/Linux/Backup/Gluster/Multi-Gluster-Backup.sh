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

# Read file into array 
readarray -t PATHS < $1
# Read idents into array
readarray -t IDENTIFIERS < $2

# If necissary make the file structure 
# ${!IDENTIFIERS[@]} evaluates to all indexes of the array
# ${#IDENTIFIERS[@]} evaluates to the length of the array 
# ${IDENTIFIERS[@]} evaluates to all elements of the array 
for i in ${!IDENTIFIERS[@]}; do
    if ! [ -d "/backups/gluster/active/gluster-brick-${IDENTIFIERS[$i]}" ]; then 
        mkdir -p /backups/gluster/active/gluster-brick-${IDENTIFIERS[$i]}
    fi


    # See if there are 2 (or more) files in the directory
    if (( "$(ls /backups/gluster/active/gluster-brick-${IDENTIFIERS[$i]} | wc -l)" <= 2 )); then
            # Does the backup one file exist
            if ! [ -f "/backups/gluster/active/gluster-brick-${IDENTIFIERS[$i]}/gluster-backup1.tar" ]; then
                tar -C ${PATHS[$i]}/.. -cvpf /backups/gluster/active/gluster-brick-${IDENTIFIERS[$i]}/gluster-backup1.tar "$(basename ${PATHS[$i]})"
                exit
            fi
            # Does the backup two file exist
            if ! [ -f "/backups/gluster/active/gluster-brick-${IDENTIFIERS[$i]}/gluster-backup2.tar" ]; then
                tar -C ${PATHS[$i]}/.. -cvpf /backups/gluster/active/gluster-brick-${IDENTIFIERS[$i]}/gluster-backup2.tar "$(basename "${PATHS[$i]}")"
                exit
            fi
    fi


    #https://superuser.com/questions/188240/how-to-verify-that-file2-is-newer-than-file1-in-bash

    # Replace the older of the two backups that we keep
    if [ "/backups/gluster/active/gluster-brick-${IDENTIFIERS[$i]}/gluster-backup2.tar" -nt "/backups/gluster/active/gluster-brick-${IDENTIFIERS[$i]}/gluster-backup1.tar" ]; then
        tar -C ${PATHS[$i]}/.. -cvpf /backups/gluster/active/gluster-brick-${IDENTIFIERS[$i]}/gluster-backup1.tar "$(basename ${PATHS[$i]})"

    else    
        tar -C ${PATHS[$i]}/.. -cvpf /backups/gluster/active/gluster-brick-${IDENTIFIERS[$i]}/gluster-backup2.tar "$(basename "${PATHS[$i]}")"
    fi
done
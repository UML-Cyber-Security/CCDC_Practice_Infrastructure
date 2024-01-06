# I (Matt) do not want to waste time on this, not that they are bad, but it will take time to understand everything. Time I do not have I.E do the easy stuff first

###################################################################################################
# The /tmp directory is a world-writable directory used for temporary storage by all users and some applications.
Configure /etc/fstab as appropriate. Example: tmpfs /tmp tmpfs defaults,rw,nosuid,nodev,noexec,relatime 0 0 or 
Run the following commands to enable systemd /tmp mounting: 
systemctl unmask tmp.mount 
systemctl enable tmp.mount 
Edit /etc/systemd/system/local-fs.target.wants/tmp.mount to configure the /tmp mount: [Mount] What=tmpfs Where=/tmp Type=tmpfs Options=mode=1777,strictatime,noexec,nodev,nosuid	

# Node The nodev mount option specifies that the filesystem cannot contain special devices.
Edit the /etc/fstab file and add nodev to the fourth field (mounting options) for the /tmp partition. See the fstab(5) manual page for more information. Run the following command to remount /tmp: # mount -o remount,nodev /tmp     OR      
OR
Edit /etc/systemd/system/local-fs.target.wants/tmp.mount to add nodev to the /tmp mount options:  [Mount]   Options=mode=1777,strictatime,noexec,nodev,nosuid 
Run the following command to restart the systemd daemon: #  systemctl daemon-reload	

# The nosuid mount option specifies that the filesystem cannot contain setuid files.
Edit the /etc/fstab file and add nosuid to the fourth field (mounting options) for the /tmp partition. See the fstab(5) manual page for more information. Run the following command to remount /tmp: # mount -o remount,nosuid /tmp       
OR
Edit /etc/systemd/system/local-fs.target.wants/tmp.mount to add nosuidto the /tmp mount options:
[Mount]  Options=mode=1777,strictatime,noexec,nodev,nosuid  
Run the following command to remount /tmp:
# mount -o remount,nosuid /tmp

# The noexec mount option specifies that the filesystem cannot contain executable binaries.
Edit the /etc/fstab file and add noexec to the fourth field (mounting options) for the /tmp partition. See the fstab(5) manual page for more information. Run the following command to remount /tmp: # mount -o remount,noexec /tmp      
 OR
 Edit /etc/systemd/system/local-fs.target.wants/tmp.mount to add noexec to the /tmp mount options: 
[Mount]  Options=mode=1777,strictatime,noexec,nodev,nosuid 
Run the following command to remount /tmp: # mount -o remount,noexec /tmp

# /dev/shm is a traditional shared memory concept. One program will create a memory portion, which other processes (if permitted) can access. Mounting tmpfs at /dev/shmis handled automatically by systemd.
Edit the /etc/fstab file and add nodev to the fourth field (mounting options) for the /dev/shm partition. See the fstab(5) manual page for more information. \
Run the following command to remount /dev/shm: # mount -o remount,nodev /dev/shm	

#The nodev mount option specifies that the filesystem cannot contain special devices.
Edit the /etc/fstab file and add nodev to the fourth field (mounting options) for the /dev/shm partition. See the fstab(5) manual page for more information. 
Run the following command to remount /dev/shm: # mount -o remount,nodev /dev/shm	

# The nosuid mount option specifies that the filesystem cannot contain setuid files.
Edit the /etc/fstab file and add nosuid to the fourth field (mounting options) for the /dev/shm partition. See the fstab(5) manual page for more information. 
Run the following command to remount /dev/shm: # mount -o remount,nosuid /dev/shm	

# The noexec mount option specifies that the filesystem cannot contain executable binaries.
Edit the /etc/fstab file and add noexec to the fourth field (mounting options) for the /dev/shm partition. See the fstab(5) manual page for more information. Run the following command to remount /dev/shm: # mount -o remount,noexec /dev/shm	

# The /var directory is used by daemons and other system services to temporarily store dynamic data. Some directories created by these processes may be world-writable.-- No
For new installations, during installationcreate a custom partition setup and specify a separate partition for /var. For systems that were previously installed, create a new partition and configure /etc/fstab as appropriate.	

# The /var/tmp directory is a world-writable directory used for temporary storage by all users and some applications. -- No
For new installations, during installation create a custom partition setup and specify a separate partition for /var/tmp. For systems that were previously installed, create a new partition and configure /etc/fstab as appropriate.	

# The nodev mount option specifies that the filesystem cannot contain special devices.
Edit the /etc/fstab file and add nodev to the fourth field (mounting options) for the /var/tmp partition. See the fstab(5) manual page for more information. Run the following command to remount /var/tmp : # mount -o remount,nodev /var/tmp	

# The nosuid mount option specifies that the filesystem cannot contain setuid files.
Edit the /etc/fstab file and add nosuid to the fourth field (mounting options) for the /var/tmp partition. See the fstab(5) manual page for more information. Run the following command to remount /var/tmp: # mount -o remount,nosuid /var/tmp	
# The noexec mount option specifies that the filesystem cannot contain executable binaries.
Edit the /etc/fstab file and add noexec to the fourth field (mounting options) for the /var/tmp partition. See the fstab(5) manual page for more information. Run the following command to remount /var/tmp: # mount -o remount,noexec /var/tmp	
# The /var/log directory is used by system services to store log data.
For new installations, during installation create a custom partition setup and specify a separate partition for /var/log.	
# The auditing daemon, auditd, stores log data in the /var/log/audit directory.
For new installations, during installation create a custom partition setup and specify a separate partition for /var/log/audit. For systems that were previously installed, create a new partition and configure /etc/fstab as appropriate.	
# The /home directory is used to support disk storage needs of local users.
For new installations, during installation create a custom partition setup and specify a separate partition for /home. For systems that were previously installed, create a new partition and configure /etc/fstab as appropriate.	
# The nodev mount option specifies that the filesystem cannot contain special devices.
Edit the /etc/fstab file and add nodev to the fourth field (mounting options) for the /home partition. See the fstab(5) manual page for more information. # mount -o remount,nodev /home	


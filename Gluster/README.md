# Gluster
Information on Gluster as utilized in the practice setup.


## Gluster brick created from Files
The following entry is not utilized with the Proxmox Instance. This is based on the article [here](https://www.jamescoyle.net/how-to/2096-use-a-file-as-a-linux-block-device), excluding the loop device steps. 

In doing this we can create a point to create a brick from, *without* partitioning the system. Our issue with PFSense is that LVM is utilized so this is not feasible. 


```
# Make file to fill with zero (Be the "device"
sudo touch /tempffs
# Make mountpoint
sudo mkdir/gluster_brick

# inputfile of the device that always outputs zero (I think) to some file in the root 
# This will create a file of $1 (replace $1 with something) Gigabytes
sudo dd if=/dev/zero of=/tempffs bs=1G count=$1

# Format the file with the ext4 format
sudo mkfs.ext4 /tempffs

# Add to fstab
sudo echo "/tempffs /gluster_brick ext4 defaults 0 2" | sudo tee -a /etc/fstab

# Check if it mounts properly 
sudo mount -a
lsblk
```
## MORE
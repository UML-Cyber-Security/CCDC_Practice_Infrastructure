# CEPH
This is a late addition to the lineup of Distributed Filesystems we explored. So this document will simply contain a set of links for reference and some commands.


## References
* https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/
* https://snapcraft.io/microceph
* https://canonical-microceph.readthedocs-hosted.com/en/latest/tutorial/multi-node/

## Notes 
Distributed Storage but more complicated than NFS.

NFS is a single server, if it goes down, you lose everything. CEPH is a distributed file system, is more advanced, and is mature. It shards the files and whatnot.

You can easily segment file storage with blocks (Arbitrary block devices as disks), useful for things like K8s, you can setup CEPHS to be an object-store rather than files directly.

There are access controls built in directly; seems like an amazing tool.

We generally only want to replicate a max of 3 times, over this there are major performance issues.

#### Setup
**4-Systems**: You just need multiple systems, they **need** differnet hostnames. This is because CEPH uses certificate-based authentication

**Setup**: Ubuntu founders created  [microceph](https://canonical-microceph.readthedocs-hosted.com/en/reef-stable/) a tool that can be used to set up a CEPH cluster; the original tool is quite painful.

* **install** `sudo snap install microceph`
    * snap will mount all of the packages that its installs on separate sandbox environments; creates a sandboxed microceph installation
    * This installs all the packages needed for CEPH, in addition to useful packages for CEPH integration and management

* **bootstrap***: `sudo microceph cluster bootstrap`
* *verify*: `sudo microceph status`
    * mon - monitor state resolution
    * mng - manger
    * mds - Something

* **Get Join Token***: On **Cluster** `sudo microceph cluster add <Hostname>`
    * Output's a join token

* **Adding Node**: On **Target Machine** `sudo microceph cluster join <TOKEN>`

If you run `sudo microceph status`, you will now see there are multiple systems in the CEPH cluster, but you will see there are no disks.


* **Adding Physical Disk**: If we have a **Seperate Disk** use `sudo microceph disk add --wipe`, we will not be able to add additional disks

* **Adding Loop Device**: We can make a file into a disk!
    * `sudo dd if=/dev/zero of=./filesystem.img bs=1GB count=5 status=progress`: This creates the block of storage we would like to make into a block device
        * `dd`: Block copy
        * `if=/dev/zero`: Input file, in this case it will be all 0
        * `of=./filesystem.img`: Output file
        * `bs=1GB`: Block size of 1GB
        * `count=5`: Copy 5 Blocks
        * `status=progress`: Print progress status
    * `sudo mkfs.ext4 filesystem.img`:Turns the filesystem.img into a ext4 filesystem
    * `sudo mount filesystem.img /mnt/`: Mounts the partition
    * `lsblk`: List blocks

* **CEPH can do this for us**: `sudo microceph disk add loop,5G,1`
    * `loop`: Create a loop disk
    * `5G`: 5GB loop device
    * `1`: Create 1 disk

* **More Info**: `sudo microceph.ceph status`
    * we will only get HEALTH_OK when there are enough systems and disks
    * We can see more information about the data. The space available is the total you have, if you configure replication, this may not be reflective of how much you can store.

#### Block Storage Creation

* *Create a pool*: `sudo microceph.ceph osd pool create <NAME>`, This create a *uninitialized* pool
    * `osd`: Like the disks we have created
    * `pool`: pool commands
    * `create <NAME>`: Create a pool of NAME

* *Initialize*: `sudo microceph.rbd pool init <NAME>`, initialize the pool
    * rbd stand for redis block device

* **Access**: `sudo miroceph.auth ls` for access keys or `sudo var/snap/microceph/<Number>/conf/ceph.keyring` for complete admin access
    * `sudo find / -name 'ceph.keyring'`
* **Create New Disk**: `sudo microceph.rbd create <DiskName> --size 1GB --image-feature layering -k <Keyring File> -p <POOL>`, creates a ready to use disk

## Mounting
* **Install**: `sudo apt install ceph-common`
* **Status**: `sudo ceph status`, There is nothing
* **Configure**:
    * Copy `/etc/ceph/conf` from a ceph machine to the new one at `/etc/ceph/conf`
    * Copy the keyring `ceph.keyring` from a clustered machine to `/etc/ceph/ceph.keyring`
    * Change the keyring permissions `sudo chmod 640 ceph.keyring`
    * Change ownership if not root `sudo chown root root ceph.keyring`
* **Check Status**: `Sudo ceph status`, now you should see something
* **Create a Directory for Mount**: `sudo mkdir /disk-name`
* **Config RDB Map**: `vim /etc/ceph/rdbmap`
  * Add entry `Pool-name/Disk-Name id=User,keyring=path-to-keyring`
* **Look for new Device**: `ls -la /dev/rdb/Pool-Name/Disk-Name`
* **First Use - Format**: `sudo mkfs.ext4 /dev/rdb/Pool-Name/Disk-Name`
* **Mount**: `sudo mount -t ext4 /dev/rdb/Pool-Name/Disk-Name`
    * You can add it to the FSTAB file so it will mount automatically

#### Setup Web Interface
Three commands to setup a web dashboard.
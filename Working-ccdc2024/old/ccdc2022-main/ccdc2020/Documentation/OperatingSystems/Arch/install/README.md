# Arch Linux VM Installation on Virtual Box

(Adapted from: https://averagelinuxuser.com/a-step-by-step-arch-linux-installation-guide/#partition)

(Download this first) ISO: http://mirror.rackspace.com/archlinux/iso/2019.10.01/archlinux-2019.10.01-x86_64.iso

# Verify installation media
This section is critical. If the checksums do not match, there is a high probability of critical failures down the road.

`wget` is not necessary. The following files can also be downloaded by visiting the URLs with a browser of your choice:

`wget http://archlinux.uk.mirror.allworldit.com/archlinux/iso/2019.10.01/md5sums.txt`

`wget http://archlinux.uk.mirror.allworldit.com/archlinux/iso/2019.10.01/sha1sums.txt`

Now that you have the checksum files, validate your `.iso` with these commands:

`sha1sum -c sha1sums.txt`

`md5sum -c md5sums.txt`

Look for this output in both commands (It will complain about some files not found, it contains checksums for more than just the `.iso`):

`archlinux-2019.10.01-x86_64.iso: OK`


Windows does not have a built in utility to verify hashes, use the following powershell command:

`Get-FileHash <iso name> -Algorithm MD5`

`Get-FileHash <iso name> -Algorithm SHA1`

In this case, just visually inspect the hash with the hash in the text file unless you'd like to write a powershell script.


If these hashes do not match, **STOP**. The installation file is compromised/corrupted. 

# VM SETUP AND BOOT

- **Open up VirtualBox**
- **Select New** select tools from the toolbar above the welcome message. It'll bring up the image creation dialog.
- **Name: `Arch`**
- **Ensure version says `Arch Linux (64-bit)`** (Auto populates if you named the VM `Arch`)
- **Memory size: 1024 MB (1GB)**
- **Select `Create a virtual hard disk now`**
- **Select `VDI (VirtualBox Disk Image)`** 
- **Select `Dynamically allocated`**
- **Set** the virtual hard disk size. Default is `8GB`, you probably won't need more than `20GB`.
- **Click create** The basic image will be created and you'll see an entry for it appear on the left side of the main Virtualbox window.
- **Right click the image** from the left menu
- **Select `Settings`** from the pop up menu
- **Navigate to `Storage`** in the left menu
- **Select `Empty`** from the `Controller: IDE` drop down
- **Click the blue disk** on the left, under `Attributes` next to `Optical Drive` (Ensure `IDE Secondary Master` is selected in the `Optical Drive` drop down)
- Search for and **select the ISO you downloaded earlier**
- **Click OK** at the bottom 
- **Select the VM so it's highlighted and click start** in the top toolbar
- **Select `Boot Arch Linux (x86_64)`** with your up and down arrows (first option, probably pre selected) and press enter
- We will be running a lot of commands now-- I will provide a brief explanationm, but if you want to know more (and you should), you can always run `man <some command>`. When you are finished reading, press `q` (this is obviously listed at the bottom of man, but you know, assumptions are bad)
- **Run `ping google.com -c 2`** to confirm internet connection
  - This command pings google twice
  - Research yourself, run `man ping`
  - If the reply says something like `[some number] bytes from [some address] [other stuff]` that means `google.com` responded to your ping
  - If you don't have connection--stop, ask for help

# Snapshots

From this point forward, everytime you end a section, you may want to make a snapshot to save your progress in case something goes wrong. If you feel comfortable with the procedure, you may skip this step.
This is a good time to make one.

To make a snapshot do the following:
- **Select `Machine`** in the top Virtualbox toolbar
- **Select `Take snapshot...`** from the menu
- **Enter a description** that describes what this snapshot is about. You should make it descriptive in the context of what you're doing. For our purposes, something like `After disk partitioning` would let you know you finished the disk partioning section
- **Save**
- At any point you can restore a snapshot by selecting `Snapshots` from the VM menu view, which you open by clicking the three lines on the right of a highlighted VM (there will three options:  Details, Snapshots, Logs. Select the snapshot you want and hit run at the top

# Disk partitioning and encryption

- **Run `fdisk -l`**
  - Lists the partition tables for the default devices (our hard drive!)
  - Note the first disk (likely the first disk, who knows if this is a constant ordering). It's probably named `/dev/sda`, and will be the same size as you set in the VM setup.   This is the device name of our hard drive and the one we need to partition. We listed the devices so we know which one to partition. If you had a ton of disks it would be really important that you don't try to partition the wrong disk.
  - `/dev/sda` will be used for the rest of the setup. Replace it with the name you found if different.
- **Run `fdisk /dev/sda`**
  - This will give you an interactive fdisk tool to work with `/dev/sda`
- **Type and enter `n`** (new partition, which will be our /boot)
- **Type and enter `p`** (primary parition), or just hit enter if it's the devault
- **Type and enter `1`** (first partition)
- **Hit enter** for the default value `2048` (beginning of the available disk)
- **Type and enter `+512M`**
- **Type and enter `n`** (This will be our swap, which we don't really need, but it's nice and has performance benefits)
- **Type and enter `p`**
- **Type and enter `2`** (second partiton)
- **Hit enter** for the default value (beginning of the next available sector, immedaitely after what we paritioned earlier). Default value will vary between installations.
- **Type and enter `+2GB`**
- **Type and enter `t`** to change partition type.
- **Type and enter `2`** to select the second partition
- **Type and enter `82`** (This is the hex code for linux swap, which is what parition 2 is supposed to be)
- **Type and enter `n`** (This will be for our `/`, which is the root partition. Basically we're dumping everything not for swap or booting into this partition)
- **Type and enter `p`**
- **Type and enter `3`**
- **Hit enter** for the default (Again, this is the start of the next available space)
- **Hit enter** for the default (This time, we're taking what ever is left. Should be 12.7GB if you're using the 15GB size and partitoned a 500MB `/boot` and 2GB `/swap`)
- **Type and enter `p`** to view what you've partioned. You should have:
```
  /dev/sda1 ~stuff~ 500M  83  Linux
  /dev/sda2 ~stuff~ 1.9G  82  Linux swap / Solaris
  /dev/sda3 ~stuff~ 12.7G 83  Linux
```
- **Type and enter `w`** to write the `/dev/sda` disk when you're positive things are good

## Encrypting `/root`

Skip to `Building filesystems` if encryption is not required.

Run this to create a version 1 LUKS header for our soon-to-be encrypted partition:

`cryptsetup --verbose --cipher aes-xts-plain64 --key-size 512 --hash sha512 --use-random luksFormat --type luks1 /dev/sda3`

Only all uppercase `YES` will be accepted for the confirmation.

You will be prompted for a password. Losing access to this password means losing access to your data.

Now we will create a mapping between the name `root` and our encrypted volume:

`cryptsetup open --type luks /dev/sda3 root`

The name `root` could be replaced with anything you'd like, just makes sense for this particular use.

You'll need to enter the password you just created to finish opening the partition.

**IMPORTANT:**
- For all future steps, replace `/dev/sda3`, with `/dev/mapper/root`

## Building filesystems

Run the following commands to build the corresponding filesystems in the newly created partitions.

- `mkfs.ext2 /dev/sda1`

- `mkswap /dev/sda2`

- `mkfs.ext4 /dev/sda3`


## Mounting partitions and enabling swap

Just because we have this disk nicely partitioned with a filesystem defined doesn't mean we have access to read/write from the memory-- don't forget we're still working from the ISO. Mounting is the process of making the disk accessible.
  
- We only have one working partition, `/dev/sda3`, thus...
-   **Run `mount /dev/sda3 /mnt `**
  - This makes the data from `/dev/sda3` available at `/mnt`. It's like symbolic link. Whatever we do in `/mnt` will actually be happening to `/dev/sda3`
- **Run `swapon /dev/sda2`** (You have to actually turn the swap on, which is what we're doing with this command)

# Installing base packages, kernel, and basic firmware

- **Run `pacstrap /mnt base linux linux-firmware`**
  - pacstrap is a script that install the kernel and basic tools on `/mnt`, which is really `/dev/sda3`
  - There are other packages and stuff, but this fairly minimalist in what's enabled by default
  - This will take a while, it's the longest part of the install. ~5-10min, Internet dependent 
  
## Generating filesystem table (required for mounting partitions on boot)

- **Run `genfstab /mnt >> /mnt/etc/fstab`**
  - We used our first redirection! Basically, the output from `genfstab` is appended to file at `/mnt/etc/fstab`
  - Super useful, don't forget this

## Extra steps for encrypted systems

We're setting up our main partition to be encrypted, so there won't be anything to boot from without decrypting it first.

- Run `cryptsetup luksDump /dev/sda3 | grep UUID >> /mnt/etc/crypttab` to dump the drive's UUID into `crypttab`. This is like `fstab` but for encrypted drives.
- Open `/etc/crypttab` with your choice of editor and modify the last line to look like this (tab vs space doesn't matter):
  - `root  UUID="9181c09b-93e0-492d-a2db-7826d36c69fd"  none  luks,timeout=180`


## Chrooting and package installation

- **Run `arch-chroot /mnt`**
  - We were working from the ISO, but now we're interfacing with `/dev/sda3`, which again, is mounted at `/mnt`
  - You can see the prompt changed. It's critical you know where you are at all times, so pay attention.
  - Also, you're root at the moment. This is probably the only time it's a good idea to work as `root`. Later we'll make a user with sudo permissions, but right now that's silly and a pain
- **`pacman -Syu nano netctl dhcpcd grub sudo`'**
  - select `openresolv` if prompted, hit `y` at the confirmation prompt
  - When we reboot the system, we lose the networking configured by the `.iso` lose internet access. We should get our basic utilities before rebooting.
  - I prefer nano, so the rest of the text editting will be done with `nano`, but you can replace nano with `vi` or any editor of your choosing at any time.
  - `netctl` and `dhcpcd` are needed for the next section on networking
  - `grub` is our bootloader of choice, so we're just installing it now
  - `sudo` is used to allow normal users to run commands with root privilleges-- it's a security necessity 
- Info on `pacman`:
  - `pacman` is the package manager for arch. The `-S` flag means sync (for downloading stuff), `-Syu` adds two options to sync, namely u= sysupgrade, and y= refresh. Sysupgrade updates all packages that need updates and y gets the newest package database to know new stuff is available.
  - This is a tricky thing to do constantly and a little philosophical. Arch is bleeding edge, so if you do a sysupgrade everytime you download something, you're run the possibility of breaking your system. There's no concept of a release in arch, so when thigs are upgraded they get tested, but it's not intensive. Stuff is realized asap. This also means security packages are immedaitely available.
    
## Configuring networking
 
- **run `cp /etc/netctl/examples/ethernet-dhcp /etc/netctl`**
- `netctl` works through profiles-- `ethernet-dhcp` is one for a wired connection, where an ip is provided through dhcp
- **run `ip a`** and note the name of the interface that's not the loopback (`lo`)
- **run `nano /etc/netctl/ethernet-dhcp`**
  - This is our first time using `nano`
  - Make edits however you need
  - To save back to the same file you editted
    - **Type `ctrl-x`**
    - **Type `y`**
    - **Hit enter**
- **Replace whatever is in front of `Interface=` with the name of the interface you found a few seconds ago, save and close**
- **run `echo "nameserver 8.8.8.8" >> /etc/resolv.conf`**
  - Setting DNS to google's DNS server
- **run `echo "<PC_name>" > /etc/hostname`, replacing `<PC_name>` with an identifer for that machine**

  
## Configuring locales

- **run `nano /etc/locale.gen`**
- **Type `ctrl-w`**
  - ctrl-w is the search utility in nano
  - If you need to search for the next appearance of a string, just type ctrl-w and enter-- your previous query will be pre-filled
- **Type `#en_US.U`** which is the minimal string to find the entry we want
- **Hit `enter`**
- **Remove the `#` in front of `#en_US.UTF-8 UTF-8`, save and close**
- **run `locale-gen`**
- **run `echo "LANG=en_US.UTF-8"  > /etc/locale.conf`** (These internal quotes around `LANG...` are in the command, type those too`
  - If you're paying attention, you'll notice this is similar to the `>>` we used earlier this time. Big difference though. `>` replaces the contents with whatever you echoed into it. The only thing in `/etc/locale.conf` is now `LANG=en_US.UTF-8`. Run `cat /etc/locale.conf` to confirm this for yourself
  
## Configuring time

- **run `ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime`** to set the correct time zone
- **run `hwclock --systohc`** to set the hardware clock

## Configuring users

- **run `passwd` and set a strong password**
  - As you are currently `root`, this will set the root password. We will disable login with root later, but in the event you goof your personal user, you want root around until you're ready
  - Linux doesn't echo the password back, so as you type you won't see anything. Just type the password, hit enter, type it again, and it will tell you if it was successful or not
- **run `useradd -m -s /bin/bash <user_name>`** where user_name is the name of the user you want to make
- **run `passwd <user_name>`** where user_name is the name of the user you just made
- **run `export EDITOR=nano`** to tell visudo to use nano as the editor
- **run `visudo /etc/sudoers`** Visudo ensures the sudoer file doesn't get messed up, so it's critical we edit the sudoer file with visudo
- **search for `root` with `ctrl-w`** (note the space after `root`)
- **type `ctrl-k`**
  - This is a nano short cut to cut a line
- **type `ctrl-u` twice**
  - This is a nano short cut to paste a line that was cut-- we want the same thing for root and your user, so we paste the line twice
- **Replace `root` on the second line with <user_name>`** where user_name is the name of the user you created
  
## Configuring GRUB and finalizing install

**IF ENCRYPTED**: Run  `echo "GRUB_ENABLE_CRYPTODISK=y >> /etc/default/grub` to enable booting from encrypted drives.
- **run `grub-install /dev/sda`**
- **run `grub-mkconfig -o /boot/grub/grub.cfg`** 
  - Read this to know what's going on: https://unix.stackexchange.com/questions/305345/where-is-grub-installed-and-do-i-need-a-new-one-for-a-separate-linux-installatio
- **run `exit`** to go back to the iso
- **run `umount -R /mnt`** this is good practice-- unmount the stuff you mounted. It does a lot of things, but the most important is that ensures nothing is being synced up in memory. It's kind of the same (if not exactly the same) as unmounting your flash drive
- We now have an install ready, bboout to avoid booting from the ISO again, because we don't necesarrily know the what order the machine will attempt to boot in, we need to remove the installation media
- **Select `File` from the top menu**
- **Select `Close`**
- **Select `Power off the machine` and hit OK (ensure you don't have any restore snapshot options selected)**
- **Right click the VM an select `settings`**
- **Select Storage**
- **Select `archlinux-...`** under `Controller: IDE`
- **Select the blue disk** on the right again
- **Select `Remove disk from Virtual Drive` with the disk with a red x and hit OK**

# After reboot

## Enable networking
- **run `sudo netctl start`**
- **run `sudo netctl enable`**

## System hardening
Lock root login:

- **`sudo passwd -l root`**

Install a chroot jail:
- **`sudo pacman -S firejail`**
- Execute programs in the jail by prepending the command with `firejail`
  - eg: `firejail bash`

## OTHER (OPTIONAL) --- WIP, not stable

- If you want a full screen terminal, you need virtualbox guest additions (or use the `host+c` binding for scaled fullscreen)
- **run `pacman -Syu virtualbox-guest-utils-nox`**
  - If you read the wiki here: https://wiki.archlinux.org/index.php/VirtualBox#Install_the_Guest_Additions, we need the nox version because we don't need x support (x is like a framework for installing GUIs)
- **Select Virtualbox-guest-modules-arch` at the prompt** (mine was number 2, but the default was 1 so watch out)
  - We need the arch version because earlier we installed the default linux kernel
- Enter `y` at the confirmation prompt2
- **run `sudo systemctl enable vboxservice.service`** to tell systemctl to start vboxservice (the guest additions) on boot

## ENJOY

- Boot up the VM
- You can select arch at the grub screen (Will be autoselected after 5 secs), but should otherwise get a prompt that says `arch login`
- Login with your user and your password
- Have a party
- ???
- Profit

# Securing Apache

secureApache.sh - Secures the default apache2 server
  
  -Takes the server IP as an argument
  
  -Creates and installs a self signed sertificate and key
  
  -Forces http to redirect https
  
  -Uses TLS 1.3
 
  https://httpd.apache.org/docs/2.4/ssl/ssl_howto.html#page-header
  
  https://tools.ietf.org/html/rfc8446#section-1
  
  https://tecadmin.net/install-lets-encrypt-create-ssl-ubuntu/
  
  https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-apache-in-ubuntu-18-04
 
  http://www.compciv.org/topics/bash/variables-and-substitution/
  
  https://ayesh.me/TLSv1.3-Apache

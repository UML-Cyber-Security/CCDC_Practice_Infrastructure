# CentOS install on VirtualBox VM

## Preparation
Download the following files:

`mirrors.mit.edu/centos/7.7.1908/isos/x86_64/CentOS-7-x86_64-DVD-1908.iso`

`http://mirrors.mit.edu/centos/7.7.1908/isos/x86_64/sha256sum.txt`

## Verify the `.iso`:

`sha256sum -c sha256sum.txt`

should produce the output:
`CentOS-7-x86_64-DVD-1908.iso: OK`

Windows does not have a built in utility to verify hashes, use the following powershell command:

`Get-FileHash <iso name> -Algorithm SHA256`


There will be some errors since not all of the files from the checksum file are included. That is okay as long as the `OK` is there for the centOS .iso we're using

If checksums do not match, the file cannot be trusted.

# Installation

## Boot the live image

If using VirtualBox:
- `Click` **`New`** on the VirtualBox toolbar
- Name it, ensure `Version` is `RedHat (64-bit)`.
- Set `Machine Folder` to a drive that has room for the VM.
- **`Next`**
- `2048 MB` memory, **`Next`**.
- `Create a virtual hard disk now`, **`Create`**.
- In the `Create Virtual Hard Disk` dialog, select `VDI`, **`Next`**.
- Select `Dynamically allocated`, **`Next`**
- Allocate at least`20 GB` for the drive, **`Create`**.
- `Click` **`Start`** on the VirtualBox toolbar.
- `Click` on the folder icon next to the dropdown bar in the `Select start-up disk` dialog, **`Open`**
- **`Start`**
  
## Live installer

- Wait for the bootloader to initialize.

- Press `enter` to test media and continue.
  - Wait for the installer to initialize
- Language is `English (US)` by default, **`Continue`**
  - You'll be brought to the main installation menu
- Click on `Software Selection`
  - Select `Infrastructure Server` Base environment and the `Security Tools` and `System Administration Tools` add-ons. Click **`Done`**
- Click on `Installation Destination`
  - Check the `I will configure partitioning` radio button
  - Check the `Encrypt my data` checkbox on the bottom
  - Click **`Done`**. You'll be brought to the `Manual Partitioning` menu
    - Create the mount points automatically with the button on the first bullet point
      - `centos-root` will use the rest of the remaining disk by default. Shrink that partition and use the freed space to make a `/var` partition. Click **`Done`**
    - You'll be asked to enter an encryption passphrase.
      - Losing this means losing access to the system.

- Begin the installation
- Set a root password and create a user
  - If you want your user to be an admin check `Make this user administrator` under the `User name` field

- Click on `Network & Host Name`
  - Check the toggle button for "Ethernet ([Name_of_your_interface])" so that it says on (Interface name is likely enp0s3)
  - Click **Done**
  
Log in as the user created during installation.

# Post-Installation 

## Networking

Once logged in, run `dhclient`.
That's it.

## Guest Additions
Before you get started, install the kernel headers.
Just use tab-completion after you type `kernel-devel` to get the right version.

`yum install gcc gcc-c++ make kernel-devel-3.10.0-1062.4.3.el7.x86_64`

First, check what version of Virtualbox you're using.
You should match the guest additions to your version.

In my case, I'll download version `6.0.8`.

`wget https://download.virtualbox.org/virtualbox/6.0.8/VBoxGuestAdditions_6.0.8.iso`

`mkdir /media/iso`

`mount -o loop ./VBoxGuestAdditions_6.0.8.iso /media/iso`

`bash /media/iso/VBoxLinuxAdditions.run --nox11`

You may get a message along these lines:


`VirtualBox Guest Additions: Look at /var/log/vboxadd-setup.log to find out what
went wrong`

It's most likely just warning that x11 was skipped. Woudln't hurt to double check with `cat /var/log/vboxadd-setup.log`

`umount /media/iso`

`reboot`

## Shared folders
\*Guest additions required 

- Go to the `settings` menu for the VM.
- In the `Shared Folders` tab, click on the the folder with the green `+` button.
- Click on the `Folder Path` dropdown and select `Other` to bring up a dialog to select the folder you'd like to share.
- Check the `Auto-mount` and `Make Permanent` checkboxes
- Click `OK`

From now on, you'll be able to find that folder in `/media/sf_FOLDERNAME` inside of the VM.





## Hardening: Tips from the CentOS wiki

[Link](https://wiki.centos.org/HowTos/OS_Protection)


### Disable non-console root

- Run the following commands:

```bash
echo "tty1" > /etc/securetty
chmod 700 /root
```

- We are no longer able to login as root except from the local console
- To execute privileged actions, one must use `sudo`
  - `sudo` has much better built-in login capabilities


### Password Paranoia

- Run the following command to use a stronger password protection algorithm:
  - `authconfig --passalgo=sha512 --update`
- This is probably overkill, but to quote the wiki, it "keeps the people wearing tinfoil hats happy"


### Default Umask

- Warning: This is likely to cause some misunderstandings between our team when sharing files
- Run the following commands to forbid all file permissions to anyone but the creator of a file by default:
  - `sed -e 's/umask\W*[[:digit:]]\+.*/umask 077/g' -i /etc/bashrc`
  - `sed -e 's/umask\W*[[:digit:]]\+.*/umask 077/g' -i /etc/csh.cshrc`

### WiFi

- This should be disabled unless needed
- Recommended Method:
  - blacklist wireless drivers
  - Script:
  ```bash
  for i in $(find /lib/modules/`uname -r`/kernel/drivers/net/wireless -name "*.ko" -type f)
  do
  	echo blacklist $i >> /etc/modprobe.d/blacklist-wireless
  done
  ```

### IPTables

- The default ruleset is relatively lenient
- We should block all traffic unless it is explicitly allowed
- They provide an example `/etc/sysconfig/iptables`:

```iptables
#Drop anything we aren't explicitly allowing. All outbound traffic is okay
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]
:RH-Firewall-1-INPUT - [0:0]
-A INPUT -j RH-Firewall-1-INPUT
-A FORWARD -j RH-Firewall-1-INPUT
-A RH-Firewall-1-INPUT -i lo -j ACCEPT
-A RH-Firewall-1-INPUT -p icmp --icmp-type echo-reply -j ACCEPT
-A RH-Firewall-1-INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
-A RH-Firewall-1-INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
# Accept Pings
-A RH-Firewall-1-INPUT -p icmp --icmp-type echo-request -j ACCEPT
# Log anything on eth0 claiming it's from a local or non-routable network
# If you're using one of these local networks, remove it from the list below
-A INPUT -i eth0 -s 10.0.0.0/8 -j LOG --log-prefix "IP DROP SPOOF A: "
-A INPUT -i eth0 -s 172.16.0.0/12 -j LOG --log-prefix "IP DROP SPOOF B: "
-A INPUT -i eth0 -s 192.168.0.0/16 -j LOG --log-prefix "IP DROP SPOOF C: "
-A INPUT -i eth0 -s 224.0.0.0/4 -j LOG --log-prefix "IP DROP MULTICAST D: "
-A INPUT -i eth0 -s 240.0.0.0/5 -j LOG --log-prefix "IP DROP SPOOF E: "
-A INPUT -i eth0 -d 127.0.0.0/8 -j LOG --log-prefix "IP DROP LOOPBACK: "
# Accept any established connections
-A RH-Firewall-1-INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# Accept ssh traffic. Restrict this to known ips if possible.
-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
#Log and drop everything else
-A RH-Firewall-1-INPUT -j LOG
-A RH-Firewall-1-INPUT -j DROP
COMMIT
```

- If we even want to block pings, we can change the last like like so:

```iptables
-A RH-Firewall-1-INPUT -j REJECT --reject-with icmp-host-prohibited
```

### Aide (Advanced Intrustion Detection Environment)

- This is a file integrity checking tool for intrusion deteciton
- The Arch Wiki has a [page](https://wiki.archlinux.org/index.php/AIDE) on it
- It is generally run regularly as a `cron` job
- The tool comes with CentOS


### TODO 
- Auditd

- SELinux

- Get networking up by default


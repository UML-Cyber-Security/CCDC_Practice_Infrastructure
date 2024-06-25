# Proxmox Setup

Read the Latex PDF instead! This one is not as good as that one

Note that the Latex PDF has Hrefs and stuff, but you have to download it as a pdf to use them. (They do not display in the github viewer)

Note: You can not use many of proxmox's features (i.e. shut it down without going through the console) without the guest agent installed. Just to save you from mashing the "shutdown" button and wondering why it doesn't work. 

## Step 1: Getting the correct ISOs to Proxmox
Upload the windows server 2019 iso to proxmox. You can get the iso from the windows server website:
http://www.microsoft.com/en-us/evalcenter/download-windows-server-2019

You should also get these virtIO drivers from Fedora. The Fedora one has a guest agent by default, which displays the IP address in the summary tab. Apparently it also runs faster because of “paravirtualization”
https://pve.proxmox.com/wiki/Windows_VirtIO_Drivers#Windows_OS_Support
https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/

## Step 2: Getting the VM
A video of some guy doing it with no words:
https://www.youtube.com/watch?v=lwORpWEHiDE&t=5m

The important settings are:
OS -> Type: Microsoft Windows, Version: 10/2016/2019
System -> SCSI Controller: VirtIO SCSI Single, QEMU Agent checked
Disks -> Bus/Device: SCSI
Memory -> 4096 B of RAM
Cache to write-back cache

After creating this VM, click it and go to the “Hardware” menu in Proxmox. Click “add CD/DVD” and click the virtIO.iso file you uploaded.

## Step 3: Making simple changes
Power on the VM and log into it via the console

2019 Standard Evaluation (Desktop Experience)

Complete the installation. Select “Windows Desktop” and “Advanced Installation”. (idk why to select advanced installation, but the other one didn’t work)

In advanced installation, select the virtIO driver you added previously
To send a Ctrl+Alt+Delete to the machine, you have to find the button in the proxmox console interface (it is in an expandable menu on the left)

## Step 4: Making a template
Log into the machine and set it up with the Guest Agent, Firefox, and RDP (at the bare minimum). If you want any other configurations, put them onto the machine (e.g. you can have the machine with the DC setup as its DNS to avoid having to manually configure this every time)

### Setting up the Guest Agent
“In the Windows VM, open the File Explorer and navigate to the VirtIO driver ISO. Open the “guest-agent” folder and double-click on the “qemu-ga-x86_64.msi” file to run the installer” -Bing

### Installing Firefox (from powershell as IE sucks)
This saves the firefox.exe file to your desktop
Invoke-WebRequest -Uri "https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win64&lang=en-US" -OutFile "$HOME\Desktop\firefox.msi"

You can modify it slightly if you want to download the .exe file insead of the .msi file

## Step 5: Using the template
In proxmox, power off the machine. Then right click it and click "make a template". Boom. Now you can clone it to your heart's content.


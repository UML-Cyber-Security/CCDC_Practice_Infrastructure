#Installing Promox + Infrastructure Specific Details

Author: 
    Luke 
    Chisom (Ask me anything, don't bother Luke)

## Table of Contents
* [Steps](#steps) 
* [References](#references)



## Steps

1. Install the latest (or of your choice) version of Proxmox in the form of an *.iso* file from the following site
    https://www.proxmox.com/en/downloads

2. Download an application called Etcher (see Reference 1.) which can create a bootable USB using the iso file
    Etcher allows you to configure/write images&iso files to portable storage media ie. USB, CDs

3. Plug a USB into the computer to which Etcher & the iso is downloaded to (not proxmox computer), and use Etcher to create a bootable USB. (See Reference 2.)

4. Navigate to the computer you want to install proxmox on and boot it with the USB.
    - This will involve the BIOS menu on the target computer.
    - Make the USB the first target of the boot sequence in the BIS menus.
    - Hit exit & the target computer should boot from the USB with the Proxmox *.iso* file.

5. As the computer is starting. When prompted with what disk you want to select make sure NOT to max out the disk as it will not allow to install (For our infrastructure we limited proxmox to 100 gb to the chosen disk)
 - reserve space for installation media and any other programs that will be need on the target machine

6. Set up the Promox instance's credentials

### Note: - Error Msg. 
    Once you hit install if you have an error in which one of the packages doesn't install you will have to reinstall the *iso* as it didn't get mounted on the bootable USB correctly or didn't install correctly from the website. 

## References
1. https://etcher.balena.io/ - Site to download Etcher
2. https://etcher.download/ - How To Make A Bootable USB Drive With Etcher
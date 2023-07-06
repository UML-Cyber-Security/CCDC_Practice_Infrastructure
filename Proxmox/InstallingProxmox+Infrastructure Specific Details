#Installing Promox + Infrastructure Specific Details

Author: 
    Luke 
    Chisom(Don't ask me anything, go bother Luke)

## Table of Contents
    - [Steps](#steps) 
    - [References](#references)



## Steps

1. Install latest (or of your choice) version of Proxmox in the form of an .iso file from the following site
    https://www.proxmox.com/en/downloads

2. Download an application called Etcher (see Reference 1.) which can create a bootable USB using the iso file
    Etcher allows you to configure/write images&iso files to portable storage media ie. USB, CDs

3. Plug the USB into the computer to which Etcher & the iso is downloaded to (not proxmox computer), and use Etcher to create a bootable USB. (See Reference 2.)

4. Navigate to the computer you want to install proxmox on and boot it with the usb.
    - This will likely mean navigating to the bios menu on the target computer.
    - Make it first in the boot sequence in the bios menu
    - Hit exit & the target computer should boot from the inserted media

5. As the computer is starting. When prompted with what disk you want to select make sure NOT to max out the disk as it will not allow to install (For our infrastructure we limited proxmox to 100 gb to the chosen disk)
 - reserve space for installation media and any other programs that will be need on the target machine

6. Set up the computer credentials

### Note: - Error Msg. 
    Once you hit install and you have an error in which one of the packages doesn't install you will have to reinstall the iso as it didn't get mounted on the bootable USB correctly or didn't install correctly from the website. 




## References
1. https://etcher.balena.io/ - Site to download Etcher
2. https://etcher.download/ - How To Make A Bootable USB Drive With Etcher

Proxmox Infrastructure Reference
| PC Number | Hostname | IP |
| --------- | -------- | -- |
| WAN-35    | Proxmox5 | 192.168.0.114 |
| WAN-36    | Proxmox4 | 192.168.0.87 |
| WAN-37    | Proxmox3 | 192.168.0.118 |
| WAN-38    | Proxmox2 | 192.168.0.159 |
| WAN-40 | Proxmox1 | 192.168.0.223 |

(Currently has the Cluster started)


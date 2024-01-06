# Changing Host Names

Author(s): 
    Chisom (Ask me anything, don't bother Luke), 
    Luke

## Preliminary Note: 
It's recommended to change the *host names* of the Proxmox machines before manipulating them, such as adding VMs or adding/creating a Proxmox cluster.

If machines are already in use see [Extra](#extra) at the bottom of the document.

## Steps - Each step must be done to every individual machine that you wish to alter the host name for
1. Access the Promox instance's Console
2. Use nano or any editor to change every instance of the "old host name" to the "new host name"
	```sh
	nano /etc/hosts
	```
3. Use nano or any editor to change every instance of the "old host name" to the "new host name"
	```sh
	nano /etc/hostname
	```
4. Reboot the Proxmox machine
	 ```sh 
	reboot
	``` 

## Extra:
This may work. https://forum.proxmox.com/threads/proxmox-node-name-change.14327/#post-156444





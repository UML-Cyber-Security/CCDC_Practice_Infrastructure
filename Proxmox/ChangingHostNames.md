# Changing Host Names

Author(s): 
    Chisom (Don't ask me anything bother Luke), 
    Luke

## Preliminary Note: 
It's recommended to change the host names before manipulating the machines, such as adding vms or adding/creating a cluster with the machine.
If machines are already in use see "Extra" at the bottom of the document.
	
## Table Of Contents
- Edit /etc/hosts
- Edit /etc/hostname
- Reboot Machine



## Steps - Each step must be done to every individual machine that you wish to alter the host name for
1. Access the Console
    Type in nano (or any editor)  
```sh
/etc/hosts
```
Change every instance of the "old host name" to the "new host name"
Save Changes

2.  Type in nano (or any editor) 
```sh
/etc/hostname
 ```
Change every instance of the <old host name> to the <new host name>
Save Changes

3. Reboot the machine
 ```sh 
reboot
``` 

Extra:
This may work. https://forum.proxmox.com/threads/proxmox-node-name-change.14327/#post-156444





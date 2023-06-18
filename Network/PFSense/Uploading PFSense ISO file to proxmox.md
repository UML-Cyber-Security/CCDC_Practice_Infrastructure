up:: 
tags:: #CCDC #Cybersecurity #Proxmox #Networking 
Date::6.17.2023


1. Ssh into proxmox
	ssh [root@192.168.0.60](mailto:root@192.168.0.60)
	Type in password
2. Navigate to the directory where ISO files are stored in linux
	1. cd /var/lib/vz/template/iso
3. Go to PF Sense download page on your regular browser & fill out download specifications
	1. ![[Pasted image 20230617194515.png]]
	2. You may have to click Download once, so the actual download link with the correct details are linked to the download button
		1. This may be needed b/c I am unsure how often the webpage updates
	3. **Right click the Download Button** & save the link
4. Navigate back to the ssh console and pull the iso file from the web
	1. use wget "web page link"
	2. Full cmd - wget https://atxfiles.netgate.com/mirror/downloads/pfSense-CE-2.6.0-RELEASE-amd64.iso.gz](https://atxfiles.netgate.com/mirror/downloads/pfSense-CE-2.6.0-RELEASE-amd64.iso.gz)
	3. ![[Pasted image 20230617195356.png]]
5. Unzip the file inside the same Linux ISO directory
	1. Using cmd -  gunzip pfSense-CE-2.6.0-RELEASE-amd64.iso.gz


## **Creating the PFSense VM**
1. Navigate to Proxmox 
2. Click create VM
3. **General tab**
	1. Name your VM
	2. ![[Pasted image 20230617195722.png]]
4. **OS Tab**
	1. Click **use iso file**
	2. Press **Storage: Local**
	3. Attach Iso img
	4. ![[Pasted image 20230617195827.png]]
5. **System Tab**
	1. Leave as default
	2. ![[Pasted image 20230617195912.png]]
6. **Disks**
	1. 8gb minimum 
	2. I set the Disk size to 12gb 
	4. ![[Pasted image 20230617200009.png]]
7. **CPU**
	1. Leave as Default or as you prefer
	2. ![[Pasted image 20230617200056.png]]
8. **Memory Tab**
	1. 1gb required
	2. I gave 3gb
	3. ![[Pasted image 20230617200606.png]]
9. **Network Tab**
	1. ***The bridge changes dependent on the network the PFsense firewall is supposed to communicate with
	2. vmbr2 is our linux bridge
		1. If we were connected to a windows bridge it would not be vmbr2 but vmbr1, b/c we named them like that
	3. **Multiqueue** = 8
		1. Allows the BSD kernel to negotiate the optimal value with Proxmox VE in the Network configuration
	4. ![[Pasted image 20230617200629.png]]
	5. I am unsure if the Firewall box is supposed to be checked or not
		1. I left it in it default state

The next tab is a confirmation tab, aka overview of out settings. Just hit next & don't forget to start the machine.

You have successfully added the PFSense ISO to is appropriate machine.

But you have not configured the fire wall software yet.
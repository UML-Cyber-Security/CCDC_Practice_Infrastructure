# Setup of the Software Defined Network
This document described the setup and configuration of Software Defined Networks in Proxmox for this project.

## Installation

### Modify Apt Source List
Please refer to [Proxmox Readme](./../../Proxmox/README.md) to add the non-enterprise repository, and remove the enterprise repositories.

1. Update and install packages 
    ```
    apt update && \
    apt install libpve-network-perl ifupdown2
    ```
2. Modify the ```/etc/network/interfaces``` file
    ```
    echo "source /etc/network/interfaces.d/*" >> /etc/network/interfaces
    ```
3. Wait some time, possibly restart devices
    * For me, the SDN field did not appear until 2 days later, when the machine may or may not have all been restarted
### SDN
1. Access the *Datacenter* page from the the web interface 

    <img src="Images/SD1.png" width=800>

2. Access the SDN dropdown menu

    <img src="Images/SD2.png" width=800>

3. Access Zones

    <img src="Images/SD3.png" width=800>

4. Create a VLAN Zone 
   *  <a href="https://pve.proxmox.com/pve-docs/chapter-pvesdn.html">Per Proxmox's SND documentation</a>: "A zone defines a virtually separated network", we need this in order to virtually connect the Proxmox hosts, allowing for the "Seamless" communication between nodes on the various networks. We can likely use the **Simple** or **VLan** Zones. If we wish to utilize VLan Tags the VLAN network is required.

    <img src="Images/SD4.png" width=800>

5. Fill in the information. They limit the ID to 10 characters
    * The DNS information appears to be a drop down. I was unable to configure this.

    <img src="Images/SD5.png" width=400>

6. Navigate to the VNet menu

7. s

![Alt text](image.png)
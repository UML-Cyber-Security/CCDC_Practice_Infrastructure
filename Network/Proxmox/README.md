# Proxmox 
This Directory contains information regarding the configuration of Proxmox instances to support the Practice Infrastructure.

## Network Setup
It appears that the Linux VLAN and OVS Networking options are used for connecting Virtual devices to external VLans that are created using a **PHYSICAL** managed Network Switch.

### Plan/Idea
Based on what I have read:
1. Our best bet is to create **Bridged Networks** that have no gateway or interface specified.
   * This allows us to create **INTERNAL** Networks removing the  ability for devices to bypass the firewall
2. These Internal Networks can be attached to 1 of the interfaces created on the PFSense VM.
3. We will need 4 of them   
   * One for the DMZ Network
   * One for the Linux Network
   * One for the Windows Network
   * One for the Network used to connect the PFSense Routers.
4. The Ingress router (DMZ One) will be connected to the bridged network, so that will still needs to exist.

## Network Creation
Refer to the [PFSense Documentation](./../PFSense/1-Initial_Setup.md) document for more details.
Refer to the [SDN Documentation](./SDN.md) when implementing a **Highly Available** or Multi-System setup.

## VM Creation 
First we need to make sure the PFSense, Linux and Windows ISOs are available. We can do that with the following steps in each Documentation, However we provide general guidance in this document below.
1. Refer to [PFSense Documentation](./../PFSense/1-Initial_Setup.md)
2. Refer to [Linux Documentation](./../../Linux/README.md) This is also provided in the [Proxmox Documentation](./../../Proxmox/README.md)
3. Refer to [Windows Documentation](./../../Windows/README.md)

## VM Attachment
This is utilized in the [PFSense Documentation](./../PFSense/1-Initial_Setup.md), as they are the only set of devices that need multiple network interface connections. However, we may make use of it during development to ease access to the internal Routers. 
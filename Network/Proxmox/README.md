# Proxmox 

## Network Setup
It appears that the Linux VLAN and OVS Networking options are used for connecting Virtual devices to external VLans that are created using a **PHYSICAL** managed Network Switch.

Based on what I have read:
1. Our best bet is to create **Bridged Networks** that have no gateway or interface specified.
   * This allows us to create **INTERNAL** Networks removing the  ability for devices to bypass the firewall
2. These Internal Networks can be attached to 1 of the interfaces created on the PFSense VM.
3. We will need 4 of them   
   * One for the DMZ Network
   * One for the Linux Network
   * One for the Windows Network
   * One for the Network used to connect the PFSense Routers.
4. The Ingress router (DMZ One) will be connected to the bridged network, so that will still need to exist.
### Network Setup References 

## VM Creation 

## VM Attachment
# Network Infrastructure Setup
This can be a file containing an overview of the subfolder on specific topics

## Proxmox 
We first need to configure proxmox to contain the networks necessary for the VMs to communicate on their own subnets. We will also need to look into the process for attaching the VMs to their networks.

All the information regarding this is contained in the [Proxmox directory](Proxmox/)

## PFSense
Once the Proxmox networks have been created and configured, we can create and setup the PFSense instances.
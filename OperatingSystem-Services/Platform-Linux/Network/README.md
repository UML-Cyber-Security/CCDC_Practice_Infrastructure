# Network Infrastructure Setup
This can be a file containing an overview of the subfolder on specific topics

## Proxmox
We first need to configure proxmox to contain the networks necessary for the VMs to communicate on their own subnets. We will also need to look into the process for attaching the VMs to their networks.

All the information regarding this is contained in the [Proxmox Readme](Proxmox/README.md), mainly it directs you to the appropriate document. 

## Ports
This document contains the PORTS that are used by each service. This is a centralized location that we can refer to when creating both network (edge) and host based firewalls.
## PFSense
Once the Proxmox networks have been created and configured, we can create and setup the PFSense instances.

The [PFSense Readme](PFSense/README.md) contains a summery of the content covered in the individual documents and links to them as well. Please refer to this for more information.
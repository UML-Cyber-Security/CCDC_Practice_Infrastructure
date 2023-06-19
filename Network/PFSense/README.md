# PFSense Overview

This directory contains the instructions to set up a PFSense Network containing a *DMZ* and Two *Internal* subnets. We provide a summery of the PFSense routers below.

## Network Diagram Summery PFsense
1. DMZRouter
   * This will be connected to the Internet Network (WAN Port)
   * This will be connected to the DMZ Network
   * This will be connected to the Internal Router Network
2. Linux Router
	* This will be connected to the Linux Network
    * This will be connected to the Internal Router Network
3. Windows Router 
	* This will be connected to the Windows Network
    * This will be connected to the Internal Router Network

## Initial Setup
The initial setup of the PFSense instances are described in the [Initial_Setup](./Initial_Setup.md) document. This document covers the following topics.

1. Downloading the PFSense ISO to Proxmox
2. Creating a new Isolated Network (We need four of them)
3. Creating a PFSense Instance
4. Configure the Instance on Install
5. Configure the Instance on First Boot
6. Configure the Instance to allow Web-Interface Access from WAN (TEMP Measure)
7. Configure the Interfaces
8. Configure DHCP 
9. Configure Routes
10. Configure DNS 
11. Configure Other
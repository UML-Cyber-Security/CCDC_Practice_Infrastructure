# Proxmox



## Enterprise Eddition
We need to update the source list that apt utilizes when searching for packages. This is particularly important if we have the Enterprise Eddition for Proxmox installed.

We need to edit the */etc/apt/sources* anf add the following line.
```
# Proxmox VE pve-no-subscription repository provided by proxmox.com,
# NOT recommended for production use
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription
```

I did not remove the enterprise entry WE can do that later if desired - Matt

## SDN setup
# Fixing "LVM Out of Space Error" Wazuh Docker Install
WHAT THIS IS:  
Rough guide on how to fix a out of space error on a Debian Linux OS, if you installed Wazuh through Docker  
- First check if you are out of space

`df -h`

- Check if there is existing space in the Volume Group

`vgdisplay`


- If Free Pe / Size has free space you can steal from there to allocate to LVM

- Check how much LVM space you have:

`lvdisplay`

- Use lvextend to increase the LVM space:

`lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv`

- Use lvdisplay to make sure space changed:

`lvdisplay`

- Make sure to extend your file system:

`resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv`

- Run command below to see if your system acquired more file space:

`df -h`


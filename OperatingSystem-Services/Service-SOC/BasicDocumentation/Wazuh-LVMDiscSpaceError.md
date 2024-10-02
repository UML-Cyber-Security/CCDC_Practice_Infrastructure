# LVM Out of Space

First check if you are out of space

- `df -h`

Check if there is existing space in the Volume Group

- `vgdisplay`


If Free Pe / Size has free space you can steal from there to allocate to LVM

Check how much LVM space you have:

`lvdisplay`

To extend the LVM space:

`lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv`

Use lv displat to make sure space changed:

`lvdisplay`

Make sure to extend your file system:

`resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv`

Check to make sure it is successful

`df -h`


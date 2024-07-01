# Removing Nodes
Author(s):
    Me

When migrating machines, it is useful to remove the old nodes.
Proxmox expects a quorum for certain activities, like making a new VM.

You can view the nodes with the command `pvecm nodes`

Using `pvecm expected 1` will tell proxmox to only requrie 1 node for a quorum

To delete a node, use `pvecm delnode <node name>`

Here is an example of when I used the commands

![Example](Images/removing_nodes.png)
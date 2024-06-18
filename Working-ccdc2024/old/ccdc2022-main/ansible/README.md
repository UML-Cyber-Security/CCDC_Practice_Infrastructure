# Ansible Setup

Ansible playbook by Andrew Aiken

## Setup Inventory

Fill in `inventory.ini` with the hosts.

`serverX ansible_host=X.X.X.X`


## Setup Variables

Edit the variables in `var.yaml`.

Change **users** array with the users to create on the machine.
Put the users *public* key in the files directory for each user.

**apt** packages to install on the servers.


## Simple run

`ansible-playbook playbook.yaml --private-key ./[PRIVATE_KEY]`

Specify user **-u NAME**.

The private key is the only authentication required, passwords can also be used with `--ask-pass`.

If you only want to run specific tasks you can use the **-t** flag and then specify the tag/s.
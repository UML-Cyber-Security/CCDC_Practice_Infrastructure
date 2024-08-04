# Account Management Playbooks
This readme contains additional notes on the playbooks as required.

## Account-Creation
This playbook makes a common user account and group on each of the target machines.


1. In order to create an account with a password we need to provide the encoded shadow file entry. This can be done with the [`mkpasswd`](https://linux.die.net/man/1/mkpasswd) command from the *whois* package on debian based systems.
2. The username is controlled by the *new_user* variable and the password by the *passwd* variable. Be sure to update the **whitelist** in any scripts that lock or clear out authorized keys.

> [!IMPORTANT]
> The default entry is `1qazxsW@1`, you should change this.

## Mange-Auth-Keys
This playbook will create a new user and it will load a file `auth_keys` which **should contain the ccdc team's authorized keys** into a targeted user's `~/.ssh/authorized_keys` file allowing us easier access to the machines.

This user is also added to the sudo group and a newly created group we can replace the sudo group with.

## Lock-User-Accounts
This playbook will create a backup of all user's authorized key files, and will then clear out all non-whitelisted user's keys.
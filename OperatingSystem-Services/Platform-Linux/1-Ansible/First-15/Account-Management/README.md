# Account Management Playbooks


## Account-Creation
1. In order to create an account with a password we need to provide the encoded shadow file entry. This can be done with the [`mkpasswd`](https://linux.die.net/man/1/mkpasswd) command from the *whois* package on debian based systems.
2. The username is controlled by the *new_user* variable and the password by the *passwd* variable

> [!IMPORTANT]
> The default entry is `1qazxsW@1`

## Manage Authorized Keys
This creates a backup of the authorized keys for the root user, and any user with a directory in `/home`. It then clears out their keys.
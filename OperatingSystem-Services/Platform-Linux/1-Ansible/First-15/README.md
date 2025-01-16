# Linux first 15 scripts
These scripts automate processes for locking down hosts
See TODOs in each playbook if you want to help out.

## Account Management Playbooks
Playbooks for managing accounts.

### account-creation.yml
This playbook makes a common user account and group on each of the target machines, and creates backups of /etc/passwd and /etc/group
1. In order to create an account with a password we need to provide the encoded shadow file entry. This can be done with the [`mkpasswd`](https://linux.die.net/man/1/mkpasswd) command from the *whois* package on debian based systems.
2. The username is controlled by the *new_user* variable and the password by the *passwd* variable. Be sure to update the **whitelist** in any scripts that lock or clear out authorized keys.
> [!IMPORTANT]
> The default entry is `1qazxsW@1`, you should change this.
### manage-auth-keys.yml
This playbook backs up and then clears all the authorized keys for non-whitelisted users.
### lock-user-accounts.yml
This playbook backs up /etc/passwd and /etc/shadow (TODO: account-creation also backs up /etc/passwd!!), and locks all non-whitelisted user accounts.

## Auditd
Auditd is responsible for managing and recording logs. Usually the SOC will pull logs from Auditd
### load-auditd.yml
This playbook copies our rules from the `audit_rules.conf` file to `/etc/audit/rules.d/ccdc.rules` on the ansible nodes.
### journald-config.yml
This playbook configures journald to forward to syslog, compress, and persist logs

## SSHD
SSHD is how you log onto your machine. It is imperative that you get this set up first--that means copying the public keys of anyone who needs to use the machine into authorized keys for their user, and then disabling password login.
### sshd-general-config.yml 
This playbook disables root login among many other things. IT DOES NOT DISABLE PASSWORD LOGIN!!
### sshd-danger-config.yml
This playbook disables tcp forwarding (the `-L` option on ssh), and X11 forwarding. You probably dont want to run this.

## Sysctl
Sysctl controls kernel parameters during runtime. See sysctl_safe.conf and sysctl_unsafe.conf--the parameters are usually pretty well named.
### sysctl-config.yml
See sysctl_{un,}safe.conf. 

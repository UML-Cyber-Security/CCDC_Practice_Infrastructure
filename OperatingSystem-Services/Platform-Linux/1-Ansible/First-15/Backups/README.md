# Backup
This playbook will backup a variety of important and interesting files. This can be expanded as needed or desired. It currently organizes the files into a `/backup` directory. This is separate from the `*.bak` files and directories the other scripts will create as they make modifications. This way we have some redundancy. The following files are backed up.

* Shell Histories `/backup/user/*_history`: Backup shell histories from all user's with home directories.
* User Authorized Keys `/backup/user/authorized_keys`: Backup user's authorized keys.
* SSH Configurations `/backups/ssh`: SSH Directory, containing all configurations.
* PAM Configurations `/backups/pam`: Pam configuration `pam.d` and `pam.conf`.
* Crontabs `/backups/cron`: User Crontabs.
* Logs `/backups/log`: All current system logs.
* Critical User Auth files.


The main goal of this script is to preserve information from the start of the event and enable us to more easily recover from catastrophic failures.
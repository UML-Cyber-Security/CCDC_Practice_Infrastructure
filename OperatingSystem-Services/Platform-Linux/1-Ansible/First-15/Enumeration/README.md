# Enumeration

This directory will contain playbooks used to enumerate and gather information from each of the target machines. We use this to quickly run commands on each of the target systems, and centralize the information in files so we can quickly examine it.

* Auth Keys: Enumerate all authorized key files on system.
* Cron: Enumerate all crontab files on the system, and store them in a concatenated file format so we can look at them.
* File-Mods: Enumerate files that have been edited in a give time period (set to last hour).
* Host Network: Enumerates some commone network configuration files, and prints information about the current interfaces.
* Linpeas: Privilege Escalation, keep note of simpler things like generous file permissions and s-bit binaries.
* Processes: List current processes on the target system, be aware this will contain the ansible processes.
* Services: Prints services that execute a binary or script.
* Sudoers: Print dangerous sudo configurations.
* Users-Info: Prints users and group information of the system.
## Authorized Keys
This playbook prints the locations authorized key files can be located, and enumerates the common locations, and those keys located in a user's home directory. We should make the playbook more dynamic extracting locations from the `sshd_conf` file and `sshd_conf.d` directory.

## Cron
This playbook enumerates through the `/etc/cron.d`, `/etc/crontab` and `/var/spool/cron/crontab` directories and files to gather all of the cronjobs that have been scheduled. This need to be expanded to work on systems tha place user-generated crontab files in locations other than the `/vat/spool/cron` directory.

## File-Mods
This playbook enumerates through the `/etc`, `/bin`, `/home` and `/sbin` directories for any files that have been edited in the last given time period (default of 1hr). 

## Host-Network
Enumerates common and useful information about the host system's network configurations. This primarily uses the `lsof`, `ss` and `ip` commands.

## Lin_peas
This playbook runs the linpeas enumeration script on each of the target systems, saves the output to a file and transfers it to the machine running the ansible script. It then removes the linpeas script and output from the remote machines.

> [!NOTE]
> The file contains alot of binary and coloring data. You can use the provided parsers to convert them. A future goal is to have the ansible script run these locally for us (or externally, whichever works).
>
> python3 peas2json.py </path/to/executed_peass.out> </path/to/peass.json>
> python3 json2pdf.py </path/to/peass.json> </path/to/peass.pdf>

## Processes
This playbook enumerates the current processes on the system. This uses the `ps` and `pstree` commands.

## Services
This playbook prints the services that execute a binary executable or script.

## Sudoers
This examines the `/etc/sudoers` file for dangerous sudo commands. We should expand this to look in files from the `/etc/sudoers.d` directory.

## Users-Info
This playbook prints currently logged in users with the `w` and `who` commands, along with users with common shells like `bash`, `fish` and `zsh` to name a few. We also print out some common groups and their members if they exist.
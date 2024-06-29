# First Steps on FreeIPA Machine
THIS DOES NOT OVERRIDE THE TEAM FIRST 40!!!
 THIS IS JUST A HELPFUL CHECKLIST
---

### Backup Shadow & Password Files
`sudo cp /etc/passwd /etc/passwd.bak`
`sudo cp /etc/shadow /etc/shadow.bak`

---

### Create `blue3` admin account and add it to `minecraft` group
`groupadd minecraft` (make the minecraft group)

`sudo visudo` (edit the sudo file)

add the line `%minecraft ALL=(ALL:ALL) ALL` to the file and quit.

`sudo useradd -m -d /home/blue3 -s /bin/bash blue3`

`sudo usermod -aG wheel blue3`

`sudo passwd blue3`

---

### Harden SSH
if you haven't already, type `ssh-keygen` on the laptop, not the infrastructure.

copy your public `.pub` key in your `~/.ssh` directory.

Back on the infrastructure:

sign into the blue3 account `su blue3`

paste your key into the ~/.ssh/authorized_keys file

paste your key into the shared document for the team.

edit the /etc/ssh/sshd_config file to match this:
```
PubkeyAuthentication yes
PasswordAuthentication no
PermitRootLogin no
```

Try to access the machine on another terminal

DO NOT CLOSE YOUR CURRENT SESSION!!!

If you can get in without a password, exit out of the new terminal you just created and continue.

test the new config using `sudo sshd -t`
restart the service with `systemctl restart sshd`

---

### Identify Reverse Shells
`sudo ss -tulpn` will list all outgoing port activity
`sudo ss -tupns` will do only outgoing connections

#### Process of removing an unwanted activity:

`sudo pkill -9 PID`

`chmod -x /sbin/SERVICE && mv /sbin/SERVICE /sbin/SERVICE.mal`

`sudo chown nobody /sbin/SERVICE.mal`

example: `users:(("chronyd",pid=800,fd=6))` SERVICE=chronyd, PID=800.

#### If this was a mistake, return the service back to normal:

`sudo chown root /sbin/SERVICE.mal`

`mv /sbin/SERVICE.mal /sbin/SERVICE && chmod +x /sbin/SERVICE`

---

### Locking Unwanted Accounts

`cat /etc/passwd` will list all users

#### For all known bad users

`sudo passwd -l <username>` will lock a user

Mark the /etc/passwd file and change the shell to NULL

`sudo usermod -c "Known Malicious" -s /dev/null <username>`

#### If this was a mistake, return the user back to normal:

`sudo passwd -u <username>`

`sudo usermod -c "Blue Cleared" -s /bin/bash <username>`

---

### Checking unwanted SSH Services

`w` will show who is currently SSH'd into the machine. (Notice TTY)

`ps -auxf | grep ssh` will show all processes using ssh.

#### To remove an SSH connection
`sudo pkill -9 -t TTY` where TTY is what was found from `w` command.
`sudo pkill -9 PID` where PID is found in `ps -auxf` command.

---

### Check for Repeating Services
`ls /var/spool/cron` will list all cron-jobs
`cat ~/.bashrc` will list all services run on a new shell
`systemctl list-units -type=service` lists all running services.

---

# FreeIPA SPECIFIC STEPS
# OS:_______ IP:________ Hostname:____________

### Write the OS, IP, and Hostname Above
`cat /etc/os-release`, `ip addr`, `hostnamectl`.

if the hostname doesn't have 3 fields (first.second.third), make it have 3.

`hostnamectl set-hostname example.host.name`

---

### List all client machines and users
`kinit admin` sign in as admin

`ipa host-find | grep Host` lists all FreeIPA client machines.
`ipa user-find` lists all users on FreeIPA
`ipa group-find` lists all groups on FreeIPA

---

### Disable Shady Users & Groups
`ipa user-disable <username>` disables the user

`ipa user-enable <username>` undoes this

#### Add Malicious users to the bad_actors group

`ipa group-add bad_actors` (group for malicious users)

`ipa group-show <groupname>` DO THIS FOR ALL GROUPS

`ipa group-remove-member <groupname> --users={user1, user2}`

`ipa group-add-member bad_actors --users={user1, user2}`

---

### Add A general Password Policy
`ipa pwpolicy-add  -minlength=8 -minclasses=3`



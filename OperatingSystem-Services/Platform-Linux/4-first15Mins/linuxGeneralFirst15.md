# Linux First 15 minutes - General OS lockdown and prepeartion

## Part 1. Initial Enumaration & Organization
Part 1 is to be completed partially simultaneously.

---
### Scanning
    - Person(s) available: 8 
    - 2 people will scan the network. 6 person(s) left \
	    Nmap scan 
        - Find Ips for machines using fping then use only those in the NMAP
            Add them doc/whiteboard & inform team (to do all ports use the flag -p -)
            `nmap -sV -O -T4 <IPS>`
    - nmap specific machines.
    - Split the port range in half.
    - Save the results to a file.

Goal: Determine what machines we have access to

Scenarios: We are given 1 Ip or multiple Ips
---
### Google doc creation
- Person(s) available: 6 
  - 1 People will be responsible for setting up the basics of the sheet. 5 person(s) left. 
  
Each google sheet should be under the same google drive folder, aptly named.

- [ ] Credentials sheet
  - Add the given credentials if available.
  
- [ ] Network Diagram
  
- [ ] Task tracking sheet

- [ ] Network Diagram sheet

- [ ] SSH pub key sheet

- [ ] Inject Folder + Inject template(placed inside the folder)

- [ ] Incident Folder + Incident template (placed inside the folder)

### Assign Machines.
Assumptions:
    We know the Ip of our machines
    We can access the machines.

Captain will arbitraly assign machines and Ips.
On this machine assuming, its your OS. You will lockdown the OS.

Being OS hardening.

<!-- ### Service Identification
- Persons(s) available: 4 + nmap team members
One person from each service team would be beneficial.

1. Access the machines 
2. write how to access the machines on the credential sheets. 
   - In the case, their are any unique ways to access the machines(i.e jumpboxes, etc.)
   - If Unique ways to access machines. Write it on the credentials heet.
3. Note down what service you can find.

Q. Should team members change their own machine credentials or have 2 of the service Identification memebers change the machine credentials? -->




Goal: Determine the services we have and the machine and add them to the services sheet along with their IPs. You will work closes with the nmap team, in case there are hidden machines or other unexpected surprises in the given infrastructure.



---
## Everyone has access to a machine.
## Part 2. OS Hardening


### Backups
1. On Your Machine generate a SSH key that you will use to access the competition infrastructure.
   1. `ssh-keygen -t ecdsa -f ./Cyber-Comp-Key`
   2. You do not need a password unless you expect this key to be used on the target machine.
2. Backup Services Configuration files like SSH, and PAM.
   1. `sudo cp -r /etc/ssh /etc/ssh.bak && sudo cp -r /etc/pam.d /etc/pam.d.bak && sudo cp /etc/pam.conf /etc/pam.conf.bak`
3. Backup Critical user management files such as shadow, passwd and group
   1. `sudo cp /etc/shadow /etc/shadow.bak && sudo cp /etc/passwd /etc/passwd.bak && sudo cp /etc/group /etc/group.bak`
4. Backup Account Histories
   1. `sudo find /home -type f -iname '.*_history' -exec cp {} {}.bak \;`
5. Backup old Authorized key files
   1. `sudo find /home -type f -iname 'authorized_keys*' -exec cp {} {}.bak \;`
### Account creation
1. Create your Admin Group account 
   1. `sudo groupadd Minecraft-User`
2. Add the new group to a SUDO group
   1. `%Minecraft-User ALL=(ALL) ALL`
3. Create your own Admin Account within your machine  
	1. `sudo useradd -m -d /home/admin -s /bin/bash admin`
	`sudo usermod -aG group user`

4. Create an account named blueteam
   1. `sudo useradd -m -d /home/blueteam -s /bin/bash blueteam`
5. Add the new user to a sudo (or wheel) group and the group we created previously.
   1.  `sudo usermod -aG sudo blueteam && sudo usermod -aG Minecraft-User blueteam`
6.  Give the account a password
    ```sh
    sudo passwd blueteam OR
    echo "blueteam:PASSWD" | sudo chpasswd # Clear out history file, only do this if we think they have modified or shimmed the password requirements
    ```
7.  If team consensus is reached, do this again for another account.
### Removing Unauthorized Access
1. Remove compromised keys
   1. `sudo find /home -type f -iname 'authorized_keys' -exec echo "" > {} \;`
2. Add your Public Key to the authorized_key file for a few of the users including our blueteam account.
   1. `sudo vim ~blueteam/.ssh/authorized_keys`
   2. Paste your public key in.
3. Test your SSH key access to the machine
   1. ssh -i /Path/to/private/key blueteam@IP
   2. Note: You can do a jumphost like `ssh -i /Path/to/private/key blueteam@IP -J host1user@host1IP targetuser@tartgetip`
4. Lock all non-blueteam and non-blackteam accounts.
   - `sudo passwd -l <USER>`
<!-- 5.  Key log prevention
    - Check for suspicious cron jobs/systemd services
      - ls /var/spool/cron
      - (sudo) systemctl list-units –type=service
- Check for processes reading from a file
- Check for rogue tlog/script processes
  - /ls
1. Change Passwords for host and services
   1. We ha 
    2.For Host/services
2. Disable Unknown Users
   - See what impact this has
   - Keep backups/ track what users you’ve disabled
     - `passwd -l user` `#locks user`
     - `ps -auxf | grep ssh` `#Show what processes have an open ssh session`
     - `sudo pkill -u username sshd` `#Kill ssh connection for user`

3. Run Audit scripts (We have none currently)
   - Lynis - (Linux) (untested) (Takes time)
     - `Sudo apt-get install lynis && sudo lynis audit system`
4. Generate / Change Machine keys 
   - ssh-keygen on host machine
   - Copy your .pub to ~/.ssh/authorized_keys
   - Copy your .pub key to the google ssh key sheet
   - Don’t close your terminal
   - Confirm Key access
     - SSH On another terminal

5. ssh-config changes
   - Disable password Authentication
     - `PasswordAuthentication no`
   - Only do If machine keys were successfully changed
   - Disable root logins
     - `PermitRootLogin no`    
   - Only do If machine keys were successfully changed

6.  Test SSHD
    - `sudo sshd -t`
    - Restart SSHD
		
7.  Confirm Key access
- SSH On another terminal



## Revert whats avaialable

Extra (Untested)
---												
    ClamAV - AntiVirus(Linux)
    sudo apt-get install clamav && sudo clamscan -r /
    Freshclam
    clamscan -->

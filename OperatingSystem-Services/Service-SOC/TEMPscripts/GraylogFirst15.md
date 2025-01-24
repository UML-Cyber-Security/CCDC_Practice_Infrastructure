# Graylog First 15 #
WHAT THIS IS:  
Steps to do and complete during the first 15 minutes

## 1. Locate Network Inventory Sheet ##
- At least write system info down if sheet is n/a
- Nmap here if needed
- Run `Inital-Backup.sh`
- Run `set-permisions.sh`

## 2. Initial Audit ##
- Run basic scan `Init_Audit.sh`
- Add information to network inventory sheet

## 3. New user ##
- ```sudo useradd blueteam```
- ```sudo usermod -aG sudo blueteam``` or ```sudo usermod -aG wheel blueteam```

## 4. SSH keys ##
- ```ssh-keygen```
- Add to keys file and confirm key is working

## 5. Passwords ##
- Change all passwords on the machine

## 6. Run setup scripts ##
- Run following setup script blah blah blah
- Setup up important configs
- set up firewall, sshd config, auditd, etc;

## 7. Secondary Audit ##
- Run verbose `Init_Audit.sh`
- Fix stuff, lock users (`sudo usermod -L <user>`), WRITE DOWN BAD STUFF FOUND!S

## 8. Antivirus ##
- Install and run clamAV
- Run linpeas if wanted...?
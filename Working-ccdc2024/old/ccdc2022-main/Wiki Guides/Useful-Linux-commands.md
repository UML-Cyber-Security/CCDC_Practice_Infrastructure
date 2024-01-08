# View all listening ports:
```
$ ss -tulpn | grep LISTEN
```
Note the users field in the far right column

# To view currently logged in users:
```
$ w
```

# Quick UFW guide:
[Here](https://gitlab.cyber.uml.edu/ccdc/ccdc2022/-/blob/main/Wiki%20Guides/Uncomplicated%20Firewall%20(UFW).md)

# Find which file is running a process:
```
$ lsof
```
Stands for list open files, likely wants to be used with "| grep 'string'" as the output can be very long

# List last logged in users:
```
$ last
```

# List all users on the system:
```
cut -d: -f1 /etc/passwd
```

# Check for a rootkit:
```
$ sudo apt install chkrootkit
$ sudo chkrootkit
```

# Check for a virus:
```
$ sudo apt install clamav
$ clamscan -r --bell -i /path/to/dir
```
The above command will print any malicious files and ring a bell when they are found
```
$ clamscan -r --remove /
```
The above comamnd will scan the whole system and remove any malicious files found

# List users with no password:
[Here](https://gitlab.cyber.uml.edu/ccdc/ccdc2022/-/blob/main/ccdc2021/Scripts/blankpass.sh)

# systemctl commands:
("service" is variable)
```
$ sudo systemctl status service
$ sudo systemctl restart service
$ sudo systemctl start service
$ sudo systemctl stop service
```
To make service start on boot:
```
$ sudo systemctl enable service
```
To make service NOT start on boot:
```
$ sudo systemctl disable service
```

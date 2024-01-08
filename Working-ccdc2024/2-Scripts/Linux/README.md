# Order of Install
1. Initial Backup Script 
2. Install-Remove-Services
   1. LDAP if necessary
3. CRON
4. Docker
5. Gluster -- Probably not needed 
6. Firewall
   1. Install Firewall
   2. Set Firewall Rules
7. K8S?
8. SUDO Config
9. System Configurations
   1.  Not the SAFE one -- that is old
10. File Permissions 
    1.  Manually Install AIDE if **INSTRUCTED**
    2.  Basic permissions changing
11. Rsyslog
12. AuditD
    1.  Journald



# Useful commands -- To fix my issues :) 
The Following will remove and replace CLRF with LF so Scripts work on Linux systems.
```
sed -i -e 's/\r$//' Script.sh 
```

The Following will change the permissions of all files found to end in .sh making them executable.
```
find /directory/of/interest/ -type f -iname "*.sh" -exec chmod +x {} \;
```

The following is for debian based systems, as some packages may request user input, which can be annoying. YUM and (maybe) APK appear to not do this. You still should use the **-y** flag as they will do the "Do you really want to use disk space" and making sure you are not installing some weird package.
```sh 
# We can show package configurations that we can set pre download.
debconf-show 
# This is how we would write them to the system
echo package option | debconf-set-selections

# alternatively we can use the default options by using the following (I prefer as I am Lazy)

export DEBIAN_FRONTEND=noninteractive 
```



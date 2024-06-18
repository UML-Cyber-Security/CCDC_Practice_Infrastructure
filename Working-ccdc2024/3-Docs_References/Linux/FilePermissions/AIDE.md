# What is it
##### Written by a sad Matthew Harper
The Advanced Intrusion Detection Environment (AIDE) is a open source tool that we can use to detect changes made to files on a system. 

This is a resource intensive and time consuming process. So the consumption on resource constrained systems means it may not be advisable in all situations, as little can be done during the run time. Especially when we are creating the reference database. 
# How we set it up
First we install AIDE with our system's package manager
```sh
# RHEL based
yum install -y aide
``` 

Then we want to make changes to the configuration before we create the database. The configuration is located at **/etc/aide.conf**
```
vi /etc/aide.conf
```

We can define custom rules to track different sets of parameters for files and directories. An example Redhat gives is as follows
```
PERMS=p+i=n=u=g=acl=selinux

p - permissions
i - inode (Pointer to location on disk + other data)
n - number of links
g - group
acl -access control list
selinux - security context
```

User the **aide-init** command to generate a database. The resulting output will be stored in **/var/lib/aide**
```sh
# Initialize database
aideinit
```

We then need to move this database to the working directory for AIDE. 
```
 mv /var/lib/aide/aide.db.new.gz  /var/lib/aide/aide.db.gz
```

We can then use AIDE to check if any changes to the filesystem have been made. 
```
aide --check
```

We may want to update the database that we have created. If this is the case we can use the update command. This will update the database after changes have been made to the **aide.conf** file.
```
aide --update
```

# Rules
```sh
# Creates FIPSR rule
FIPSR= p+i+n+u+g+s+m+c+acl+selinux+xattrs+sha256

# Applies rule to file/dir
/etc/hosts       FIPSR
```


Example Config given in the [AIDE Docs](https://aide.github.io/doc/)

```sh
#AIDE conf

   # Here are all the things we can check - these are the default rules
   #
   #p:      permissions
   #ftype:  file type
   #i:      inode
   #n:      number of links
   #l:      link name
   #u:      user
   #g:      group
   #s:      size
   #b:      block count
   #m:      mtime
   #a:      atime
   #c:      ctime
   #S:      check for growing size
   #I:      ignore changed filename
   #md5:    md5 checksum
   #sha1:   sha1 checksum
   #sha256: sha256 checksum
   #sha512: sha512 checksum
   #rmd160: rmd160 checksum
   #tiger:  tiger checksum
   #haval:  haval checksum
   #crc32:  crc32 checksum
   #R:      p+ftype+i+l+n+u+g+s+m+c+md5
   #L:      p+ftype+i+l+n+u+g
   #E:      Empty group
   #>:      Growing file p+ftype+l+u+g+i+n+S
   #The following are available if you have mhash support enabled:
   #gost:   gost checksum
   #whirlpool: whirlpool checksum
   #The following are available and added to the default groups R, L and >
   #only when explicitly enabled using configure:
   #acl:    access control list
   #selinux SELinux security context
   #xattrs:  extended file attributes
   #e2fsattrs: file attributes on a second extended file system

   # You can also create custom rules - my home made rule definition goes like this
   #
   MyRule = p+i+n+u+g+s+b+m+c+md5+sha1

   # Next decide what directories/files you want in the database

   /etc p+i+u+g     #check only permissions, inode, user and group for etc
   /bin MyRule      # apply the custom rule to the files in bin
   /sbin MyRule     # apply the same custom rule to the files in sbin
   /var MyRule
   !/var/log/.*     # ignore the log dir it changes too often
   !/var/spool/.*   # ignore spool dirs as they change too often
   !/var/adm/utmp$  # ignore the file /var/adm/utmp
```

# Concerns 
There is the runtime aspect of this program. It would not be wise to change the filesystem while the database is being created. Additionally due to the resource intensive nature of the operations (reading the entire filesystem and creating an indexed database) we cannot do much of anything during this process.  

# References  
* https://www.redhat.com/sysadmin/linux-security-aide
* https://aide.github.io/doc/

Whats an INODE: 
https://www.bluematador.com/blog/what-is-an-inode-and-what-are-they-used-for
# User Management
This is written by a Sad Matthew Harper, and moved from a google doc too!

There are a number of reasons we would be concerned with user management. This can include **adding** and **removing** a **user or group**.

Users and the groups they are part of can be found in the /etc/passwd file. This file should only be writable by the root user but is readable by all. 


**Users** and the **groups** they are part of can be found in the **/etc/passwd** and **/etc/group** files. This file should only be **writable** by the **root** user but also **readable by all**. 

## Passwd
The **/etc/passwd** file has the following format:
![../images/PASSWD.png]

The **first field** \<**username**\> is well, the username of the user this is linked to the UID field, which is mentioned later..

The **second field** <***|!**> is where the hashed **password** **used to be stored**, however, that is now in the **shadow file** or elsewhere depending on the system

The **third field** <**UID**> is the **User ID Number (UID)** associated with the user, **only** the **root** account should have the **UID of 1**
* The **id** command can be used to check the ID of a user

The **fourth field** <**FullUserName**> is where the **Full Name** associated with the user is located (This is not important)

The **fifth field** <**HomeDir**> is the path to the user's **home directory**
* Make note of this for scripts!

The **sixth field** <**Shell**> is where the user’s shell is listed. This will be started once the user logs in.

The **/etc/shadow** file is where the user’s (hashed) passwords are stored. It should only be accessible by root.

## Shadow

The **/etc/shadow** file is where the user’s (hashed) passwords are stored. It should **only** be **accessible by root**.

The **/etc/shadow** file has the following format:

![../images/SHADOW.png] -- Need to make

The **first field** is the **username** of the user. This **links** the entries **in** the **shadow** **file** to the **entries** in the **passwd file**

BOLDS NEEDED
The **second field** contains three subfields separated by $s the first subfield specifies the hash that will be used. The second subfield contains the salt used when hashing the password. The third subfield contains the hashed password. A single or double exclamation point (!|!!) can be placed in the second field instead of anything to lock an account. If there is a star * this means no password has been established. An empty second field is BAD this means NO PASSWORD.
The Hashing algorithms are:
$1 = MD5 (bad)
$2a = Blowfish
$2y = Blowfish
$5 = Sha256
$6 = Sha512
The salts for users should vary!




**PREREQUISITES: OpenSSL installed on machine generating the request. Installed by default on Linux systems, can be used on Windows systems either through WSL or Git for Windows.**

**TLDR: helpful commands -**
Request w/ new key: `openssl req -newkey rsa:2048 -keyout PRIVATEKEY.key -out YOURDOMAIN.csr`

Running this OpenSSL command as shown above will generate a .csr file, which is used to request certificates, as well as generating a new private key for this .csr file. Upon running this command and changing the capital names if needed, the user will be prompted with a few things.

First up, there is a required password for the private key; choose something that can be remembered if this private key is to be accessed in the future. 

After the private key is generated, there is a series of questionnaire type questions to fill out.

**NOTE:** The only required field is the Common Name field, which should be filled out to typically be the fully qualified domain name of the website to be accessed. For example, dev.example.com would be a valid way to fill out this field. All other information can be filled out for extra information, but does not need to be.

![ss1][Images/questions.png]

Hang onto the private key, and let it be as secure as possible. The .csr file will now be transmitted to the CA being used to generate the cert; one simple way to do this is through SCP.

If you're using WSL, this should already be in your Windows machine's file system.

If you're looking to SCP from the Linux machine to the Windows machine, make sure the Windows machine has OpenSSH Server installed as an optional feature, and make sure you can access the machine either through firewall settings or network settings. A sample command would be:
`scp /path/to/file.csr WindowsUser@WindowsIP:C:/path/to/final/`

If you're looking to SCP from the Windows machine and grab the file from the Linux machine, all you need is the OpenSSH client on the Windows machine, and Linux SSH access configured so that you can SSH into the Linux machine. A sample command would be:
`scp LinuxUser@LinuxIP:/path/to/file.csr C:/path/to/final/`

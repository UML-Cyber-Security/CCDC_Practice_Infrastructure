## OpenCart Setup on Windows

### Objective
Deploy OpenCart on Windows Server IIS.

### Documentation
Download, install, and integrate IIS/PHP/MySQL as detailed in the IIS.md documentation.

Prompt `cmd` and type `iisreset`. This enables the changes.

Default password encryption on MySQL 8.0+ is `caching_sha2_password` which uses SHA2 encryption. This will cause a conflict on OpenCart which uses SHA1 with salt to store passwords. So need to create a new user in MySQL that does not use SHA2. Open the MySQL command line client and run the following commmands to create a new database and user (replace database, username, and password as desired):

```
create database mydb;
 
CREATE USER ‘myuser’@’localhost’ IDENTIFIED WITH mysql_native_password BY ‘mypassword‘;
 
GRANT ALL PRIVILEGES ON mydb.* TO ‘myuser‘@’localhost’;

FLUSH PRIVILEGES;
```

Go to the following link to download latest version of OpenCart:
`https://www.opencart.com/index.php?route=cms/download/download&download_id=59`

Extract the contents of the `upload` folder to a subfolder of `C:\inetpub\wwwroot` (e.g. `opencart.deployment.com`). In IIS Manager, create a new instance to point to this directory.

Rename `config-dist.php` to `config.php` and `admin/config-dist.php` to `admin/config.php`.

Grant Read/Write privileges to the following folders and files:
```
image/
image/cache/
cache/
download/
config.php
admin/config.php
```

Go into `/install/model/install.php` file and delete exactly this text as it will cause an error in MySQL 8.0+:
```
$db->query("SET @@session.sql_mode = 'MYSQL40'");
```

Also need to either delete the `php.ini` file in the `upload` folder or modify it using the settings detailed in the `IIS.md` documentation. 

In addition to these settings, uncomment the line `extension=php_openssl` in whichever `php.ini` is being used.

Start the server, go to the home page of the website, and follow the setup wizard. Use the MySQL database settings and newly created user for the configuration step.

When install finishes, delete `install` directory and run `iisreset` from the command line to restart the server. 


### References
- [OpenCart deployment on Windows](https://interactivewebs.com/index.php/server-tips/creating-a-new-opencart-deployment-on-a-windows-server-iis/)

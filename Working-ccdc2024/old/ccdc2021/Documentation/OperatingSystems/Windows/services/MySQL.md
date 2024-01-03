# MySQL
## Objective
Launch a MySQL 8 Server on Windows


## Security Analysis

- 
-
-
-

## Testing

Scripted: 

-
-
-
-

Active:

-
-
-
-

## Documentation

-
-
-
-

## Script with Comments

```
wget "https://dev.mysql.com/get/Downloads/MySQLInstaller/mysql-installer-community-8.0.18.0.msi" -outfile "$pwd/MySQL8.msi"

$CMD = 'C:\Program Files (x86)\MySQL\MySQL Installer for Windows/MySQLInstallerConsole.exe'

$Arguements = @('community', 'install', 'server;8.0.18;x64:*:type=config;openfirewall=false;generallog=true;binlog=true;serverid=4000;enable_tcpip=true;port=3306;rootpasswd=passwordhere;installdir="C:\MySQL\MySQL Server 8.0";datadir="C:\MySQL\MySQL Server 8.0\data"', '-silent')

& $CMD $Arguements

$mysql  = 'C:\MySQL\MySQL Server 8.0\bin\mysql_secure_installation.exe'

# SQL Executable
#$user = $env:UserName
$mysql  = 'C:\MySQL\MySQL Server 8.0\bin\mysql_secure_installation.exe'

& $mysql --tls-version=TLSv1.2
# On Prompt
# - Enter password
# - Answer Prompts
# - Should answer yes to all of them, including resetting root password
# - Should set password strength to STRONG (2)



```
Reset passwords - Limited to setting all to one password at the moment
```
CREATE DEFINER=`root`@`localhost` PROCEDURE `ResetPasswords`(IN newPassword VARCHAR(255))
BEGIN
	DECLARE done INT DEFAULT 0;
    DECLARE user_ CHAR(32);
    DECLARE host_ CHAR(255);
    DECLARE accounts CURSOR FOR SELECT User, Host FROM mysql.user WHERE User NOT IN ('root', 'mysql.sys', 'mysql.session', 'mysql.infoschema');
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN accounts;
	
    reset_loop: LOOP
		FETCH accounts INTO user_, host_;
        IF done = 1 THEN
			LEAVE reset_loop;
		END IF;
        SET @str = CONCAT('ALTER USER \'', user_,'\'@\'',host_,'\' IDENTIFIED BY \'', newPassword, '\'');
        PREPARE stmt FROM @str;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
	END LOOP;
    CLOSE accounts;
END
```
## ToDo

- [ ]   
- [ ]   
- [ ]   
- [ ]   

## References

- [MySQL Secure Install parameters](https://dev.mysql.com/doc/refman/8.0/en/mysql-secure-installation.html)
- []()
- []()
- []()

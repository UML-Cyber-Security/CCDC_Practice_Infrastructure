# IIS - Website

## Objective
Create a Website using IIS with MySQL, PHP, and Wordpress.


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

## Script (Procedure) with Comments
Registry Edit to enforce TLSv1.2
```
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols" –Name "TLS 1.0"
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0" –Name "Client"
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0" –Name "Server"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client" -Name "DisabledByDefault" -Value "0x1"  -PropertyType "DWORD"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" -Name "DisabledByDefault" -Value "0x1"  -PropertyType "DWORD"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client" -Name "Enabled" -Value "0x0"  -PropertyType "DWORD"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" -Name "Enabled" -Value "0x0"  -PropertyType "DWORD"
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols" –Name "TLS 1.1"
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1" –Name "Client"
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1" –Name "Server"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client" -Name "DisabledByDefault" -Value "0x1"  -PropertyType "DWORD"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server" -Name "DisabledByDefault" -Value "0x1"  -PropertyType "DWORD"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client -Name "Enabled" -Value "0x0"  -PropertyType "DWORD"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server" -Name "Enabled" -Value "0x0"  -PropertyType "DWORD"
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols" –Name "TLS 1.2"
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2" –Name "Client"
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2" –Name "Server"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client" -Name "DisabledByDefault" -Value "0x0"  -PropertyType "DWORD"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" -Name "DisabledByDefault" -Value "0x0"  -PropertyType "DWORD"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client" -Name "Enabled" -Value "0x1"  -PropertyType "DWORD"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" -Name "Enabled" -Value "0x1"  -PropertyType "DWORD"
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols" –Name "DTLS 1.0"
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\DTLS 1.0" –Name "Client"
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\DTLS 1.0" –Name "Server"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\DTLS 1.0\Client" -Name "DisabledByDefault" -Value "0x1"  -PropertyType "DWORD"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\DTLS 1.0\Server" -Name "DisabledByDefault" -Value "0x1"  -PropertyType "DWORD"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\DTLS 1.0\Client" -Name "Enabled" -Value "0x0"  -PropertyType "DWORD"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\DTLS 1.0\Server" -Name "Enabled" -Value "0x0"  -PropertyType "DWORD"
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols" –Name "DTLS 1.1"
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\DTLS 1.1" –Name "Client"
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\DTLS 1.1" –Name "Server"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\DTLS 1.1\Client" -Name "DisabledByDefault" -Value "0x1"  -PropertyType "DWORD"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\DTLS 1.1\Server" -Name "DisabledByDefault" -Value "0x1"  -PropertyType "DWORD"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\DTLS 1.1\Client" -Name "Enabled" -Value "0x0"  -PropertyType "DWORD"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\DTLS 1.1\Server" -Name "Enabled" -Value "0x0"  -PropertyType "DWORD"
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols" –Name "DTLS 1.2"
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\DTLS 1.2" –Name "Client"
New-Item –Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\DTLS 1.2" –Name "Server"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\DTLS 1.2\Client" -Name "DisabledByDefault" -Value "0x0"  -PropertyType "DWORD"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\DTLS 1.2\Server" -Name "DisabledByDefault" -Value "0x0"  -PropertyType "DWORD"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\DTLS 1.2\Client" -Name "Enabled" -Value "0x1"  -PropertyType "DWORD"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\DTLS 1.2\Server" -Name "Enabled" -Value "0x1"  -PropertyType "DWORD"
```

```
Open Windows Powershell (Admin)
$ Install-WindowsFeature -Name Web-Server -IncludeManagementTools

Download:
MySQL: https://dev.mysql.com/get/Downloads/MySQLInstaller/mysql-installer-community-8.0.19.0.msi
PHP: https://windows.php.net/downloads/releases/php-7.4.3-nts-Win32-vc15-x64.zip
Wordpress: https://wordpress.org/latest.zip

Go to: 
- C:\inetpub\wwwroot
- Extract wordpress folder into this directory
- Create: C:\php
- Extract PHP ZIP contents to C:\php
- Execute the MySQL MSI
	- Select 'Server Only'
	- If need C++ Redistributable then Select 'Execute'
	- Click 'Next'
	- Click 'Execute'
	- Click 'Next'
	- Select 'Standalone'
	- Set 'Config Type' to 'Server Computer'
	- Set Ports and Firwall access as desired
	- In 'Advanced Configuration'
		- Enable all Logs
	- Use strong password encryption (will require a slight modification when making users)
	- Click "Next" until done
- Open MySQL Command Line Client
	- Change directory to 'C:\Program Files\MySQL\MySQL Server 8.0\bin'
	- Run '.\mysql -uroot -p' and login
	- $ CREATE DATABASE WP_DB;
	- $ CREATE USER 'WP_USER'@'localhost' IDENTIFIED WITH mysql_native_password BY 'WP_PASS';
	- $ GRANT ALL ON WP_DB.* TO 'WP_USER'@'localhost';
	- $ FLUSH PRIVILEGES;
- $ cd 'C:\inetpub\wwwroot\wordpress'
- $ Copy-Item -Path 'C:\inetpub\wwwroot\wordpress\wp-config-sample.php' -Destination 'C:\inetpub\wwwroot\wordpress\wp-config.php'
	- Fill in database info
	- Go to https://api.wordpress.org/secret-key/1.1/salt
	- Copy result into file (replace right area)
- $ cd 'C:\php'
 - $ Copy-Item -Path 'C:\php\php.ini-development' -Destination 'C:\php\php.ini'
	- Uncomment 'cgi.force_redirect'
		- Set cgi.force_redirect to 0
	- Uncomment 'fastcgi.impersonate = 1'
	- Uncomment 'cgi.fix_pathinfo=1'
	- Uncomment 'open_basedir'
		- Set open_basedir to C:\inetpub\wwwroot
	- Add (or uncomment for some) following:
		- extension_dir="C:/php/ext"
		- extension=curl
		- extension=gd2
		- extension=mbstring
		- extension=mysqli
		- extension=pdo_mysql
		- extension=xmlrpc
- Add C:/php to Path environment variable
- Go to http://localhost/wordpress/wp-admin/install.php
- Open Server Manager:
	- Add Roles and Features Wizard
	- Click 'Next' until 'Server Roles' is clickable
	- Go to 'Server Roles'
	- Navigate down tree: Web Server (IIS) -> Web Server -> Application Development
		- Select 'CGI'
	- Navigate to: Web Server (IIS) -> Web Server -> Common HTTP Features
		- Select 'HTTP Redirection'
	- Navigate to: .NET Framework 4.6 Features -> WCF Services
		- Select 'HTTP Activation' (this will also select a bunch of other required ones)
	- Click 'Next' until install
- Open IIS Manager:
	- At server level select 'Handler Mappings'
	- Under 'Actions' choose 'Add Module Mapping'
		- Request path: *.php
		- Module: CgiModule
		- Executable: C:\php\php-cgi.exe
		- Name: PHP-CGI
	- Click 'Ok' x2
- Right-click C:\inetpub\wwwroot\wordpress\wp-content
	- Select 'Properties'
	- Select 'Security'
	- Add new User 'IUSR' and give it 'Modify' permissions (along with default)
	- Edit 'IIS_IUSRS' to have 'Modify' permissions
	- Click 'Apply'
- Open IIS Manager
	- Click on 'Sites' under the local server
	- Click 'Add Website'
	- Fill in info	
		- path to site here is C:\inetpub\wwwroot\wordpress (but wordpress should instead be site name really)
	- Click on new Site under 'Sites'
	- Choose 'Authentication'
	- Select 'Anonymous Authentication'
	- Edit and make sure specific user is 'IUSR'
- Right-click C:\Windows\Temp:
	- Select 'Properties'
	- Select 'Security'
	- Select 'Advanced'
	- Click 'Enable Inheritance'
	- Click 'Add'
	- Add 'IIS_IUSRS'
		- Give 'Modify', and click 'Only apply ...' box
- Open IIS Manager
	- Select Site
	- Double-Click 'Default Document'
	- Add 'index.php'
- Go to http://localhost/wordpress/wp-login.php:
	- Login
```

## ToDo

- [ ]   
- [ ]   
- [ ]   
- [ ]   

## References

- [Install Wordpress with IIS](https://zaven.co/blog/install-wordpress-iis/)
- [Enable CGI for PHP](https://docs.microsoft.com/en-us/iis/application-frameworks/install-and-configure-php-on-iis/enable-fastcgi-support-in-iis-7-on-windows-server-2008-windows-server-2008-r2-windows-vista-or-windows-7)
- [Edit Registry Keys with Powershell](https://blog.netwrix.com/2018/09/11/how-to-get-edit-create-and-delete-registry-keys-with-powershell/)
- [Wordpress on IIS Installation](https://docs.microsoft.com/en-us/iis/application-frameworks/install-and-configure-php-applications-on-iis/install-wordpress-on-iis)
- [Modifications to get Wordpress working](https://zaven.co/blog/install-wordpress-iis/)
- [PHP Install](https://www.sitepoint.com/how-to-install-php-on-windows/)

## Qualifier prep
- Come up with 2 good questions
- Linux
	- CentOS
	- LAMP (Linux, Apache, MySQL, PHP/Perl/Python)
		- https://en.wikipedia.org/wiki/LAMP_(software_bundle)
	- Logging
		- https://www.eurovps.com/blog/important-linux-log-files-you-must-be-monitoring/
		- https://hub.docker.com/_/kibana
		- https://sematext.com/blog/getting-started-with-logstash/
		- https://www.syslog-ng.com/community/b/blog/posts/how-to-forward-logs-to-elasticsearch-using-the-elasticsearch-http-destination-in-syslog-ng
		- https://www.bmc.com/blogs/elasticsearch-logs-beats-logstash/
- Networking
	- Netflow
		- https://wiki.vyos.net/wiki/Flow_accounting
		- https://www.elastic.co/guide/en/beats/filebeat/7.5/filebeat-module-netflow.html
	- VyOS
		- https://wiki.vyos.net/wiki/Main_Page
	- Router exercise
- Windows
	- Server Core (minimal server install)
	- DNS
	- IIS (Internet Information Services)
		- https://docs.microsoft.com/en-us/archive/blogs/benjaminperkins/configure-an-iis-server-core-server-for-remote-management
		https://docs.microsoft.com/en-us/archive/blogs/benjaminperkins/configure-an-iis-server-core-server-for-remote-management
	- RDP
	- SMB
	- Logging
		- https://blog.netwrix.com/2018/08/23/auditing-windows-server/
		- https://blog.netwrix.com/2015/11/06/windows-event-log-forwarding-with-powershell/
		- https://adamtheautomator.com/windows-event-log-forwarding/

## Organization
- OpSec procedures
- Objective enumeration and prioritization
- Incident reporting procedure

## Basic services
- HTTP(S)
  - Set/Enforce TLS version
  - Logs
  - Vulnerabilities
  - nginx
  	- https://ma.ttias.be/enable-tls-1-3-nginx/
- SMTP
- POP3
- SSH
- SQL
  - MariaDB
    - https://github.com/kost/docker-alpine/tree/master/alpine-mariadb
    - https://wiki.alpinelinux.org/wiki/MariaDB
    - https://mariadb.com/kb/en/securing-mariadb/
  - MySQL 
    - Most of this also holds for MariaDB, since Maria is a branch of MySQL, and supports much of MySQL syntax
    - [Support platforms](https://www.mysql.com/support/supportedplatforms/database.html)
    - [Installing and Upgrading](https://dev.mysql.com/doc/refman/8.0/en/installing.html)
    - [Post-install](https://dev.mysql.com/doc/refman/8.0/en/postinstallation.html)
    - [Access Control](https://dev.mysql.com/doc/refman/8.0/en/access-control.html)
    - [Administration](https://dev.mysql.com/doc/refman/8.0/en/server-administration.html)
    - [Reset Root](https://dev.mysql.com/doc/refman/8.0/en/resetting-permissions.html)
    - [Windows Restrictions](https://dev.mysql.com/doc/refman/8.0/en/windows-restrictions.html)
    - [Secure Install](https://dev.mysql.com/doc/refman/8.0/en/mysql-secure-installation.html) - **Important**
    - [Command Line Installer - Windows](https://dev.mysql.com/doc/refman/8.0/en/MySQLInstallerConsole.html)
    - [Start from Command Line](https://dev.mysql.com/doc/refman/8.0/en/windows-start-command-line.html)
    - [Get user information](https://www.shellhacks.com/mysql-show-users-privileges-passwords/)
    - [Password Policies](https://dev.mysql.com/doc/mysql-security-excerpt/8.0/en/password-management.html)
- DNS
- FTP

## Operating Systems
- openBSD IDS
    - Second line of defense to router/firewall

- openSUSE vs CentOS? 

- ~~Research minimal + secure kernels like Alpine Linux for potential use on low resource systems~~
Security analysis for Alpine Linux docker containers
    - Lightweight + intrisically hardened
    - ~~Ubuntu minimal instead of full ubuntu install~~

- Ubuntu minimal instead of full Ubuntu install
    - Is there any reason to use Ubuntu over Alpine?
        - What services/programs does Alpine lack?

## Containers
- Docker vs Kubernetes?

- Docker official images have vulnerability scans
  - https://docs.docker.com/docker-hub/official_images/
- Compile list of official docker images which can be useful for us


## Security features

- Backup + integrity checking system
- Password audits + reports
- OpenSCAP scans (security audits) for major operating systems, particularly Windows
	- https://www.open-scap.org/tools/scap-workbench/

- User activity auditing (log setup + analysis)

## SIEM
- Splunk, Elastic stack, Security Onion

## SQL
- General checklist of database security
  - [Good practices](https://www.tecmint.com/mysql-mariadb-security-best-practices-for-linux/)
- Setup guides and common task walkthroughs for MySQL+MariaDB (MariaDB is what has come up most often when I've been researching older competitions)
- Dealing with older software versions (Will an update ever break the db? Gather some important vulnerabilities to be wary of with older version)
- Installation script for Widows + Linux ( Basically translate the setup guide into PowerShell or Bash )
- Quick account remediation scripts ( What if we're given a database that has 10 default password users with full permissions? )
  - Can use mysql_secure_installation (for MariaDB as well)
    - It prompts you with some settings such as pasword strength, removing extra users, and more
  - Can't create secure scripts as you will always need to password authenticate, and it is bad practice to have password in script or part of command (shows in history), and the default prompt doesn't propogate out of a script (freezes Powershell and assume similar with Bash)
- Test exercise that will put the scripts to the test

## Windows
- Windows account management
    - In preparation for a scenario in which we would have a lot of user accounts to deal with.
    Basically find the fastest and easiest way to change blank and default password accounts.
    - https://stackoverflow.com/questions/47392876/changing-active-directory-password-via-batch
    - https://www.digitalcitizen.life/how-generate-list-all-user-accounts-found-windows
  
- Windows AD, AD group policy
- Powershell
	- https://www.quadrotech-it.com/blog/allowing-powershell-scripts-to-execute/


## Linux 
- firejail configurations
    - Serving jailed services for white team requests
- Linux script for quickly remediating bad passwords (Joel)
    - A script that lists users with no password: [here](../../Scripts/blankpass.sh)


## encountered in previous CCDC
- Debian, Linux 3.2, doesn't boot (bullfrog)
- Debian, Linux 2.6, 512 Mb memory (porkchop express)
	- java jdk/jre 5
	- sslexplorer 1.0.0_RC17
- Windows Vista Business 2GB memory (in1-pod0-papabear)
- Ubuntu 16.04.3 LTS 512 MB memory (inv1-pod0-dashboard)
	- kimai 1.1.0
	- phpMyAdmin 4.7.7
	- Lots of users with no data in their /home folder
- Alpine linux, 256 MB memory (pigfoot)
	- setup-router.sh
- Ubuntu, Linux 4.15, 1.5Gb memory (antonidas)
	- spreecommerce docker image 
	- Grandnode webapp
	- nginx 1.10.3
- CentOS 7, 2Gb memory (elphaba)
- Ubuntu 3.18, 512 Mb memory (generam)
- Alpine linux (merlin)
	- router (haven't pulled setup script)
- Arch linux, doesn't boot (sedridor)
- Ubuntu 32 bit  512 MB memory, boot problems (just black screen) (mrwizard) 
- Arch linux 64 bit, boot problems due to mounting problem, 512 MB memory (jafar)
- Windows 2008, 2048 MB memory, 32 bit (but requires 64 bit hardware?), boot problems, you need to set VM to 64 bit (malificent)

- Windows Vista Business 2GB memory (gm-bridges-clamps-aviator)
- ReactOS 0.4.10, NT 5.2 (gm-bridges-clamps-champagne)
	- samba-tng
	- dplus browser 0.5
	- Opera 1218
	- samba-for-reactOS
	- tightvnc-2.8.11
	- ultraVNC 1_2_17x86
	- kompozer-0.7.10-win32
	- hiawatha-9.15
	- firefox 2048.0.2
- Windows Vista Businsess (gm-bridges-clamps-kyle)
- FreeNAS (gm-bridges-clamps-professor)
- Windows Server 2012 R2 (gm-bridges-clamps-rooster)
- FreeBSD (gm-bridges-clamps-thegiver)

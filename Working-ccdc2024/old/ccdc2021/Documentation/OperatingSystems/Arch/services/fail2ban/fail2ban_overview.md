(SOURCE, ALMOST WORD FOR WORD... : https://www.a2hosting.com/kb/security/hardening-a-server-with-fail2ban)

INSTALLATION:

For Debian and Ubuntu, type the following command:

	apt-get install fail2ban

For CentOS and Fedora, type the following command:

	yum install fail2ban

Arch(??):
	pacman -S fail2ban


CONFIGURATION:

1. Log insto server via SSH
2. At the command prompt, type the following command:

	cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

	Explanation:
		The jail.conf file contains a basic configuration that you can use as a starting point, but it may be overwritten during updates. Fail2ban uses the separate                 jail.local file to actually read your configuration settings.

3. Open jail.local in preferred text editor
4. Configure GLOBAL options***:

	Locate the [DEFAULT] section, which contains the following global options:

    	ignoreip: This option enables you to specify IP addresses or hostnames that fail2ban will ignore. For example, you could add your home or office IP address so fail2ban 		  does not prevent you from accessing your own server. To specify multiple addresses, separate them with a space. For example:

    			ignoreip = 127.0.0.1/8 93.184.216.34

    	bantime: This option defines in seconds how long an IP address or host is banned. The default is 600 seconds (10 minutes).

    	maxretry: This option defines the number of failures a host is allowed before it is banned.

    	findtime: This option is used together with the maxretry option. If a host exceeds the maxretry setting within the time period specified by the findtime option, it is 		          banned for the length of time specified by the bantime option.

5. With fail2ban's global options configured, you are now ready to enable and disable jails for the specific protocols and services you want to protect***. 
	By default, fail2ban monitors SSH login attempts (you can search for the [ssh-iptables] section in the jail.local file to view the specific settings for the SSH jail).

	The jail.local file includes default jail settings for several protocols. 
	Often, all you need to do to enable a jail is change its enabled = false line to enabled = true and restart fail2ban. 
	You can also define custom jails and filters for additional flexibility. 
	For more information about how to do this, please visit http://www.fail2ban.org/wiki/index.php/MANUAL_0_8.
	For more information on jails, Jail Options, and Filters, visit https://www.fail2ban.org/wiki/index.php/MANUAL_0_8#Jails

6. Save your changes to the jail.local file.

7. To restart the fail2ban service and load the new configuration, type the following command***:

	service fail2ban restart

8. To display a list of IP addresses currently banned by fail2ban, type the following command:

	iptables -S
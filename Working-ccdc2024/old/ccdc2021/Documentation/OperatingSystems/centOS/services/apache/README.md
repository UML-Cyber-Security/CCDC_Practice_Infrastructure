# Apache

## Objective

Install and provide basic security for an Apache webserver

## Security Analysis

- If users connect to the browser with http, traffic is unencrypted and can be viewed by the attacked
  - Force redirection to https

## Testing

Scripted: 

- Check if `systemctl` started the `httpd` without errors
  - Run `systemctl status httpd -l`
    - Expected
- Check if the `apache` configuration is good
  - Run ` apachectl configtest`
    - Expected
- Ask `localhost` to serve the website to test actual content
  - Run `curl 127.0.0.1`
    - Expected
- Confirm that `yum` installed `httpd` and `mod-ssl` without errors
  - Run `runEcho "yum install httpd mod_ssl -y"` (runEcho is a function in the script)
    - Expected: `Complete!` in stdout if install was successful
    - Expected: `Nothing to do` in stdout if script is being re-run and there were no changes

Active:

- None!

## Documentation

- Open ssl command: `openssl req -new -newkey rsa:2048 -days 7 -nodes -x509 -subj "/C=US/ST=fakeState/L=faceCity/CN=$SERVERNAME" -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt`
- `ssl.conf`
- `httpd.conf`
- `ssl-params.conf`


## Script with Comments

```bash
#!/bin/bash

# A flag that will be used to control if each command writes
#everything to stdout, or just one line
VERBOSE=false

# Just echos the text with the extra newline at the end
Echo () {
	echo ">>>$1"
	echo
}

# Echos the command to run and then either writes one line
#to stdout or everything depending on the VERBOSE flag
runEcho () {
	cmd=$1
	echo ">>>$cmd"
	if [ "$VERBOSE" = true ]; then
		eval "$cmd"
	else
		result=$(eval "$cmd" | tail -n 1)
		echo "$result"
	fi
	echo
}

# Doesn't execute the script unless the user invoked sudo,
#or is running as root
if [ "$EUID" -ne 0 ]
  then echo ">>>Please run as root"
  exit
fi

# Basic command line parser checking if there's a help
#flag-- if so, displays usuage
for arg in "$@"
do
	if [ $arg == "--help" ]  ||  [ $arg == "-h" ]; then
		echo "Usage: ./secureApache.sh [apache server name]"
		echo "-v at the end for verbose mode"
	fi
done

# Ensures that there's at least one command line argument
#This check could be much tighter
if [ $# -lt 1 ]; then
	echo "sudo ./secureApache.sh [apache server name] [optional -v flag]"
	exit 1
fi

# If -v flag is given, toggle VERBOSE
if [ "$2" = "-v" ]; then
	VERBOSE=true
fi

# Grabbing server name
SERVERNAME="$1"

# Install basic packages
runEcho "yum update httpd mod_ssl"
runEcho "yum install httpd mod_ssl -y"

# Ensure required directories are built
runEcho "mkdir /etc/ssl/private/ /etc/httpd/sites-available /etc/httpd/sites-enabled"

# Make a self signed certificate and it's private key
runEcho "openssl req -new -newkey rsa:2048 -days 7 -nodes -x509 -subj "/C=US/ST=fakeState/L=faceCity/CN=$SERVERNAME" -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt"

# Make the ssl-params configuration file
runEcho "touch /etc/httpd/conf/ssl-params.conf"

# Write to the ssl-parms configuration file
Echo "Making /etc/httpd/conf/ssl-params.conf"

cat <<EOF >/etc/httpd/conf/ssl-params.conf
SSLCipherSuite EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH
SSLProtocol All -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
SSLHonorCipherOrder On
Header always set X-Frame-Options DENY
Header always set X-Content-Type-Options nosniff
SSLCompression off
SSLUseStapling on
SSLStaplingCache "shmcb:logs/stapling-cache(150000)"
SSLSessionTickets Off
EOF

# Write to the ssl.conf file
Echo 'Making /etc/httpd/conf.d/ssl.conf'

cat <<EOF >/etc/httpd/conf.d/ssl.conf
<VirtualHost *:443>
	DocumentRoot /var/www/html
	ServerName "$SERVERNAME"
	SSLEngine on
	SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
	SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
</VirtualHost>
EOF

# Write to the httpd.conf file
Echo "Making /etc/httpd/conf/httpd.conf"

cat << EOF >/etc/httpd/conf/httpd.conf
<VirtualHost *:80>
        ServerName www.example.com
        Redirect "/" "https://example.com/"
</VirtualHost>
EOF

# Make a link to enable a site
runEcho "ln -s /etc/httpd/sites-available/$SERVERNAME.conf /etc/httpd/sites-enabled/$SERVERNAME.conf"

# Test the apache configuration
runEcho "apachectl configtest"

# Restart httpd and print it's status
runEcho "systemctl restart httpd"
runEcho "systemctl status httpd -l"

# Open up the firewall to allow http traffic and reload
runEcho "firewall-cmd --zone=public --add-service=http --permanent"
runEcho "sudo firewall-cmd --reload"
```

## ToDo

- [ ] Fix error: `apachectl configtest` produces `AH00534: httpd: Configuration error: No MPM loaded.` 
- [ ] Complete documentation of apache / httpd items and DNSSEC
- [x] Add comments to script
- [ ] Add test results
- [ ] Script currently runs `ln -s /etc/httpd/sites-available/$SERVERNAME.conf /etc/httpd/sites-enabled/$SERVERNAME.conf` but the actual configuration file names were changed
- [ ] Unsure if `runEcho "touch /etc/httpd/conf/ssl-params.conf"` is necesarry anymore-- the other file creation commands don't pre-touch their files
- [ ] Script executes `runEcho "firewall-cmd --zone=public --add-service=http --permanent"`, but we want `https` traffic only
- [ ] Add version banner removal
- [ ] Add validation of external visibility

## References

- [Apache on CentOS 7](https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-centos-7)
- [Redirecting http traffic to https](https://medium.com/@hbayraktar/how-to-install-ssl-certificate-on-apache-for-centos-7-38c25b84d8b1)

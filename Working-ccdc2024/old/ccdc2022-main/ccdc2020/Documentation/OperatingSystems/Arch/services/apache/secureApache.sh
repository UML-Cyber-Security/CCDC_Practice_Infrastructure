#!/bin/bash

#Check all arguments, and if there's a help flag, print the message
for arg in "$@"
do
	if [ $arg == "--help" ]  ||  [ $arg == "-h" ]; then
		echo "sudo ./secureApache.sh [apache server address]"
	fi
done

#Make sure there's at least one argument, preferably the IP lol
if [ $# -ne 1 ]; then
	echo "sudo ./secureApache.sh [apache server address]"
	exit 1
fi

#Exapnd the command line argument and shove into the varibale IP
IP="$1"

#the following is for testing, in case you goof the config files like I did
sudo dpkg -r apache2
sudo dpkg -P apache2
sudo apt-get install apache2

#Make a self signed certificate and the servers private key
sudo openssl req -new -newkey rsa:2048 -days 7 -nodes -x509 \
	-subj "/C=US/ST=fakeState/L=faceCity/CN=$IP" \
	-keyout /etc/ssl/private/apache-selfsigned.key \
	-out /etc/ssl/certs/apache-selfsigned.crt 

#Create the tls parameters configruation file, which we fill fill momentarily
sudo touch /etc/apache2/conf-available/ssl-params.conf

#Place the following text into ssl-params.conf, read other comments for purpose
cat <<EOF >/etc/apache2/conf-available/ssl-params.conf
SSLCipherSuite EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH
SSLProtocol All -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
SSLHonorCipherOrder On
# Disable preloading HSTS for now.  You can use the commented out header line that includes
# the "preload" directive if you understand the implications.
# Header always set Strict-Transport-Security "max-age=63072000; includeSubDomains; preload"
Header always set X-Frame-Options DENY
Header always set X-Content-Type-Options nosniff
# Requires Apache >= 2.4
SSLCompression off
SSLUseStapling on
SSLStaplingCache "shmcb:logs/stapling-cache(150000)"
# Requires Apache >= 2.4.11
SSLSessionTickets Off
EOF

#Back ups!
sudo cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.bak

#Make the file to use when connecting to the server securely
cat <<EOF >/etc/apache2/sites-available/default-ssl.conf
<IfModule mod_ssl.c>
        <VirtualHost _default_:443>
                ServerAdmin fakeEmail@gmail.com
                ServerName $IP

                DocumentRoot /var/www/html

                ErrorLog ${APACHE_LOG_DIR}/error.log
                CustomLog ${APACHE_LOG_DIR}/access.log combined

                SSLEngine on

                SSLCertificateFile      /etc/ssl/certs/apache-selfsigned.crt
                SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key

                <FilesMatch "\.(cgi|shtml|phtml|php)$">
                                SSLOptions +StdEnvVars
                </FilesMatch>
                <Directory /usr/lib/cgi-bin>
                                SSLOptions +StdEnvVars
                </Directory>

        </VirtualHost>
</IfModule>
EOF

#Force hTTP to redirect to HTTPS
sed -i "/<VirtualHost \*:80>/a Redirect permanent / https://$IP" \
	/etc/apache2/sites-available/000-default.conf

#Basically, start the apache2 stuff-- most of this will already be on, but oh well
sudo a2enmod ssl
sudo a2enmod headers
sudo a2ensite default-ssl
sudo a2enconf ssl-params
sudo apache2ctl configtest
sudo systemctl restart apache2

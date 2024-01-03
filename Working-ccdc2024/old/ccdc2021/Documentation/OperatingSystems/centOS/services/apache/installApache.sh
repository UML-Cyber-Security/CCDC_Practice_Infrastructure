#!/bin/bash
VERBOSE=false

Echo () {
	echo ">>>$1"
	echo
}

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

if [ "$EUID" -ne 0 ]
  then echo ">>>Please run as root"
  exit
fi

for arg in "$@"
do
	if [ $arg == "--help" ]  ||  [ $arg == "-h" ]; then
		echo "Usage: ./secureApache.sh [apache server name]"
		echo "-v at the end for verbose mode"
	fi
done

if [ $# -lt 1 ]; then
	echo "sudo ./secureApache.sh [apache server name] [optional -d flag]"
	exit 1
fi

if [ "$2" = "-d" ]; then
	VERBOSE=true
fi

SERVERNAME="$1"

runEcho "yum update httpd mod_ssl"
runEcho "yum install httpd mod_ssl -y"
runEcho "mkdir /etc/ssl/private/ /etc/httpd/sites-available /etc/httpd/sites-enabled"
runEcho "openssl req -new -newkey rsa:2048 -days 7 -nodes -x509 -subj "/C=US/ST=fakeState/L=faceCity/CN=$SERVERNAME" -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt"
runEcho "touch /etc/httpd/conf/ssl-params.conf"

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

Echo "Making /etc/httpd/conf/httpd.conf"

cat << EOF >/etc/httpd/conf/httpd.conf
<VirtualHost *:80>
        ServerName www.example.com
        Redirect "/" "https://example.com/"
</VirtualHost>
EOF

runEcho "ln -s /etc/httpd/sites-available/$SERVERNAME.conf /etc/httpd/sites-enabled/$SERVERNAME.conf"
runEcho "apachectl configtest"
runEcho "systemctl restart httpd"
runEcho "systemctl status httpd -l"
runEcho "firewall-cmd --zone=public --add-service=http --permanent"
runEcho "sudo firewall-cmd --reload"

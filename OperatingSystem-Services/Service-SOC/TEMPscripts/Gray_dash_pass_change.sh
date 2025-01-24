#!/bin/bash
# Script should change the dashboard password for Graylog

# Generate a random password secret
password_secret=$(< /dev/urandom tr -dc A-Z-a-z-0-9 | head -c${1:-96};echo;)

# Ask the user to enter a new root password and hash it
echo -n "Enter Password: "
read -s root_password
echo
root_password_sha2=$(echo -n "$root_password" | sha256sum | cut -d" " -f1)

# Update the server.conf file
config_file="/etc/graylog/server/server.conf"
sed -i "s/^password_secret =.*/password_secret = $password_secret/" $config_file
sed -i "s/^root_password_sha2 =.*/root_password_sha2 = $root_password_sha2/" $config_file

systemctl restart graylog-server

echo "Configuration updated successfully."
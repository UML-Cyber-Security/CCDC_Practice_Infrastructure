#!/bin/bash
# Script installs Graylog Sidecar on ANY linux machine
# Run this on the "AGENT" machine!

if [ "$EUID" -ne 0 ]; then
  echo "Must run as superuser"
  exit
fi

read -p "Select your Linux system type:
1. Ubuntu or Debian
2. CentOS or RedHat
Enter your choice (1 or 2): " linux_system

if [ "$linux_system" != "1" ] && [ "$linux_system" != "2" ]; then
    echo "Invalid input. Please enter 1 or 2."
    exit 1
fi

read -p "Enter GRAYLOG server API ip (Ex: http://<IP_HERE>:9000/api): " manager_ip
read -p "Enter the API token from GRAYLOG machine (DO NOT SKIP THIS): " gray_token

#config_file="/etc/graylog/sidecar/sidecar.yml"

#if [[ ! -f "$config_file" ]]; then
#  echo "Error: Configuration file not found at $config_file"
#  exit 1
#fi

# Uninstall original agent below
if [ "$linux_system" == "1" ]; then
    wget https://packages.graylog2.org/repo/packages/graylog-sidecar-repository_1-5_all.deb
    sudo dpkg -i graylog-sidecar-repository_1-5_all.deb
    sudo apt-get update
    sudo apt-get install graylog-sidecar

    sed -i.bak \
        -e "s|#server_url:.*|server_url: \"$new_server_url\"|" \
        -e "s|server_api_token:.*|server_api_token: \"$new_api_token\"|" \
        "$config_file"

    sudo graylog-sidecar -service install

    sudo systemctl enable graylog-sidecar
    sudo systemctl start graylog-sidecar
elif [ "$linux_system" == "2" ]; then
    echo "Choice 2 was chosen"
fi




echo -e "\n-----------------------------------------"
echo -e "\n-----------------------------------------\nAttempting to download and install Sidecar...n"

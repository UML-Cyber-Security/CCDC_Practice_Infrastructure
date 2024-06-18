#!/bin/sh

# Author: Chris Morales
# NOTE: This is UNTESTED as of the time of the inital commit in March 2024.
# My machine does not have a single machine (host or WSL machine) that matches all the
# prerequisites. And so I'm writing this from a theoretical and logical perspective.

# First, need to run terraform
cd Terraform || exit

echo "[1/3] Deploying Terraform Configuration"

# Now, deploy Terraform configuration. User input is required.
terraform apply

# Now lets wait for 2 minutes.
echo "Waiting for 2 minutes to allow instances to come alive and SSH on Wireguard to start"
sleep 2m


echo "[2/3] Gathering Credentials and creating Ansible inventory"
python gather-credentials.py

# Move the blackteam-inventory.yml file to Ansible
mv blackteam-inventory.yml ../Ansible/


# Change directory to Ansible 
cd ../Ansible || exit

echo "[3/3] Running Ansible to deploy Wireguard and get corresponding VPN certs."

# Run the ansible-playbook
ansible-playbook -i blackteam-inventory.yml initalize-environment.yml



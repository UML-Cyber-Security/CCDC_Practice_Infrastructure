#!/bin/bash 

# Usage: ./Setup-CA-Server.sh  
# A folder named "pki" will be created in the current directory and will hold all files relating to the CA 

# 1. Create CA pki folder 
easyrsa init-pki 

# 2. Buid CA (will ask for Common Name)
easyrsa build-ca nopass
#!/bin/bash

# Usage: ./Create-Certificate.sh <hostname> <key_to_create>

export EASYRSA_BATCH=1
easyrsa="/usr/share/easy-rsa/easyrsa"

# 1. Create CSR
$easyrsa gen-req $1 nopass

# 2. Import CSR into CA server
$easyrsa import-req $2 $1

# 3. Sign CSR & Create Certificate
$easyrsa sign-req server $1

# 4. Cat into pem 
cat pki/issued/$1.crt pki/private/$1.key > $1.pem
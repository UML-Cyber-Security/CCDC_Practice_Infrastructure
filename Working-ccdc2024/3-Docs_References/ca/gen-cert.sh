#!/bin/bash

# create root key (we only need one)
openssl req -x509 -newkey rsa:4096 -sha256 -nodes -out root-ca.key -outform PEM

# create a CSR (to be signed with root ca)
openssl req -newkey rsa:2048 -nodes -keyout PRIVATEKEY.key -out MYCSR.csr

# sign CSR and produce signed cert
openssl x509 -req -days 360 -in csr/MYCSR.csr -CA root/root-ca.key -CAkey root/privkey.pem -CAcreateserial -out server.crt


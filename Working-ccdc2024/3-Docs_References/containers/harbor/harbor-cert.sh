#!/bin/bash

# Generate a Certificate Authority Certificate
# Generate a CA certificate private key.
openssl genrsa -out ca.key 4096

# Generate the CA certificate.
openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=US/ST=Lowell/L=UML/O=CS/OU=ccdc/CN=harbor.cyber.uml.edu" \
 -key ca.key \
 -out ca.crt


# Generate a Server Certificate
# Generate a private key.
openssl genrsa -out harbor.key 4096

# Generate a certificate signing request (CSR).
openssl req -sha512 -new \
 -subj "/C=US/ST=Lowell/L=UML/O=CS/OU=ccdc/CN=harbor.cyber.uml.edu" \
    -key harbor.key \
    -out harbor.csr


# Generate an x509 v3 extension file.
# Regardless of whether you’re using either an FQDN or an IP address to connect to your Harbor host, you must create this file so that you can generate a certificate for your Harbor host that complies with the Subject Alternative Name (SAN) and x509 v3 extension requirements. Replace the DNS entries to reflect your domain.
cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=harbor.cyber.uml.edu
DNS.2=harbor.cyber.uml
DNS.3=harbor
EOF

# Use the v3.ext file to generate a certificate for your Harbor host.
# Replace the harbor in the CRS and CRT file names with the Harbor host name.
openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in harbor.csr \
    -out harbor.crt


# Provide the Certificates to Harbor and Docker
# After generating the ca.crt, harbor.crt, and harbor.key files, you must provide them to Harbor and to Docker, and reconfigure Harbor to use them.
# Copy the server certificate and key into the certficates folder on your Harbor host.
cp harbor.crt /data/cert/
cp harbor.key /data/cert/

# Convert harbor.crt to harbor.cert, for use by Docker.
openssl x509 -inform PEM -in harbor.crt -out harbor.cert

# Copy the server certificate, key and CA files into the Docker certificates folder on the Harbor host. You must create the appropriate folders first.
cp harbor.cert /etc/docker/certs.d/harbor/
cp harbor.key /etc/docker/certs.d/harbor/
cp ca.crt /etc/docker/certs.d/harbor/


# If you mapped the default nginx port 443 to a different port, create the folder /etc/docker/certs.d/harbor:port, or /etc/docker/certs.d/harbor_IP:port.

sudo systemctl restart docker

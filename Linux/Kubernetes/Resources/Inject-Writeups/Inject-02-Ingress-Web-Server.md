# Inject 02 Ingress Web Server

## Task

In the previous task you successfully deployed the web server on an external IP address. We now want the clients to be able to access the web server with our domain name, therefore you need to find a way to use a domain to browse to the server instead of an IP Address.

---

**Below should not be included when giving this inject out**

## What this inject requires

- Some type of Ingress (Traefik, Nginx Ingress Controller, etc.)
- Without introducing certificates, this will require you to add the IP address and Domain name manually into the "clients" hosts file.
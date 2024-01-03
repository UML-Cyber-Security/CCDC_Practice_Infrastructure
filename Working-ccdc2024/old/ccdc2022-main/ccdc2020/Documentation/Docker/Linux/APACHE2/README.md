# Goal

Implement an `Apache2` server on a Docker container with the following capabilities -

* Supports HTTP and HTTPS *static* sites
* Disables server banner
* Disables SSL/TLS versions below 1.2
* Restricts container to `apache` user


# Steps

1. Place all config files to be pushed to `/etc/apache2` directory inside the `apache2/` directory. Note the following -
    * The server banner is disabled in the `httpd.conf` file.
    * The server keys and allowed SSL/TLS versions are set in the `conf.d/ssl.conf` file.
    * The `VirtualHost` configuration is specified in the `sites-available` directory. A symlink to these files is specified in the `sites-enabled` directory. Note that this setup doesn't force all HTTP packets to HTTPS. This can be done by editing the `sites-available/default` file.
    * The build process generates the server keys using `easyrsa`. The `easyrsa` configuration is specified in the `vars` file.

    There is a directory called `orig_files` that contains the original files. Use tool like `diff` or `meld` to view all the changes.

2. Build the Docker image from the directory containing the Dockerfile using the following command: `docker build -t <IMAGE_TAG> .`

    **Example:** `docker build -t apache2 .`

3. Run the Docker container using the following command: `docker run -d --name <CONTAINER_NAME> <IMAGE_TAG>`

    **Example:** `docker run -d --name apache2 apache2`


# Tests

## Nmap Output

```
sashank@sndp> nmap -sV 172.17.0.2
Starting Nmap 7.80 ( https://nmap.org ) at 2020-01-21 11:00 EST
Nmap scan report for 172.17.0.2
Host is up (0.00015s latency).
Not shown: 998 closed ports
PORT    STATE SERVICE  VERSION
80/tcp  open  http     Apache httpd
443/tcp open  ssl/http Apache httpd

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 12.59 seconds
```

## Curl Outputs

### HTTP

```
sashank@sndp> curl -v http://172.17.0.2
*   Trying 172.17.0.2:80...
* TCP_NODELAY set
* Connected to 172.17.0.2 (172.17.0.2) port 80 (#0)
> GET / HTTP/1.1
> Host: 172.17.0.2
> User-Agent: curl/7.65.3
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Date: Tue, 21 Jan 2020 16:02:28 GMT
< Server: Apache
< Last-Modified: Mon, 20 Jan 2020 19:41:53 GMT
< ETag: "1c-59c977bb4e240"
< Accept-Ranges: bytes
< Content-Length: 28
< Content-Type: text/html
< 
<h1>Static Pages Work!</h1>
* Connection #0 to host 172.17.0.2 left intact
```

### TLS 1.0 and TLS 1.1

```
sashank@sndp> curl -v --insecure --tls-max 1.1 https://172.17.0.2
*   Trying 172.17.0.2:443...
* TCP_NODELAY set
* Connected to 172.17.0.2 (172.17.0.2) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: none
  CApath: /etc/ssl/certs
* TLSv1.1 (OUT), TLS handshake, Client hello (1):
* TLSv1.1 (IN), TLS alert, protocol version (582):
* error:1409442E:SSL routines:ssl3_read_bytes:tlsv1 alert protocol version
* Closing connection 0
curl: (35) error:1409442E:SSL routines:ssl3_read_bytes:tlsv1 alert protocol version
```

### TLS 1.2 and TLS 1.3

```
sashank@sndp> curl -v --insecure --tls-max 1.2 https://172.17.0.2
*   Trying 172.17.0.2:443...
* TCP_NODELAY set
* Connected to 172.17.0.2 (172.17.0.2) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: none
  CApath: /etc/ssl/certs
* TLSv1.2 (OUT), TLS handshake, Client hello (1):
* TLSv1.2 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
* TLSv1.2 (IN), TLS handshake, Server finished (14):
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
* TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (OUT), TLS handshake, Finished (20):
* TLSv1.2 (IN), TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-RSA-AES256-GCM-SHA384
* ALPN, server accepted to use http/1.1
* Server certificate:
*  subject: C=US; ST=ME; L=Rivers Bend; O=Dirigo Cyber, LLC; OU=IT; CN=web.dirigo.org; emailAddress=it@dirgio.org
*  start date: Jan 21 16:00:09 2020 GMT
*  expire date: Jan 20 16:00:09 2021 GMT
*  issuer: C=US; ST=ME; L=Rivers Bend; O=Dirigo Cyber, LLC; OU=IT; CN=web.dirigo.org; emailAddress=it@dirgio.org
*  SSL certificate verify result: unable to get local issuer certificate (20), continuing anyway.
> GET / HTTP/1.1
> Host: 172.17.0.2
> User-Agent: curl/7.65.3
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Date: Tue, 21 Jan 2020 16:04:03 GMT
< Server: Apache
< Last-Modified: Mon, 20 Jan 2020 19:41:53 GMT
< ETag: "1c-59c977bb4e240"
< Accept-Ranges: bytes
< Content-Length: 28
< Content-Type: text/html
< 
<h1>Static Pages Work!</h1>
* Connection #0 to host 172.17.0.2 left intact


sashank@sndp> curl -v --insecure --tls-max 1.3 https://172.17.0.2
*   Trying 172.17.0.2:443...
* TCP_NODELAY set
* Connected to 172.17.0.2 (172.17.0.2) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: none
  CApath: /etc/ssl/certs
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.3 (IN), TLS handshake, Certificate (11):
* TLSv1.3 (IN), TLS handshake, CERT verify (15):
* TLSv1.3 (IN), TLS handshake, Finished (20):
* TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.3 (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384
* ALPN, server accepted to use http/1.1
* Server certificate:
*  subject: C=US; ST=ME; L=Rivers Bend; O=Dirigo Cyber, LLC; OU=IT; CN=web.dirigo.org; emailAddress=it@dirgio.org
*  start date: Jan 21 16:00:09 2020 GMT
*  expire date: Jan 20 16:00:09 2021 GMT
*  issuer: C=US; ST=ME; L=Rivers Bend; O=Dirigo Cyber, LLC; OU=IT; CN=web.dirigo.org; emailAddress=it@dirgio.org
*  SSL certificate verify result: unable to get local issuer certificate (20), continuing anyway.
> GET / HTTP/1.1
> Host: 172.17.0.2
> User-Agent: curl/7.65.3
> Accept: */*
> 
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* old SSL session ID is stale, removing
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Date: Tue, 21 Jan 2020 16:04:26 GMT
< Server: Apache
< Last-Modified: Mon, 20 Jan 2020 19:41:53 GMT
< ETag: "1c-59c977bb4e240"
< Accept-Ranges: bytes
< Content-Length: 28
< Content-Type: text/html
< 
<h1>Static Pages Work!</h1>
* Connection #0 to host 172.17.0.2 left intact
```
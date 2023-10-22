# HAProxy
This is a repository detailing the setup and configuration of the HAProxy system used in the Practice infrastructure. 

## Table of Contents <!-- omit from toc -->
- [HAProxy](#haproxy)
  - [Setup VM](#setup-vm)
  - [Setup HAProxy](#setup-haproxy)
  - [PFSense Modifcations](#pfsense-modifcations)
  - [Example Final Config](#example-final-config)
    - [Reference](#reference)

## Setup VM
The Setup of the VM is as follows 
1. Create a Linux Server VM. This should have 1 CP and 2 - 4 GB of RAM.
2. Attach the VM to the DMZ Interface.
3. Start the VM, configure as any other normal device
4. Install HAProxy
    ```
    sudo apt install haproxy
    ```
**Note** Modifications to PFSense will be in the section [PFSense Modifcations](#pfsense-modifcations), and refer to the [Expose Services](./../../Network/PFSense/2-Expose_Services.md) Document.

## Setup HAProxy
1. Generate a X509 Cert and key using Open SSL (We are using a self signed certificate). Store this in a well known location 
        ```
        sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/haproxy.pem -out /etc/ssl/certs/haproxy_cert.pem
        ```  
   * The common name in this certificate should be the **IP or Domain name if we have external DNS resolution of the WAN interface** 
2. HAProxy uses a combined CERT + PEM format when enabiling SSL in a frontend, we can create this file with the following command 
        ```
        sudo cat /etc/ssl/certs/haproxy_cert.pem /etc/ssl/private/haproxy.pem > server.pem && \
        sudo mv server.pem /etc/haproxy/server.pem

        ```
   * You may want to store this file in a more secure area!
3. Open ```/etc/haproxy/haproxy.cfg```, there may be some default configurations. If not we can add them as shown below
        ```cfg   
        global
                log /dev/log    local0
                log /dev/log    local1 notice
                chroot /var/lib/haproxy
                stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
                stats timeout 30s
                user haproxy
                group haproxy
                daemon

                # Default SSL material locations
                ca-base /etc/ssl/certs
                crt-base /etc/ssl/private

                # Default ciphers to use on SSL-enabled listening sockets.
                # For more information, see ciphers(1SSL). This list is from:
                #  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
                # An alternative list with additional directives can be obtained from
                #  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
                ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
                ssl-default-bind-options no-sslv3

        defaults
                log     global
                mode    http
                option  httplog
                option  dontlognull
                timeout connect 5000
                timeout client  50000
                timeout server  50000
                errorfile 400 /etc/haproxy/errors/400.http
                errorfile 403 /etc/haproxy/errors/403.http
                errorfile 408 /etc/haproxy/errors/408.http
                errorfile 500 /etc/haproxy/errors/500.http
                errorfile 502 /etc/haproxy/errors/502.http
                errorfile 503 /etc/haproxy/errors/503.http
                errorfile 504 /etc/haproxy/errors/504.http
        ```
   * You may want to increase the timeouts in the default section as shown in the image below 
        ![Increase Time](Images/HA-Time.png)
4. We will want to create a frontend for both HTTP and HTTPS. At the bottom of the file add 
        ```
        # Define a Frontend 
        frontend fe_<name>
                # Explicit HTTP (app) layer proxy
                mode http
                # Listen on port 808X, associate ssl/tls connections with the cert specified
                bind *:808X ssl crt /path/to/cert
        ```
   * Replace **/path/to/cert** with the path the to the cert + pem file created in step 2!
   * Replace name with the service this is for
   * Replace X in 8080 with an increasing number to distinguish services
5. Next we will want to redirect **all** HTTP traffic to be SSL/TLS traffic we can add the following line to achieve this
        ```
        # Unless already HTTPS (ssl) redirect to HTTPS
        http-request redirect scheme https unless { ssl_fc }
        ```
6. Now we can define the backend that will be used
        ```
        use_backend be_<name>
        ```
   * Replace \<name\> with the name of the service
7.  Repeat steps 4 - 6 until all services have a frontend
8.  Now that we know every backend we will need, we can create a backend **for each** of the servers we are forwarding to
        ```
        backend be_teleport
                # Layer 7 application
                mode http
                # Forward to teleport without authenticating ssl cert - add to trusted and remove verify none
                server ccdcteleport.DMZ-UML:443 ssl verify none

        backend be_DMZ
                mode http
                # Ip Hard coded, change if you change the DMZ Router Interface IP
                server 10.0.1.1

        backend be_Linux
                mode http
                # Ip Hard coded, change if you change the DMZ Router Interface IP
                server <IP/DNS>

        backend be_Windows
                mode http
                # Ip Hard coded, change if you change the DMZ Router Interface IP
                server <IP/DNS>
        
        # More Backends can be created in the manner 
        # backend <name> 
                mode http
                server <IP/DNS>
        ```

## PFSense Modifcations
1. Create Forwards for each frontend in the DMZ Firewall as described in the [Expose_Services](./../../Network/PFSense/2-Expose_Services.md) Doc.
        
    <img src="Images/F1.png" width=800>

2. We will (From the **INTERNAL ROUTERS**) Modify the allowed HTTP_REFER values, this is because of the error you will see below. We need to do this from a SSH tunnel as we cannot use the proxy access until this has been done.

    <img src="Images/F2.png" width=800>

3. Access Advanced options for Admin Access

    <img src="Images/F3.png" width=800>

4. Disable HTTP_REFER
    
    <img src="Images/F4.png" width=800>

## Example Final Config
Of course this is not a complete configuration as servers or services may be added as time progresses. Additionally if we are using a server in the backend, it is likely we will need to modify the HTTP(S) request such that the pages in the server work correctly.

```conf

global
        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

        # Default SSL material locations
        ca-base /etc/ssl/certs
        crt-base /etc/ssl/private

        # Default ciphers to use on SSL-enabled listening sockets.
        # For more information, see ciphers(1SSL). This list is from:
        #  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
        # An alternative list with additional directives can be obtained from
        #  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
        ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
        ssl-default-bind-options no-sslv3

defaults
        log     global
        mode    http
        option  httplog
        option  dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
        errorfile 400 /etc/haproxy/errors/400.http
        errorfile 403 /etc/haproxy/errors/403.http
        errorfile 408 /etc/haproxy/errors/408.http
        errorfile 500 /etc/haproxy/errors/500.http
        errorfile 502 /etc/haproxy/errors/502.http
        errorfile 503 /etc/haproxy/errors/503.http
        errorfile 504 /etc/haproxy/errors/504.http

frontend DMZ
        # Explicit HTTP (app) layer proxy
        mode http
        # Listen on port 443, associate ssl/tls connections with the cert specified
        bind *:8080 ssl crt /path/to/cert

        # Unless already HTTPS (ssl) redirect to HTTPS
        http-request redirect scheme https unless { ssl_fc }

        use_backend be_DMZ

frontend Linux
        # Explicit HTTP (app) layer proxy
        mode http
        # Listen on port 443, associate ssl/tls connections with the cert specified
        bind *:8081 ssl crt /path/to/cert

        # Unless already HTTPS (ssl) redirect to HTTPS
        http-request redirect scheme https unless { ssl_fc }

        use_backend be_Linux

frontend Windows
        # Explicit HTTP (app) layer proxy
        mode http
        # Listen on port 443, associate ssl/tls connections with the cert specified
        bind *:8082 ssl crt /path/to/cert

        # Unless already HTTPS (ssl) redirect to HTTPS
        http-request redirect scheme https unless { ssl_fc }

        use_backend be_Windows 

frontend Teleport
        # Explicit HTTP (app) layer proxy
        mode http
        # Listen on port 443, associate ssl/tls connections with the cert specified
        bind *:8083 ssl crt /path/to/cert

        # Unless already HTTPS (ssl) redirect to HTTPS
        http-request redirect scheme https unless { ssl_fc }

        # More can be added in a similar manner
        # acl <name> path_beg, url_dec -i /<path>
        use_backend be_teleport

backend be_teleport
        # Layer 7 application
        mode http
        # Forward to teleport without authenticating ssl cert - add to trusted and remove verify none
        server Teleport-S ccdcteleport.DMZ-UML:443 ssl verify none

backend be_DMZ
        mode http
        # Ip Hard coded, change if you change the DMZ Rotuer Interface IP
        server DMZ-R 10.0.1.1:443 ssl verify none

backend be_Linux
        mode http
        # Ip Hard coded, change if you change the DMZ Rotuer Interface IP
        server Linux-R <DNS>:443 ssl verify none

backend be_Windows
        mode http 
        # Ip Hard coded, change if you change the DMZ Rotuer Interface IP
        server Windows-R <DNS>:443 ssl verify none

```
### Reference  
* Path Based Routing https://www.haproxy.com/blog/path-based-routing-with-haproxy
  * I used this for Path stripping, so this can be simplified using the if { path /a } || { path_beg /a/ } over the ACLs
  * Some troubles with this. Changed it to be a simpler method as the Path on PFSense and other sites would change on each request
    * Also made PFSense a horrible site
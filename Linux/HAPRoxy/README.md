# HAProxy

WIP

## Setup VM

## Install HAProy


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
4. We will want to create a frontend for both HTTP and HTTPS. At the bottom of the file add 
        ```
        # Define a Frontend 
        frontend fe
                # Explicit HTTP (app) layer proxy
                mode http
                # Listen on port 80
                bind *:80
                # Listen on port 443, associate ssl/tls connections with the cert specified
                bind *:443 ssl crt /path/to/cert
        ```
   * Replace **/path/to/cert** with the path the to the cert + pem file created in step 2!
5. No that there is a frotend, it will accept connections on those ports, but we need to define **acl** variables, and backend to control access to our systems. These will be added within the frontend.
6. First we will want to redirect **all** HTTP traffic to be SSL/TLS traffic we can add the following line to acheve this
        ```
        # Unless already HTTPS (ssl) redirect to HTTPS
        http-request redirect scheme https unless { ssl_fc }
        ```
7. Now we can parse the URL, it is easiest to parse based on the path so for **each** of the differnt hosts we would like to forward to, we will **create a unique** ACL variable. Below are examples for each of the routers.
        ```
        # Teleport
        acl teleport path_beg, url_dec -i /Teleport
        # DMZ Router
        acl DMZ path_beg, url_dec -i /DMZ
        # Linux Router
        acl Linux path_beg, url_dec -i /Linux
        # Windows Router
        acl Windows path_beg, url_dec -i /Windows

        # More can be added in a similar manner
        # acl <name> path_beg, url_dec -i /<path>
        ```
8. Now we can use the ACL variables to control which *backend* will be used when forwarding data
        ```
        # Use specific backends
        use_backend be_teleport if teleport
        use_backend be_DMZ if DMZ
        use_backend be_Linux if Linux
        use_backend be_Windows if Windows
        # More can be created in the manner
        # use_backend <backend_name> if ACL_VAR
        ```
9.  Now that we know every backend we will need, we can create a backend **for each** of the servers we are forwarding to
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

frontend fe
        # Explicit HTTP (app) layer proxy
        mode http
        # Listen on port 80
        bind *:80
        # Listen on port 443, associate ssl/tls connections with the cert specified
        bind *:443 ssl crt /path/to/cert

        # Unless already HTTPS (ssl) redirect to HTTPS
        http-request redirect scheme https unless { ssl_fc }


        # Set Variable based on path specified

        # Teleport
        acl teleport path_beg, url_dec -i /Teleport
        # DMZ Router
        acl DMZ path_beg, url_dec -i /DMZ
        # Linux Router
        acl Linux path_beg, url_dec -i /Linux
        # Windows Router
        acl Windows path_beg, url_dec -i /Windows

        # More can be added in a similar manner
        # acl <name> path_beg, url_dec -i /<path>

        # Use specific backends
        use_backend be_teleport if teleport
        use_backend be_DMZ if DMZ
        use_backend be_Linux if Linux
        use_backend be_Windows if Windows
        # More can be created in the manner
        # use_backend <backend_name> if ACL_VAR

backend be_teleport
        # Layer 7 application
        mode http
        # Strip URL Path
        http-request replace-path /Teleport(/)?(.*) /\2
        # Forward to teleport without authenticating ssl cert - add to trusted and remove verify none
        server Teleport-S ccdcteleport.DMZ-UML:443 ssl verify none

backend be_DMZ
        mode http
        # Strip URL Path
        http-request replace-path /DMZ(/)?(.*) /\2
        # Ip Hard coded, change if you change the DMZ Rotuer Interface IP
        server DMZ-R 10.0.1.1:443 ssl verify none

backend be_Linux
        mode http
        # Strip URL Path
        http-request replace-path /Linux(/)?(.*) /\2
        # Ip Hard coded, change if you change the DMZ Rotuer Interface IP
        server Linux-R <DNS>:443 ssl verify none

backend be_Windows
        mode http 
        # Strip URL Path
        http-request replace-path /Windows(/)?(.*) /\2
        # Ip Hard coded, change if you change the DMZ Rotuer Interface IP
        server Windows-R <DNS>:443 ssl verify none

```
### Reference  
* Path Based Routing https://www.haproxy.com/blog/path-based-routing-with-haproxy
  * I used this for Path stripping, so this can be simplified using the if { path /a } || { path_beg /a/ } over the ACLs
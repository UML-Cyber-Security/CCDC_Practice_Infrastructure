# Nginx
Due to the desire for PATH based forwarding we are exploring the use of the NGINX proxy. This contains the following **Manual** steps to install and configure NGINX for a infrastructure. As the requirements change it is inevitable that the configuration, that is the proxy pass directives will change! 


## Install
1. Update the package list
    ```sh
    apt update
    ```
2. Install NGINX
    ```sh
    apt install nginx -y
    ```
## Configure 
1. Create/Open a new configuration in the ```conf.d``` directory. It **MUST** end in ```.conf``` as the main NGINX config has the following line ```include /etc/nginx/conf.d/*.conf;``` 
    ```sh
    vim /etc/nginx/conf.d/www.someURL.conf
    ```
2. Create a Server to redirect HTTP requests to HTTPS 
    ```conf
    # Server for redirecting HTTP requests to HTTPS
    server {

        listen 80 default_server;
        server_name _;
        return 301 https://$host$request_uri;

    }
    ```
3. Create a Server to handle HTTPS requests 
    ```conf
    # Server for handling HTTPS requests, and path based routing
    server{
            # Listen on port 445
            listen 443;
            # Increase Timeouts for activity
            proxy_read_timeout 500s;
            proxy_connect_timeout 60s;
            proxy_send_timeout 500s;

            # Include SSL Configurations
            include snippets/ssl-params.conf

            # Turn SSL on an Configure
            ssl on;
            ssl_certificate /etc/ssl/certs/nginx.crt;
            ssl_certificate_key /etc/ssl/private/nginx.key;
    }
    ```
    * Include the NGINX Certtificate or Create one 
      * Create a self signed with the following command ```sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx.key -out /etc/ssl/certs/nginx.crt```
4. Create a Diffie Hellman Group with OpenSSL
    ```
    openssl dhparam -out /etc/nginx/dhparam.pem 4096
    ```
    * This is used when negotiating the Perfect Forward Secrecy with clients.
5. Open ```/etc/nginx/snippets/ssl-params.conf``` and add a CipherList adapted from [CipherList](https://cipherlist.eu/)
    ```
    ssl_protocols TLSv1.3;# Requires nginx >= 1.13.0 else use TLSv1.2
    ssl_prefer_server_ciphers on;
    ssl_dhparam /etc/nginx/dhparam.pem; # openssl dhparam -out /etc/nginx/dhparam.pem 4096
    ssl_ciphers EECDH+AESGCM:EDH+AESGCM;
    ssl_ecdh_curve secp384r1; # Requires nginx >= 1.1.0
    ssl_session_timeout  10m;
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets off; # Requires nginx >= 1.5.9
    ssl_stapling on; # Requires nginx >= 1.3.7
    ssl_stapling_verify on; # Requires nginx => 1.3.7
    resolver 8.8.8.8 8.8.4.4 valid=300s; # Change to Internal?
    resolver_timeout 5s;
    # depending on our state we can comment HSTS out
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload";
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    ```
6. Add Proxy Pass Directives to the NGINX configuration
    ```
    location /teleport {
        subfilter "192.168.0.83/" "192.168.0.83/teleport";
        sub_filter_once off;
        proxy_pass https://10.0.1.15;
    }
        
    ```
7. Remove the Sites Available **DEFAULT** Site
    ```
    mv /etc/nginx/sites-enabled/default .
    ```


## Refs
* Timeout
  * https://ubiq.co/tech-blog/increase-request-timeout-nginx/
    * http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_read_timeout
* SSL
  * https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-20-04-1
  * https://phoenixnap.com/kb/redirect-http-to-https-nginx
* Setup/Reverse
  * https://www.nginx.com/blog/setting-up-nginx/
  * https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/
* Rewrite Body
  * http://nginx.org/en/docs/http/ngx_http_sub_module.html
  * https://stackoverflow.com/questions/32542282/how-do-i-rewrite-urls-in-a-proxy-response-in-nginx 
  * https://docs.appdynamics.com/appd/23.x/latest/en/end-user-monitoring/browser-monitoring/browser-real-user-monitoring/inject-the-javascript-agent/automatic-injection-of-the-javascript-agent/injection-using-nginx#:~:text=The%20ngx_http_sub_module%20module%20is%20a,Agent%20into%20a%20served%20page. 
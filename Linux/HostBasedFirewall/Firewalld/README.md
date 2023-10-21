# Firewalld
https://www.redhat.com/sysadmin/firewalld-rules-and-scenarios


## Teleport 
1. Add management port 
    ```
    sudo firewall-cmd --add-port 54750/tcp --zone=public --permanent
    ```
2. Add HTTPS 
    ```
    sudo firewall-cmd --add-port 443/tcp --zone=public --permanent
    ```
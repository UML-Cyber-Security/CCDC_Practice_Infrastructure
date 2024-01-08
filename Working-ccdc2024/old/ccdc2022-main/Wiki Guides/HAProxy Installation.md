# Getting started
Install HAProxy on the machine where the proxy will be hosted:
```sudo apt install haproxy```

# Configuration
Next, edit the config file:
```sudo vim /etc/haproxy/haproxy.cfg```

Here is an example config file (for SSH to 3 servers):
```
defaults
  timeout client 10s
  timeout connect 5s
  timeout server 10s 

global
  chroot /var/lib/haproxy
  user haproxy
  group haproxy


frontend ssh1_fe
  mode tcp
  bind :2200
  use_backend ssh1_be

frontend ssh2_fe
  mode tcp
  bind :2201
  use_backend ssh2_be

frontend ssh3_fe
  mode tcp
  bind :2202
  use_backend ssh3_be


backend ssh1_be
  mode tcp
  server server1 127.0.0.1:22 check

backend ssh2_be
  mode tcp
  server server2 10.10.10.11:22 check

backend ssh3_be
  mode tcp
  server server3 10.10.10.12:22 check
```

# Firewall config
Create virtual IP for each service, and then direct all traffic from that IP to the designated front end port

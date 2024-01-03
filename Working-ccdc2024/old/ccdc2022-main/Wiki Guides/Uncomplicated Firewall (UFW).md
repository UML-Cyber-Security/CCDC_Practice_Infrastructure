Install: ```sudo apt install ufw```

# Example (from Sashank)
```
$ sudo ufw status
Status: inactive
$ sudo ufw default deny incoming
$ sudo ufw default deny outgoing
$ sudo ufw allow in from 10.0.0.0/24 to any port 22 proto tcp
$ sudo ufw allow in 443/tcp
$ sudo ufw allow out 53/udp
$ sudo ufw allow out 80/tcp
$ sudo ufw allow out 443/tcp
$ sudo ufw enable
$ sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), deny (outgoing), disabled (routed)
New profiles: skip
To Action From
-- ------ ----
22/tcp ALLOW IN 10.0.0.0/24
443/tcp ALLOW IN Anywhere
53/udp ALLOW OUT Anywhere
80/tcp ALLOW OUT Anywhere
443/tcp ALLOW OUT Anywhere
```

https://sollove.com/2013/03/03/my-first-5-minutes-on-a-server-or-essential-security-for-linux-servers/

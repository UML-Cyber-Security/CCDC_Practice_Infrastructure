# HAProxy

WIP

## Setup VM

## Install HAProy


## Setup HAProxy

```conf
frontend fe
        # Explicit HTTP (app) layer proxy
        mode http
        # Listen on port 80
        bind *:80
        # Listen on port 443, associate ssl/tls connections with the cert specified
        bind *:443 ssl crt /path/to/cert

        # Unless already HTTPS (ssl) redirect to HRRPS
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
        use_backend be_teleport if {teleport}
        use_backend be_DMZ if {DMZ}
        use_backend be_Linux if {Linux}
        use_backend be_Windows if {Windows}

backend be_teleport
        # Layer 7 application
        mode http
        # Forward to teleport without authenticating ssl cert - add to trusted and remove verify none
        server ccdcteleport.DMZ-UML:443 ssl verify none

backend be_DMZ
        mode http
        # Ip Hard coded, change if you change the DMZ Rotuer Interface IP
        server 10.0.1.1

backend be_Linux
        mode http
        # Ip Hard coded, change if you change the DMZ Rotuer Interface IP
        server <DNS>

backend be_Windows
        mode http
        # Ip Hard coded, change if you change the DMZ Rotuer Interface IP
        server <DNS>

```
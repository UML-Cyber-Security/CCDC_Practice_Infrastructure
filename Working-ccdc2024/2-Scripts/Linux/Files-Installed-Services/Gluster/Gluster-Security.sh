## Enable security on glusterfs

#********************************
# Written by Someone
#********************************

# 1. Create volume
gluster volume create securevol01 replica 3 transport tcp
    rhgs-sr01:/brick_01/data \
    rhgs-sr02:/brick_01/data \
    rhgs-sr03:/brick_01/data

# 2. Enable SSL on client/server
gluster volume set securevol01 client.ssl on
gluster volume set securevol01 server.ssl on

# 3. Enable connection/auth
gluster volume set securevol01 auth.ssl-allow rhgs-sr01,rhgs-sr02,rhgs-sr03,client-01

# 4. Disable insecure SSL
gluster volume set securevol01 ssl.cipher-list 'HIGH:!SSLv2'

# 5. Start volume
gluster volume start securevol01

# 5. Verify TLS Connection
grep SSL /var/log/glusterfs/glusterd.log
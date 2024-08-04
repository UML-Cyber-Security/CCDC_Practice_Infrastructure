# Disable and Stop rsync it is considered insecure
systemctl --now disable rsync 
# Disable and Stop nis (If it is there) --> Not needed with purge?
systemctl --now disable nis 

cockpit 


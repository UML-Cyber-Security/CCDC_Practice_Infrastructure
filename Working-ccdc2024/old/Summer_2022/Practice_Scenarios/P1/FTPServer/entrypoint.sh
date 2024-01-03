# Restart the ssh service
service ssh restart

# Restart the vsftpd service
service vsftpd restart

# Remove SELinux if installed. (I don't believe it's there on this image, but still want to have anyways.)
setenforce 0



# Line that will keep the container alive post these steps.
# Want to carry out the scenario
tail -f /dev/null

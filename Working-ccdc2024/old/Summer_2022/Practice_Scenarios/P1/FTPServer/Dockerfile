# Base image that this image will be built upon.
FROM ubuntu:22.04

# Install the packages that are needed for the ftp-server to function.
RUN apt -y update
RUN apt install -y ssh
RUN apt install -y vsftpd
RUN apt install -y tcpdump
RUN apt install -y vim
RUN apt install -y net-tools

# Update the vsftpd.conf and sshd_config files 
# Vsftpd.conf - Allow password-less anonymous connections that are
# chroot-ed to '/' and that can write to the file system. 
# Sshd_config - Allow root login.
RUN sed -i 's/anonymous_enable=NO/anonymous_enable=YES\nno_anon_password=YES\nanon_root=\//g' /etc/vsftpd.conf
RUN sed -i 's/\#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -i 's/#write_enable=YES/write_enable=YES/g' /etc/vsftpd.conf

# Add the users of the machine, set weak passwords for root and onestaradmin
# Add the innocentdev and contractor users with good passwords.
RUN adduser onestaradmin
RUN adduser innocentdev
RUN adduser contractor
RUN echo "innocentdev:1qazxsW@1" | chpasswd
RUN echo "onestaradmin:password" | chpasswd
RUN echo "root:toor" | chpasswd
RUN echo "contractor:1qazxsW@1" | chpasswd

# Create the public file location that houses the application
# Change the permissions so everyone can write to it.
RUN mkdir /home/public
RUN chmod 777 /home/public/
RUN chown innocentdev /home/public

# Generate password hashes for innocentdev, onestaradmin, and root
# Docker has unix-like files I believe. And so, a temporary file
# that emulates the shadow file is going to be made.
RUN openssl passwd -1 1qazxsW@1 > /etc/shadow-USE-THIS
RUN openssl passwd -1 password >> /etc/shadow-USE-THIS
RUN openssl passwd -1 toor >> /etc/shadow-USE-THIS

# Insert the corresponding users names to the file
# This will have user names pop up when cracked by John the Ripper 
RUN sed -i '1 s/./innocentdev:&/' /etc/shadow-USE-THIS
RUN sed -i '2 s/./onestaradmin:&/' /etc/shadow-USE-THIS
RUN sed -i '3 s/./root:&/' /etc/shadow-USE-THIS

# Copy the LOCAL entrypoint script into the IMAGE'S '/' directory
COPY entrypoint.sh /

# When a container that is created from this image and it starts, then run this script upon startup.
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

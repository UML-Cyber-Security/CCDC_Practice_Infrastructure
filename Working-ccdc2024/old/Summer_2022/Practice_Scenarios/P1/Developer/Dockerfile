# Base image we're building this new image from.
FROM ubuntu:22.04

# Install all the packages needed to run the developer machine.
RUN apt -y update
RUN apt install -y ssh
RUN apt install -y vim
RUN apt install -y cron
RUN apt install -y ftp
RUN apt install -y netbase

# Add the innocent dev user.
RUN adduser innocentdev

# Create the INCH placeholder. This will be the target file
# that gets transferred later.
RUN echo "Placeholder for the app" > /home/innocentdev/ICNH.app
RUN chown innocentdev /home/innocentdev/ICNH.app
RUN chmod 777 /home/innocentdev/ICNH.app

# Transfer the fileTransfer script for the cronjob.
COPY fileTransfer.sh /home/innocentdev/
RUN chmod 777 /home/innocentdev/fileTransfer.sh

# Update the passwords of the users on the machines 
RUN echo "innocentdev:1qazxsW@1" | chpasswd
RUN echo "root:toor" | chpasswd

# Set up the cronjob to send to the FTP server
ADD crontab /etc/cron.d/crontab
RUN chmod 0600 /etc/cron.d/crontab
RUN touch /var/log/cron.log

# Copy our LOCAL entrypoint script into the IMAGE'S '/' directory
COPY entrypoint.sh /

# When a container with this image starts, then run the entrypoint.sh script.
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

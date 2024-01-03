# Base image that this image is based on.
FROM ubuntu:22.04

# Install the packages onto the machine.
# Normal functions and then the expected security tool.
RUN apt -y update
RUN apt install -y ssh
RUN apt install -y vim
RUN apt install -y ftp
RUN apt install -y netbase
RUN apt install -y john

# Change the password of the root account
RUN echo "root:toor" | chpasswd

# Copy the LOCAL machine's entrypoint.sh script into the
# IMAGE'S '/' directory
COPY entrypoint.sh /

# When a new container with this image is created and then started, run this script.
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

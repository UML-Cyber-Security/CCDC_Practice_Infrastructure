# Building off of an already existing image, simplifies this as we do not have to redo 
# The steps that were done to make the original container
FROM sh0rtcyb3r/ccdc23_af_django:latest

# We can chain shell commands together with the "&&" symbol. So this creates a new user with a home directory too.
# We assign a password to the user so that we can log in through SSH. I created a group and added the user to 
# The group too, though this is not necessary.
RUN useradd -m user && echo "user:1qazxsW@1"|chpasswd && groupadd sshUser && usermod -aG sshUser user 

# This directive runs commands to update the package manager's source lists (allowing most up to date binaries)
# We also run the command to install the open-ssh server we use the -y flag to confirm it as during the 
# Build we can not type yes (y) 
RUN apt-get update && apt-get install openssh-server -y

# This copies the entrypoint.sh file from the directory we are currently in to the root directory of the container
COPY entrypoint.sh /

# Set the command to be run on startup as the entrypoint.sh command
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
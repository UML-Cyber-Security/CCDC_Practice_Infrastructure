# Install-Remove
This script will install and remove various services from the target machines. Currently handles Debian, RedHat and Alpine systems.

We can add additional packages that are commonly used, and additional packages to remove. Service specific installs should be handled in their own playbook.
## Install
* python3
* sudo
* libpam-google-authenticator
## Remove
* ftp
* autofs
* telnet
* nis
* talk
* rsh-client
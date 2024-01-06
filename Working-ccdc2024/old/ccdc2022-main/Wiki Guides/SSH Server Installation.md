# SSH Server Installation

**_Goal:_** Installing a SSH server (OpenSSH) on a Linux Machine.

**_Topic:_** Linux Administration

**_Resources Used:_** 
- https://www.makeuseof.com/tag/beginners-guide-setting-ssh-linux-testing-setup/

# Steps

1. Update the repositories on the Linux system.

```
sudo apt update && sudo apt upgrade
```

2. Install the OpenSSH server.

```
sudo apt install openssh-server
```

3. Check that the SSH server is up and running.

```
sudo systemctl status ssh
```

The green circle indicates that the server has successfully been installed and the SSH service is now running.

4. If the SSH server is not already up, the following commands will enable and start the server.

```
sudo systemctl enable ssh
sudo systemctl start ssh
```
[SSH security script](https://gitlab.cyber.uml.edu/ccdc/ccdc2022/-/blob/main/ccdc2021/Documentation/OperatingSystems/Arch/services/ssh/secureSSH.sh)

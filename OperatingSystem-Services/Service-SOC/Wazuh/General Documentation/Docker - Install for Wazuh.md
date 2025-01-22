# How to Install Docker For Wazuh Purposes #

Documentation showing how to correctly install Docker to prepare for a Wazuh Docker deployment. A default Docker installation will most likely not work. In case anything gets outdated/more information can be found here: [Official Wazuh Installation Docs](https://documentation.wazuh.com/current/deployment-options/Docker/Docker-installation.html)  

> [!IMPORTANT]
>DISCLAMER:  Do not follow official Docker docs, follow provided steps!


## Increase max_map_count on your Docker host:
This increases the maximum allows of "memory mapping" a process is allowed to have.  <br> <br>
```sudo sysctl -w vm.max_map_count=262144```

> [!NOTE]
> Or you can use the following steps to make this operation permanent.
> 
> 1. Open ```/etc/sysctl.conf``` file, 
> 2. Add ```vm.max_map_count=262144``` to the end of the file
> 3. Run ```sysctl vm.max_map_count``` to make sure the number is 262144.

## Check Kernel Version

Run: ```sudo uname -r```

Make sure kernel version is greater than 3.10.  
Example output: `6.5.6-300.fc39.x86_64` (Kernal version is 6.5.6)


## Next run the Docker installation script:

```bash
sudo curl -sSL https://get.Docker.com/ | sh
```

Afterwards, start Docker:

```bash
sudo systemctl start Docker
```

## Install the Docker Compose Binary
Check if this is latest version before copying command.

```bash
curl -L "https://github.com/Docker/compose/releases/download/v2.12.2/Docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/Docker-compose
```

Grant Execute Permissions:

```bash
chmod +x /usr/local/bin/Docker-compose
```

Make sure it installed fine

```bash
Docker-compose --version
```

This should output a version number of Docker compose if installed correctly

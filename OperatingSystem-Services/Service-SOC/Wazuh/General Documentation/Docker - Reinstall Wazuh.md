## How to Reset and Reinstall Wazuh w/ Docker ##

Guide showing steps to fresh reinstall Wazuh with Docker already installed on a Debian linux OS.
<br>
In case anything gets outdated/more information can be found here: [Official Wazuh Installation Docs](https://documentation.wazuh.com/current/deployment-options/Docker/Docker-installation.html)  

### List out all Docker containers
``` docker ps ```

### Stop all the ones with Wazuh
There should be 3: Dashboard, manager, indexer  
``` docker stop <container> ```  
Can also try to use this command instead to bring down all containers:      
```docker compose down```

### Run Docker prune to remove all stopped containers and data
> [!IMPORTANT]
> This command will remove ALL stopped containers, make sure all containers that are stopped you are comfortable with deleting!

```bash
docker system prune
```

### Remove the Wazuh Github directory
```bash
rm -rf wazuh-docker
```

### Re-Pull the Github
Check if this is latest version?  
```bash
git clone https://github.com/wazuh/wazuh-docker.git -b v4.6.0
```

### Get Certs Again
```bash
docker compose -f generate-indexer-certs.yml run --rm generator
```

### Deploy the Containers
``` Docker compose up -d ```<br><br>
![Image of Docker compose output](../Images/image2.png)  
![Image of Docker compose output](../Images/image3.png) 
(Sample Docker compose output shown above)

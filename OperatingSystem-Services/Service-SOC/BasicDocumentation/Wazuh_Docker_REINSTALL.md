## How to Reset and Reinstall Wazuh w/ Docker ##
Easy way to fresh reinstall wazuh with docker already installed
### List out all docker containers
``` docker ps ```

### Stop all the ones with wazuh
``` docker stop <container> ```

### Run docker prune to remove all stopped containers and data
``` docker system prune ```

### Remove the wazuh github directory
``` rm -rf wazuh-docker ```

### Re-Pull the github
Check if this is latest version?
```git clone https://github.com/wazuh/wazuh-docker.git -b v4.6.0 ```

### Get Certs Again
```docker compose -f generate-indexer-certs.yml run --rm generator ```

### Deploy the Containers
``` docker compose up -d ```

Complain to Viktor about this if it doesn't work : /

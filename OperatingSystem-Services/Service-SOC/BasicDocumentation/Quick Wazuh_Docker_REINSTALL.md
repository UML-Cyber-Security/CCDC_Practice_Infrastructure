## How to Reset and Reinstall Wazuh w/ Docker ##

List out all docker containers\
``` docker ps ```

Stop all the ones with wazuh\
``` docker stop <container> ```

Run docker prune to remove all stopped containers and data\
``` docker system prune ```

Remove the wazuh github directory\
``` rm -rf wazuh-docker ```

Re-Pull the github\
```git clone https://github.com/wazuh/wazuh-docker.git -b v4.6.0 ```

Get Certs Again\
```docker compose -f generate-indexer-certs.yml run --rm generator ```

Deploy the Containers\
``` docker compose up -d ```

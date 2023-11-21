# How to Deploy Wazuh on Docker, Single-Node



## Get wazuh-docker github repo

`git clone https://github.com/wazuh/wazuh-docker.git -b v4.6.0`

## Get Certs

`docker-compose -f generate-indexer-certs.yml run --rm generator`

## Deploy docker containers

`docker compose up -d`

## Possible Errors

Make sure you have the certs before you try to deploy the docker containers. If you do not you will get an error. Make sure you follow the wazuh documentation for docker installation. If you follow docker docs you may install the wrong packages and wazuh will not work as intended
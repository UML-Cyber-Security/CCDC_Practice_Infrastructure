# How to Deploy Wazuh on Docker, Single-Node

This is a working guide for a Ubuntu OS.  
Extra informatino can be found here: [Official Wazuh Installation Docs](https://documentation.wazuh.com/current/deployment-options/docker/wazuh-container.html)

## Get wazuh-docker github repo
> [!IMPORTANT]
> Make sure this is the latest version!

`git clone https://github.com/wazuh/wazuh-docker.git -b v4.6.0`

## Get Certs
Navigate to the single node directory and run following command to generate proper certificates: 
`docker compose -f generate-indexer-certs.yml run --rm generator`

## Deploy docker containers
This will create 3 docker containers: Wazuh manager, Wazuh Dashboard, Wazuh Indexer
`docker compose up -d`

## Possible Errors

Make sure you have the certs before you try to deploy the docker containers. If you do not you will get an error. Make sure you follow the wazuh documentation for docker installation. If you follow docker docs you may install the wrong packages and wazuh will not work as intended

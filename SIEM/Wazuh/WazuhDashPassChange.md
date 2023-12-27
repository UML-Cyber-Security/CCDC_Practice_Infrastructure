# Wazuh Dashbaord Password Change 

Process to change the default wazuh dashbaord password

## 1. Procedure

Stop the docker containers +

```bash
cd ~
cd wazuh-docker
cd single-node
sudo docker-compose down
```

Run the docker indexer container

```bash
docker run --rm -ti wazuh/wazuh-indexer:4.6.0 bash /usr/share/wazuh-indexer/plugins/opensearch-security/tools/hash.sh
```

COPY THE HASH!!!

```bash
cd config
cd wazuh_indexer
nano internal_users.yml
```

Change the `admin` hash\
Then->\

```bash
cd ..
cd ..
nano docker-compose.yml
```

Then change the `INDEXER_PASSWORD` in .manager and .dashboard enviorment!!!\
Then start the deployment stack->

```bash
docker-compose up -d
```

Run `docker ps` and note name of the Wazuh Indexer container\
Then enter the container->

```bash
docker exec -it single-node-wazuh.indexer-1 bash
```

Set the following variables
```bash
export INSTALLATION_DIR=/usr/share/wazuh-indexer
CACERT=$INSTALLATION_DIR/certs/root-ca.pem
KEY=$INSTALLATION_DIR/certs/admin-key.pem
CERT=$INSTALLATION_DIR/certs/admin.pem
export JAVA_HOME=/usr/share/wazuh-indexer/jdk
```

Wait for indexer to set up\
Then run the `securityadmin.sh` script->

```bash
bash /usr/share/wazuh-indexer/plugins/opensearch-security/tools/securityadmin.sh -cd /usr/share/wazuh-indexer/opensearch-security/ -nhnv -cacert  $CACERT -cert $CERT -key $KEY -p 9200 -icl
```

Exit the Wazuh Indexer container ;)

## Contributors

Author: Viktor Akhonen
Position: SIEM Team member @ RTUML

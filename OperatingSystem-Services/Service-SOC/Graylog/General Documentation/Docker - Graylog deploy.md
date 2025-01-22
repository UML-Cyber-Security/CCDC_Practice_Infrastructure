# DOCKER Graylog Install #

Short guide to show the correct way to install and configure Graylog on a DOCKER container. This is done on a Ubuntu Linux OS. This installs Graylog with DATANODE. <br>


## 1. Install Docker + Docker-Compose ##

```sudo apt install docker ```  
```sudo apt install docker-compose```  

MAKE SURE TO INCREASE ```vm.max_map_count```!!!  
RUN:  
```bash
nano /etc/sysctl.conf

## THEN ADD THIS LINE BELOW TO BOTTOM OF FILE
vm.max_map_count=262144

## SAVE+EXIT THEN RUN THIS
sudo sysctl -p
```

## 2. Configure the Docker-Compose.yml ##

Graylog root password hash can be generated with the following command: 
```bash
echo -n "Enter Password: " && head -1 < /dev/stdin | tr -d '\n' | sha256sum | cut -d " " -f1
```

Make sure to also add a randomized password secret phrase!!  

THERE ARE TWO INSTANCES TO SET OF BOTH!!

```cd ~```  
```touch compose.yaml```  
Sample Compose file:  
```yaml
version: '3'
services:
  # MongoDB: https://hub.docker.com/_/mongo/
  mongodb:
    image: "mongo:6.0.18"
    ports:
      - "27017:27017"
    restart: "on-failure"
    networks:
      - graylog
    volumes:
      - "mongodb_data:/data/db"
      - "mongodb_config:/data/configdb"
  #Graylog Data Node: https://hub.docker.com/r/graylog/graylog-datanode
  datanode:
    image: "graylog/graylog-datanode:6.1"
    hostname: "datanode"
    environment:
      GRAYLOG_DATANODE_NODE_ID_FILE: "/var/lib/graylog-datanode/node-id"
      GRAYLOG_DATANODE_PASSWORD_SECRET: "somepasswordpepperbruh"
      GRAYLOG_DATANODE_ROOT_PASSWORD_SHA2: "8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918"
      GRAYLOG_DATANODE_MONGODB_URI: "mongodb://mongodb:27017/graylog"
    ulimits:
      memlock:
        hard: -1
        soft: -1
      nofile:
        soft: 65536
        hard: 65536
    ports:
      - "8999:8999/tcp"   # DataNode API
      - "9200:9200/tcp"
      - "9300:9300/tcp"
    networks:
      - graylog
    volumes:
      - "graylog-datanode:/var/lib/graylog-datanode"
    restart: "on-failure"
  # Graylog: https://hub.docker.com/r/graylog/graylog/
  graylog:
    hostname: "server"
    image: "graylog/graylog:6.1"
    # To install Graylog Open: "graylog/graylog:6.1"
    depends_on:
      mongodb:
        condition: "service_started"
      datanode:
        condition: "service_started"
    entrypoint: "/usr/bin/tini -- /docker-entrypoint.sh"
    environment:
      GRAYLOG_NODE_ID_FILE: "/usr/share/graylog/data/config/node-id"
      GRAYLOG_HTTP_BIND_ADDRESS: "0.0.0.0:9000"
      GRAYLOG_MONGODB_URI: "mongodb://mongodb:27017/graylog"
      # To make reporting (headless_shell) work inside a Docker container
      GRAYLOG_REPORT_DISABLE_SANDBOX: "true"
      # CHANGE ME (must be at least 16 characters)!
      GRAYLOG_PASSWORD_SECRET: "somepasswordpepperbruh"
      # Password: "admin"
      GRAYLOG_ROOT_PASSWORD_SHA2: "8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918"
      GRAYLOG_HTTP_EXTERNAL_URI: "http://127.0.0.1:9000/"
    ports:
      # Graylog web interface and REST API
      - "9000:9000/tcp"
      # Beats
      - "5044:5044/tcp"
      # Syslog TCP
      - "5140:5140/tcp"
      # Syslog UDP
      - "5140:5140/udp"
      # GELF TCP
      - "12201:12201/tcp"
      # GELF UDP
      - "12201:12201/udp"
      # Forwarder data
      - "13301:13301/tcp"
      # Forwarder config
      - "13302:13302/tcp"
    restart: "on-failure"
    networks:
      - graylog
    volumes:
      - "graylog_data:/usr/share/graylog/data"
networks:
  graylog:
    driver: "bridge"
volumes:
  mongodb_data:
  mongodb_config:
  graylog-datanode:
  graylog_data:
```

## 3. Configure the CA and Data_node on the Graylog Dashboard ##

Navigate to: ```http://<graylog_IP>:9000```  
Create + manage CA and start the dashboard. 

Make note of the ports open logging inputs:  
(Beats, syslog, GELF, etc;)
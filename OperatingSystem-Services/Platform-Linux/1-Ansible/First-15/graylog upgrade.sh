#!/bin/bash

# Variables
GRAYLOG_VERSION="4.5.6" # Update to the desired Graylog version
OPENSEARCH_VERSION="2.9.0" # Update to the desired OpenSearch version
MONGO_VERSION="6.0" # Update to the desired MongoDB version
MONGO_BACKUP_PATH="/backup/mongo_$(date +%Y%m%d_%H%M%S)"
CONFIG_BACKUP_PATH="/backup/graylog_config_$(date +%Y%m%d_%H%M%S)"
OPENSEARCH_SNAPSHOT_PATH="/backup/opensearch_snapshot_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="/var/log/graylog_opensearch_mongo_upgrade.log"

# Functions
log() {
    echo "$(date +%Y-%m-%d_%H:%M:%S) - $1" | tee -a $LOG_FILE
}

# Step 1: Stop Graylog Services
log "Stopping Graylog service..."
sudo systemctl stop graylog-server

# Step 2: Backup MongoDB
log "Backing up MongoDB..."
mkdir -p $MONGO_BACKUP_PATH
mongodump --db graylog --out $MONGO_BACKUP_PATH
if [[ $? -ne 0 ]]; then
    log "Error during MongoDB backup. Aborting!"
    exit 1
fi

# Step 3: Backup Graylog Configuration
log "Backing up Graylog configuration..."
mkdir -p $CONFIG_BACKUP_PATH
cp /etc/graylog/server/server.conf $CONFIG_BACKUP_PATH
if [[ $? -ne 0 ]]; then
    log "Error during configuration backup. Aborting!"
    exit 1
fi

# Step 4: Backup OpenSearch Data
log "Creating an OpenSearch snapshot..."
mkdir -p $OPENSEARCH_SNAPSHOT_PATH
curl -XPUT "http://localhost:9200/_snapshot/my_backup" -H 'Content-Type: application/json' -d '{
  "type": "fs",
  "settings": {
    "location": "'$OPENSEARCH_SNAPSHOT_PATH'",
    "compress": true
  }
}'

curl -XPUT "http://localhost:9200/_snapshot/my_backup/snapshot_$(date +%Y%m%d)" -H 'Content-Type: application/json'
if [[ $? -ne 0 ]]; then
    log "Error during OpenSearch snapshot creation. Aborting!"
    exit 1
fi

# Step 5: Stop OpenSearch and MongoDB
log "Stopping OpenSearch and MongoDB services..."
sudo systemctl stop opensearch
sudo systemctl stop mongod

# Step 6: Upgrade MongoDB
log "Upgrading MongoDB to version $MONGO_VERSION..."
# Update the MongoDB repository to point to the new version
wget -qO - https://www.mongodb.org/static/pgp/server-$MONGO_VERSION.asc | sudo apt-key add -
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/$MONGO_VERSION multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-$MONGO_VERSION.list

sudo apt update && sudo apt install -y mongodb-org
if [[ $? -ne 0 ]]; then
    log "Error during MongoDB upgrade. Aborting!"
    exit 1
fi

# Step 7: Upgrade OpenSearch
log "Upgrading OpenSearch to version $OPENSEARCH_VERSION..."
sudo apt update && sudo apt install -y opensearch=$OPENSEARCH_VERSION
if [[ $? -ne 0 ]]; then
    log "Error during OpenSearch upgrade. Aborting!"
    exit 1
fi

# Step 8: Upgrade Graylog
log "Upgrading Graylog to version $GRAYLOG_VERSION..."
sudo apt update && sudo apt install -y graylog-server=$GRAYLOG_VERSION
if [[ $? -ne 0 ]]; then
    log "Error during Graylog upgrade. Aborting!"
    exit 1
fi

# Step 9: Start Services
log "Starting MongoDB, OpenSearch, and Graylog services..."
sudo systemctl start mongod
sudo systemctl start opensearch
sudo systemctl start graylog-server

# Step 10: Verify Services
log "Verifying MongoDB service..."
sudo systemctl status mongod | tee -a $LOG_FILE

log "Verifying OpenSearch service..."
sudo systemctl status opensearch | tee -a $LOG_FILE

log "Verifying Graylog service..."
sudo systemctl status graylog-server | tee -a $LOG_FILE

log "Upgrade completed successfully!"
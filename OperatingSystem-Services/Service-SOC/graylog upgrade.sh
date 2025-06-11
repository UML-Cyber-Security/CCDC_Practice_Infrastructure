#!/bin/bash

# Set variables for version and backup paths
GRAYLOG_CONFIG="/etc/graylog/server/server.conf"
BACKUP_DIR="/backup"
CONFIG_BACKUP_PATH="$BACKUP_DIR/graylog_config_$(date +%Y%m%d_%H%M%S)"
MONGO_VERSION="7.0"

# Function to log messages
log() {
    echo "$(date +%Y-%m-%d_%H:%M:%S) - $1"
}

# Backup Graylog configuration
backup_graylog_config() {
    log "Backing up Graylog configuration..."
    mkdir -p "$CONFIG_BACKUP_PATH"
    cp "$GRAYLOG_CONFIG" "$CONFIG_BACKUP_PATH"
    log "Graylog configuration backed up to $CONFIG_BACKUP_PATH."
}

# Extract HTTP settings, root password SHA2, and password secret
extract_graylog_config() {
    log "Extracting important Graylog settings from server.conf..."

    HTTP_SETTINGS=$(awk '/###############/,/#http_external_uri/' "$GRAYLOG_CONFIG")
    ROOT_PASSWORD_SHA2=$(grep "^root_password_sha2" "$GRAYLOG_CONFIG")
    PASSWORD_SECRET=$(grep "^password_secret" "$GRAYLOG_CONFIG")

    # Save extracted settings to a file
    echo "$HTTP_SETTINGS" > "$CONFIG_BACKUP_PATH/extracted_settings.conf"
    echo "$ROOT_PASSWORD_SHA2" >> "$CONFIG_BACKUP_PATH/extracted_settings.conf"
    echo "$PASSWORD_SECRET" >> "$CONFIG_BACKUP_PATH/extracted_settings.conf"

    log "HTTP settings, root_password_sha2, and password_secret extracted and saved."
}

# MongoDB Upgrade
upgrade_mongodb() {
    log "Upgrading MongoDB to version $MONGO_VERSION..."

    # Wait for any existing apt processes to finish
    while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
        log "Waiting for lock on /var/lib/dpkg/lock-frontend..."
        sleep 5
    done

    sudo apt update && sudo apt install -y mongodb-org
    if [[ $? -ne 0 ]]; then
        log "Error during MongoDB upgrade. Aborting!"
        exit 1
    fi
}

# Elasticsearch Upgrade
upgrade_elasticsearch() {
    log "Upgrading Elasticsearch OSS to version 7.10.2..."
    # Remove existing Elasticsearch package to avoid conflicts
    sudo apt-get remove -y elasticsearch-oss
    # Install the required Elasticsearch OSS version
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-7.10.2-amd64.deb
    sudo dpkg -i elasticsearch-oss-7.10.2-amd64.deb
    sudo apt-get update
    sudo apt-get install -y elasticsearch-oss
    log "Elasticsearch OSS upgrade completed successfully!"
}

# Graylog Upgrade
upgrade_graylog() {
    log "Upgrading Graylog to version 6.1.0..."

    # Download and install the latest Graylog repository
    wget https://packages.graylog2.org/repo/packages/graylog-6.1-repository_latest.deb
    sudo dpkg -i graylog-6.1-repository_latest.deb
    sudo apt-get update
    sudo apt-get install -y graylog-server
    log "Graylog upgrade completed successfully!"
}

# Stop services before backup and upgrade
stop_services() {
    log "Stopping Graylog service..."
    sudo systemctl stop graylog-server
    log "Stopping Elasticsearch service..."
    sudo systemctl stop elasticsearch
    log "Stopping MongoDB service..."
    sudo systemctl stop mongod
}

# Main upgrade process
log "Starting system upgrade process..."

stop_services

backup_graylog_config
extract_graylog_config

upgrade_mongodb
upgrade_elasticsearch
upgrade_graylog

log "Upgrade completed successfully. Restarting services..."

# Restart services
sudo systemctl start elasticsearch
sudo systemctl start mongod
sudo systemctl start graylog-server

log "All services restarted successfully."
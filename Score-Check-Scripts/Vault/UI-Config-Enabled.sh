#!/bin/bash

# Define the URL of the Vault UI
VAULT_UI_URL="127.0.0.1:8201/ui/"

# Function to check if Vault UI is up
check_vault_ui() {
    echo "Running UI_Vault.sh..."
    local response_code
    response_code=$(curl -o /dev/null -s -w "%{http_code}" "$VAULT_UI_URL")

    if [[ $response_code -eq 200 ]]; then
        echo "Vault UI is up and running."
    else
        echo "Vault UI is not accessible. Response code: $response_code"
    fi
}

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "curl is required but not installed. Please install curl."
    exit 1
fi

# Check if Vault UI is up
check_vault_ui

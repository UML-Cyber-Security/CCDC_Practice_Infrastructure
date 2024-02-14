#!/bin/bash

# Define the Vault endpoint
VAULT_ENDPOINT="127.0.0.1:8201"


# Function to check if TLS is enabled for Vault
check_tls_enabled() {
    echo "Running TLS_Vault.sh..."
    local response_code
    response_code=$(curl -o /dev/null -s -w "%{http_code}" --insecure "$VAULT_ENDPOINT/v1/sys/health")

    if [[ $response_code -eq 200 ]]; then
        echo "TLS is enabled for HashiCorp Vault at $VAULT_ENDPOINT"
    else
        echo "TLS is not enabled for HashiCorp Vault at $VAULT_ENDPOINT"
    fi
}

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "curl is required but not installed. Please install curl."
    exit 1
fi

# Check if TLS is enabled
check_tls_enabled

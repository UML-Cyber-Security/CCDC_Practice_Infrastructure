#!/bin/bash
exit_code=0
# Variables
DOMAIN_NAME="www.example.com"

# Try to resolve the domain name
OUTPUT=$(nslookup ${DOMAIN_NAME} 2>&1)

# Check the result
if [[ ${OUTPUT} == *"can't find"* ]]; then
  echo "DNS resolution failed for ${DOMAIN_NAME}."
else
  exit_code=1
  echo "DNS resolution successful for ${DOMAIN_NAME}."
fi

exit $exit_code
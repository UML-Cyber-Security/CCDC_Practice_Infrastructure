#!/bin/bash

exit_code=0

VALID_ID="302"

USERNAME="admin"
PASSWORD="SecretPassword"

HOSTNAME="192.168.3.126"
PORT="443"

TOKEN=$(curl -s -o /dev/null -i -k -u admin:SecretPassword -w "%{http_code}\n" https://$HOSTNAME:$PORT)

if [ "$TOKEN" = "$VALID_ID" ]; then
    echo "The machine is NOT secure, dashboard password is left as default"
    

    exit_code=1
else
    echo "The machine IS secure"

    exit_code=0
fi

exit $exit_code

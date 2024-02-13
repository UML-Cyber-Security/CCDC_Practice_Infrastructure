#!/bin/bash

# Copyright Joan Montas
# All rights reserved.
# License under GNU General Public License v3.0

exit_code=0

INVALID_ID='{"title": "Unauthorized", "detail": "Invalid credentials"}'

USERNAME="wazuh-wui"
PASSWORD="MyS3cr37P450r.*-"

# NOTE() this is not accessible via API
# USERNAME="admin"
# PASSWORD="SecretPassword"


HOSTNAME="192.168.3.126"
PORT="55000"

URL="https://$HOSTNAME:$PORT"

TOKEN=$(curl -s -u "$USERNAME:$PASSWORD" -k -X POST "$URL/security/user/authenticate?raw=true")

if [ "$TOKEN" = "$INVALID_ID" ]; then
    echo "The machine IS secure"
    exit_code=0
else
    echo "The machine is NOT secure, api password is left as default"
    exit_code=1
fi

exit $exit_code

#!/bin/bash
exit_code=0
# Variables
HOSTNAME="your_hostname"
USERNAME="your_username"
PASSWORD="your_password"

# Command to execute
COMMAND="echo success"

# Try to execute the command
OUTPUT=$(winrs -r:${HOSTNAME} -u:${USERNAME} -p:${PASSWORD} ${COMMAND} 2>&1)

# Check the result
if [[ ${OUTPUT} == *"success"* ]]; then
  exit_code=1
  echo "Login through WinRM successful."
else
  echo "Login through WinRM failed. Error: ${OUTPUT}"
fi

exit $exit_code
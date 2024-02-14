#!/bin/bash
exit_code=0
# Replace with your actual username and host
USERNAME="your_username"
HOST="your_host"

# Use ssh to try to log into the remote host
ssh -o BatchMode=yes -o ConnectTimeout=5 $USERNAME@$HOST 'echo success' &> /dev/null

# Check the exit status of the ssh command
if [ $? -eq 0 ]
then
  exit_code=1
  echo "SSH login successful."
else
  echo "SSH login failed."
fi

exit $exit_code
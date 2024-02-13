#!/bin/bash
exit_code=0
# Replace with your actual username and host
USERNAME="your_username"
HOST="your_host"

# Use ssh to run the PowerShell command on the remote host
ssh $USERNAME@$HOST 'powershell.exe -Command "Get-MpPreference | Select-Object -Property DisableRealtimeMonitoring"'

# Check the output of the command
if [[ $? -eq 0 ]]
then
  exit_code=1
  echo "Command executed successfully."
else
  echo "Failed to execute command."
fi

exit $exit_code
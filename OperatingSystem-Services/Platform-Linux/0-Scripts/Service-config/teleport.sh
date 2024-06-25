#! /bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

change=0
if (( $(grep -c "second_factor: otp" /etc/teleport.yaml) == 1 || $(grep -c "second_factor:" /etc/teleport.yaml) == 0 )); then
       exit 1
fi

if (( $(grep -c ".*second_factor: otp" /etc/teleport.yaml) == 0 )); then
        echo "Did not find the Second Factor tag. Enabiling!"
        sed -i 's/second_factor: .*/second_factor: otp/g' /etc/teleport.yaml
        change=1
fi

if (( $(grep -c '.*session_recording: "off"' /etc/teleport.yaml) == 0 )); then
        echo "Did not find Session Recording. Enabling!"
        sed -i 's/session_recording: .*/session_recording: "on"/g' /etc/teleport.yaml
fi

if (( $change == 1 )); then
        echo "Restarting Teleport"
        systemctl restart teleport
fi
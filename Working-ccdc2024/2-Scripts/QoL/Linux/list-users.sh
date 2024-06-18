#!/bin/bash

echo "sudo users:"
grep -Po '^sudo.+:\K.*$' /etc/group
echo ""

echo "non-system users:"
awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd

# Sources:
#
# List sudo users:
# https://askubuntu.com/questions/611584/how-could-i-list-all-super-users
#
# List non-system users:
# https://stackoverflow.com/questions/33150365/how-can-we-get-list-of-non-system-users-on-linux

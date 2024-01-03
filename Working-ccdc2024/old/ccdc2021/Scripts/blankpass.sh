#!/bin/bash
# Author: Joel Savitz <joelsavitz@gmail.com>
# Purpose: List users with no password

die() {
	[ ! -z "$1" ] && echo "$1"
	exit 1
}

[ $UID -eq 0 ] || die "script must be run as root"

# Users with a blank password will have an /etc/shaddow entry in the following form: "<username>::<other stuff>"
# If there is anything between the two colons, the system requires a password to login as that user
# Valid username regex source: `man useradd`
USERLIST=$(grep '[a-z_][a-z0-9_-]*[$]\?::.*' /etc/shadow)

# Iterate through list of /etc/shadow entries and print each username
while [ ! -z "$USERLIST" ]; do
	read USERITER<<<"$USERLIST"
	echo "$USERITER" | awk -F':' '{ print ($1) }'
	USERLIST=`echo "$USERLIST" | awk -F'\n' 'NR > 1 { print }'`
done

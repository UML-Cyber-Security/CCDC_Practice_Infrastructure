#!/bin/bash 

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

cmd="yum install bind bind-utils -y"
echo "$cmd"

result=$(eval "$cmd" | tail -n 1)
echo "$result"

echo "$0 completed"

./mkZone.sh example.com 53.11.54.1 profile > example.com.zone

#! /bin/bash

#********************************
# Written by a sad Matthew Harper...
#********************************

#+++++++++++++++++++++++++++++++++++++
# One or Two arguments will be give
# The first is the table (defualt filter)
# The second will be the chain (optinal --defualt all)
#+++++++++++++++++++++++++++++++++++++


# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "$#"
TABLE="filter"
if (( "$#" >= 2 )); then 
    iptables -t $1 -nv -L "${2^^}" --line-number 
elif (( "$#" >= 1 )); then 
    iptables -t $1 -nvL --line-number 
else
    iptables -nvL --line-number 
fi




#!/bin/bash

#********************************
# Written by a sad Matthew Harper...
#********************************

if [ $EUID -ne 0 ]; then
    echo "Run me as a superuser"
    exit 1
fi

echo "[!!] New Port Number is $PORTNUM"
PORTNUM="8808"

# SSHD will bind to port 8808 rather than 22.
if [ "$(grep '.*Port' /etc/ssh/sshd_config | wc -l )" -eq 0 ]; then 
    echo "Port $PORTNUM" >> /etc/ssh/sshd_config
else
    # If we do find an entry, we can remove it
    # And replace it with port X
    sed -i "s/^\(.Port.*\)/Port $PORTNUM/g" /etc/ssh/sshd_config
fi

if [ "$(sshd -t | wc -l)" -ne 0 ]; then
    echo "Error in configuration file aborting"
    exit
fi

echo "[!!] Adding new SSH rules"
####### SSH
#### IPv4
# Accept SSH Connections
iptables -I INPUT -p tcp --dport $PORTNUM -j ACCEPT
# Log any SSH connection attempt
iptables -I INPUT -m conntrack -p tcp --dport $PORTNUM --ctstate NEW -j SSH-INITIAL-LOG


#### IPv6
# Accept SSH Connections
ip6tables -I INPUT -p tcp --dport $PORTNUM -j ACCEPT
# Log any SSH connection attempt
ip6tables -I INPUT -m conntrack -p tcp --dport $PORTNUM --ctstate NEW -j SSH-INITIAL-LOG

## IPv4
# Accept SSH Connections
iptables -I OUTPUT -p tcp --sport $PORTNUM -j ACCEPT 
# Log any SSH connection attempt, this is here because it would be odd to do something like this in an outgoing connection
iptables -I OUTPUT -m conntrack -p tcp --dport $PORTNUM --ctstate NEW -j SSH-INITIAL-LOG


##IPv6
# Accept SSH Connections
ip6tables -I OUTPUT -p tcp --sport $PORTNUM -j ACCEPT 
# Log any SSH connection attempt, this is here because it would be odd to do something like this in an outgoing connection
ip6tables -I OUTPUT -m conntrack -p tcp --dport $PORTNUM --ctstate NEW -j SSH-INITIAL-LOG

echo "[!!] Removing old SSH rules"

# Old method
#INPUTSSH="$(iptables -nv -L INPUT --line-number | grep "22" | awk -F " " '{print $1 }')"
# awk can do regex evlauation, $0 refers to the input line "~" is the regex operator, 
# and -v sets a varable re we can refer to
readarray -t INPUTSSH < <(iptables -nv -L FORWARD --line-number | awk -v re="22" -F " " '$0 ~ re {print $1 }')
# Iterate and remove
for index in ${!INPUTSSH[@]}; do 
    #printf "$((${INPUTSSH[index]}-$index))\n"
    iptables -D FORWARD $((${INPUTSSH[index]}-$index))
done 

# Replace with basic rules (SSHLOG -> accep)
readarray -t OUTPUTSSH < <(iptables -nv -L FORWARD --line-number | awk -v re="22" -F " " '$0 ~ re {print $1 }')
# Iterate and remove 
for index in ${!INPUTSSH[@]}; do 
    #printf "$((${INPUTSSH[index]}-$index))\n"
    iptables -D FORWARD $((${INPUTSSH[index]}-$index))
done 

# Restart to apply
echo "[!! Restarting to apply rules!"
systemctl restart sshd

#!/bin/bash

DOMAIN="$1"
WWWIP="$2"
 
if [ $# -le 1 ]
then
 echo "Syntax: $(basename $0) domainname www.domain.ip.address [profile]"
 echo "$(basename $0) example.com 1.2.3.4"
 exit 1
fi
 
PROFILE="ns.profile.nixcraft.net"
[ "$3" != "" ] && PROFILE="$3"
 
SERIAL=$(date +"%Y%m%d")01
 
source "$PROFILE"

NS1=${NAMESERVERS[0]}
 
echo "\$ORIGIN ${DOMAIN}."
echo "\$TTL ${TTL}"
echo "@	IN	SOA	${NS1}	${EMAILID}("
echo " ${SERIAL}	; Serial yyyymmddnn"
echo " ${REFRESH} ; Refresh After 3 hours"
echo " ${RETRY} ; Retry Retry after 1 hour"
echo " ${EXPIER} ; Expire after 1 week"
echo " ${MAXNEGTIVE}) ; Minimum negative caching of 1 hour"
echo ""
 
tLen=${#NAMESERVERS[@]}
 
echo "; Name servers for $DOMAIN" 
for (( i=0; i<${tLen}; i++ ));
do
 echo "@ ${ATTL}	IN	NS	${NAMESERVERS[$i]}"
done
 
tmLen=${#MAILSERVERS[@]}
 
echo "; MX Records" 
for (( i=0; i<${tmLen}; i++ ));
do
 echo "@ ${ATTL}	IN MX	$(( 10*${i} + 10 ))	${MAILSERVERS[$i]}"
done
 
 
echo '; A Records'
echo "@ ${ATTL}	IN A	${WWWIP}"
 
ttLen=${#NAMESERVERSIP[@]}
 
if [ $tLen -eq $ttLen ]
then
for (( i=0; i<${ttLen}; i++ ));
do
   thisNs="$(echo ${NAMESERVERS[$i]} | cut -d'.' -f1)"
   
 echo "${thisNs} ${ATTL}	IN	A	${NAMESERVERSIP[$i]}"
done
else
 :
fi
 
#echo "; CNAME Records"
#echo "www ${ATTL}	IN	CNAME	@"
 
LoadCustomARecords

# Bind

## Objective

Implement the Domain Name System protocol to perform secure name to IP conversion with 

## Security Analysis

- 
-
-
-

## Testing

Scripted: 

- Confirm that `yum` installed `bind` and `bind-utils` successfully
  - Steps:
    - Execute `sudo yum install bind bind-utils -y | tail -n 1` 
      - Expected: `Complete!` in stdout if install was successful
      - Expected: `Nothing to do` in stdout if script is being re-run and there were no changes
-
-

Active:

-
-
-
-

## Documentation

#### Zone Files [RFC 1035](https://www.ietf.org/rfc/rfc1035.txt)

Domain Name System (DNS) zone file is a text file that describes a DNS zone. A DNS zone is a subset, often a single domain, of the hierarchical domain name structure of the DNS. The zone file contains mappings between domain names and IP addresses and other resources, organized in the form of text representations of resource records (RR). A zone file may be either a DNS master file, authoritatively describing a zone, or it may be used to list the contents of a DNS cache [Wiki](https://en.wikipedia.org/wiki/Zone_file)

- Start of Authority (SOA) [source](https://help.dyn.com/how-to-format-a-zone-file/)
  - Required for each zone
  - Contains the following information in this format
    ```zone
    @     IN     SOA    {primary-name-server}     {hostmaster-email} (
                        {serial-number}
                        {time-to-refresh}
                        {time-to-retry}
                        {time-to-expire}
                        {minimum-TTL} )
     ```
    - Primary Name Server – The nameserver that contains the original zone file and not an AXFR transferred copy.
    - Hostmaster Email – Address of the party responsible for the zone. A period “.” is used in place of an “@” symbol. For email addresses that contain a period, this will be escaped with a slash “/”.
    - Serial Number – Version number of the zone. As you make changes to your zone file, the serial number will increase.
    - Time To Refresh – How long in seconds a nameserver should wait prior to checking for a Serial Number increase within the primary zone file. An increased Serial Number means a transfer is needed to sync your records. Only applies to zones using secondary DNS.
    - Time To Retry – How long in seconds a nameserver should wait prior to retrying to update a zone after a failed attempt. Only applies to zones using secondary DNS.
    - Time To Expire – How long in seconds a nameserver should wait prior to considering data from a secondary zone invalid and stop answering queries for that zone. Only applies to zones using secondary DNS.
    - Minimum TTL – How long in seconds that a nameserver or resolver should cache a negative response.
    - `$ORIGIN` - Indicates a DNS node tree and often starts a DSN zone file. Host labels below the origin will append the origin hostname to assemble a FQ hostname. Host labels within a record that use a FQ domain terminating with an ending period will not append the origin hostname
    - `@` - A special label that indicates the `$ORIGIN` should replace the `@`
    
- Zone file entries [source](https://help.dyn.com/how-to-format-a-zone-file/)
  - A collection of Resource Records (RR)
  - Contains the following information in this format
  
    | FORMAT:  | host label   | ttl   | record class | record type  | record data     |
    | -------- | ------------ | ----- | ------------ | ------------ | --------------- | 
    | EXAMPLE: | example.com. | 60    | IN           | A            | 104.255.228.125 |
    - Host Label – A host label helps to define the hostname of a record and whether the $ORIGIN hostname will be appended to the label. Fully qualified hostnames terminated by a period will not append the origin.
    - TTL – TTL is the amount of time in seconds that a DNS record will be cached by an outside DNS server or resolver.
    - Record Class – There are three classes of DNS records: IN (Internet), CH (Chaosnet), and HS (Hesiod). The IN class will be used for the Managed DNS service.
    - Record Type – Where the format of a record is defined. [types](https://tools.ietf.org/html/rfc1035#section-3.2.2)
      - CNAME [source](https://en.wikipedia.org/wiki/CNAME_record)
        - Can prove convenient when running multiple services (like an FTP server and a web server, each running on different ports) from a single IP address. One can, for example, point ftp.example.com and www.example.com to the DNS entry for example.com, which in turn has an A record which points to the IP address. Then, if the IP address ever changes, one only has to record the change in one place within the network: in the DNS A record for example.com. **CNAME records must always point to another domain name, never directly to an IP address.**
    - Record Data – The data within a DNS answer, such as an IP address, hostname, or other information. Different record types will contain different types of record data.
    
- Example 1 [source](https://www.itzgeek.com/how-tos/linux/centos-how-tos/configure-dns-bind-server-on-centos-7-rhel-7.html)
  ```zone
  @   IN  SOA     primary.itzgeek.local. root.itzgeek.local. (
                                                  1001    ;Serial
                                                  3H      ;Refresh
                                                  15M     ;Retry
                                                  1W      ;Expire
                                                  1D      ;Minimum TTL
                                                  )

  ;Name Server Information
  @      IN  NS      primary.itzgeek.local.

  ;IP address of Name Server
  primary IN  A       192.168.1.10

  ;Mail exchanger
  itzgeek.local. IN  MX 10   mail.itzgeek.local.

  ;A - Record HostName To IP Address
  www     IN  A       192.168.1.100
  mail    IN  A       192.168.1.150

  ;CNAME record
  ftp     IN CNAME        www.itgeek.local.
  ```
- Example 2 [source](https://help.dyn.com/how-to-format-a-zone-file/)

  ```zone
  $ORIGIN example.com.
  @                      3600 SOA   ns1.p30.dynect.net. (
                                zone-admin.dyndns.com.     ; address of responsible party
                                2016072701                 ; serial number
                                3600                       ; refresh period
                                600                        ; retry period
                                604800                     ; expire time
                                1800                     ) ; minimum ttl
                        86400 NS    ns1.p30.dynect.net.
                        86400 NS    ns2.p30.dynect.net.
                        86400 NS    ns3.p30.dynect.net.
                        86400 NS    ns4.p30.dynect.net.
                         3600 MX    10 mail.example.com.
                         3600 MX    20 vpn.example.com.
                         3600 MX    30 mail.example.com.
                           60 A     204.13.248.106
                         3600 TXT   "v=spf1 includespf.dynect.net ~all"
  mail                  14400 A     204.13.248.106
  vpn                      60 A     216.146.45.240
  webapp                   60 A     216.146.46.10
  webapp                   60 A     216.146.46.11
  www                   43200 CNAME example.com.
  ```

## Scripts / tools with Comments

### `mkZone.sh`

Generates zone files based on a `profile` file [source](https://bash.cyberciti.biz/domain/create-bind9-domain-zone-configuration-file/)

```bash
#!/bin/bash
# A Bash shell script to create BIND ZONE FILE.
# Tested under BIND 8.x / 9.x, RHEL, DEBIAN, Fedora Linux.
# -------------------------------------------------------------------------
# Copyright (c) 2002,2009 Vivek Gite <vivek@nixcraft.com>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
DOMAIN="$1"
WWWIP="$2"
 
if [ $# -le 1 ]
then
 echo "Syntax: $(basename $0) domainname www.domain.ip.address [profile]"
 echo "$(basename $0) example.com 1.2.3.4"
 exit 1
fi
 
# get profile
PROFILE="ns.profile.nixcraft.net"
[ "$3" != "" ] && PROFILE="$3"
 
SERIAL=$(date +"%Y%m%d")01                     # Serial yyyymmddnn
 
# load profile
source "$PROFILE"
 
# set default ns1
NS1=${NAMESERVERS[0]}
 
###### start SOA ######
echo "\$ORIGIN ${DOMAIN}."
echo "\$TTL ${TTL}"
echo "@	IN	SOA	${NS1}	${EMAILID}("
echo " ${SERIAL}	; Serial yyyymmddnn"
echo " ${REFRESH} ; Refresh After 3 hours"
echo " ${RETRY} ; Retry Retry after 1 hour"
echo " ${EXPIER} ; Expire after 1 week"
echo " ${MAXNEGTIVE}) ; Minimum negative caching of 1 hour"
echo ""
 
###### start Name servers #######
# Get length of an array
tLen=${#NAMESERVERS[@]}
 
# use for loop read all nameservers
echo "; Name servers for $DOMAIN" 
for (( i=0; i<${tLen}; i++ ));
do
 echo "@ ${ATTL}	IN	NS	${NAMESERVERS[$i]}"
done
 
###### start MX section #######
# get length of an array
tmLen=${#MAILSERVERS[@]}
 
# use for loop read all mailservers 
echo "; MX Records" 
for (( i=0; i<${tmLen}; i++ ));
do
 echo "@ ${ATTL}	IN MX	$(( 10*${i} + 10 ))	${MAILSERVERS[$i]}"
done
 
 
###### start A pointers #######
# A Records - Default IP for domain 
echo '; A Records'
echo "@ ${ATTL}	IN A	${WWWIP}"
 
# Default Nameserver IPs
# get length of an array
ttLen=${#NAMESERVERSIP[@]}
 
# make sure both nameserver and their IP match
if [ $tLen -eq $ttLen ]
then
# use for loop read all nameservers IPs
for (( i=0; i<${ttLen}; i++ ));
do
   thisNs="$(echo ${NAMESERVERS[$i]} | cut -d'.' -f1)"
   
 echo "${thisNs} ${ATTL}	IN	A	${NAMESERVERSIP[$i]}"
done
else
 # if we are here means, our nameserver IPs are defined else where else...  do nothing
 :
fi
 
echo "; CNAME Records"
echo "www ${ATTL}	IN	CNAME	@"
 
LoadCutomeARecords
```

### `profile`

The profile to define consistent values for use with `mkZone.sh`

```
# defaults profile for nameserver ns1.nixcraft.net
# 
TTL="3h"                      # Default TTL
ATTL="3600"		      # Default TTL for each DNS rec	
EMAILID="vivek.nixcraft.in." # hostmaster email
REFRESH="3h"                  # Refresh After 3 hours
RETRY="1h"                    # Retry Retry after 1 hour
EXPIER="1w"		      # Expire after 1 week
MAXNEGTIVE="1h"		      # Minimum negative caching of 1 hour	

# name server names FQDN 
NAMESERVERS=("ns1.nixcraft.net." "ns2.nixcraft.net." "ns3.nixcraft.net.")

# name server IPs, 
# leave it blank if you don't need them as follows
NAMESERVERSIP=()
#NAMESERVERSIP=("202.54.1.10" "203.54.1.10" "204.54.1.40")

# mail server names
# leave it blank if you don't need them
MAILSERVERS=("mail.nixcraft.net.")
#MAILSERVERS=("smtp1.nixcraft.net." "smtp2.nixcraft.net.")

################# add your own A recored here ##########################
# You can add additonal A recs using following function
function LoadCutomeARecords(){
echo >/dev/null # keep this line
# Uncomment or add A recoreds as per your requirments
# echo "ftp			$ATTL	IN	A	202.54.2.2"
# echo "webmail			$ATTL	IN	A	202.54.2.5"
# echo "ipv6host			$ATTL	IN	AAAA	2001:470:1f0e:c2::1"
}
```

### `installBind.sh`

Installs and configures bind

```bash
#!/bin/bash 

# Installing bind and bind utils with y flag, which just means
#   assume yes for all questions

cmd="sudo yum install bind bind-utils -y"
echo "$cmd"

# Eval executes cmd, we pipe the result into
#   tail to get our exepcted completition value

result=$(eval "$cmd" | tail -n 1)
echo "$result"


# The script ended successfully

echo "$0 completed"
```

## ToDo

- [ ] Get a successful DNS server 
- [ ] Write tests for the DNS server
- [ ] Configure DNSSEC

## References

- [DNS](https://www.cloudflare.com/learning/dns/what-is-dns/)
- [DNSSEC with BIND](https://www.digitalocean.com/community/tutorials/how-to-setup-dnssec-on-an-authoritative-bind-dns-server--2)
- [RFC 1035](https://www.ietf.org/rfc/rfc1035.txt)
- [BIND on CentOS 7](https://www.itzgeek.com/how-tos/linux/centos-how-tos/configure-dns-bind-server-on-centos-7-rhel-7.html)
- [Zone Files](https://en.wikipedia.org/wiki/Zone_file)

# Goal

Implement a `bind9` DNS server on a Docker container with the following capabilities -

* Supports `DNS` and `DNSSEC`
* Disables server banner
* Disables zone transfers
* Restricts container to `named` user


# Steps

1. Place all files to be pushed to the `/etc/bind/` directory inside the `bind/` directory. Note the following -
    * The server banner and zone transfer are disabled in the `named.conf.options` file.
    * The default forwarder is set to `8.8.8.8` in the `named.conf.options` file.
    * The build process signs the zone file. We need to provide the regular zone file (see `db.cyberseclab.uml.edu`). However, we need to mention the signed file name in `named.conf.local`. This is just `.signed` added to the regular zone file.

2. Build the Docker image from the directory containing the `Dockerfile` using the following command: `docker build -t <IMAGE_TAG> --build-arg DOMAIN=<DOMAIN_NAME> --build-arg ZONE_FILE=<ZONE_FILE_NAME> .`

    **Example:** `docker build -t dns --build-arg DOMAIN=cyberseclab.uml.edu --build-arg ZONE_FILE=db.cyberseclab.uml.edu .`

3. Run the Docker container using the following command: `docker run -d --name <CONTAINER_NAME> <IMAGE_TAG>`

    **Example:** `docker run -d --name dns dns`


# Tests

## `dig` Outputs

```
sashank@sndp> dig @172.17.0.2 ns.cyberseclab.uml.edu

; <<>> DiG 9.11.5-P4-5.1ubuntu2.1-Ubuntu <<>> @172.17.0.2 ns.cyberseclab.uml.edu
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 26491
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: d3df2c0e26f8e8b73f2bcec85e25bed134b76488dbcf0721 (good)
;; QUESTION SECTION:
;ns.cyberseclab.uml.edu.		IN	A

;; ANSWER SECTION:
ns.cyberseclab.uml.edu.	604800	IN	A	192.168.7.11

;; Query time: 0 msec
;; SERVER: 172.17.0.2#53(172.17.0.2)
;; WHEN: Mon Jan 20 09:53:05 EST 2020
;; MSG SIZE  rcvd: 95


sashank@sndp> dig +dnssec @172.17.0.2 ns.cyberseclab.uml.edu

; <<>> DiG 9.11.5-P4-5.1ubuntu2.1-Ubuntu <<>> +dnssec @172.17.0.2 ns.cyberseclab.uml.edu
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 45786
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags: do; udp: 4096
; COOKIE: 4be551ba24601147f85300645e25bedba48c22b888009596 (good)
;; QUESTION SECTION:
;ns.cyberseclab.uml.edu.		IN	A

;; ANSWER SECTION:
ns.cyberseclab.uml.edu.	604800	IN	A	192.168.7.11
ns.cyberseclab.uml.edu.	604800	IN	RRSIG	A 13 4 604800 20200219134728 20200120134728 58921 cyberseclab.uml.edu. nYZToJUVUddbCDmG5J1dokCrpp6MpVfMJd0XyuI2ob1VDloojy2NLxAC Nt7Cm08GYTk9G/nxOpA94SB4Y7gReQ==

;; Query time: 0 msec
;; SERVER: 172.17.0.2#53(172.17.0.2)
;; WHEN: Mon Jan 20 09:53:15 EST 2020
;; MSG SIZE  rcvd: 210
```

## Nmap Output

```
sashank@sndp> sudo nmap -sV -sU -sT -p 53 172.17.0.2                                         ~/Desktop
Starting Nmap 7.80 ( https://nmap.org ) at 2020-01-20 09:51 EST
Nmap scan report for 172.17.0.2
Host is up (0.000069s latency).

PORT   STATE SERVICE VERSION
53/tcp open  domain  (unknown banner: none)
53/udp open  domain  (unknown banner: none)
2 services unrecognized despite returning data. If you know the service/version, please submit the following fingerprints at https://nmap.org/cgi-bin/submit.cgi?new-service :
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port53-TCP:V=7.80%I=7%D=1/20%Time=5E25BE66%P=x86_64-pc-linux-gnu%r(DNSV
SF:ersionBindReqTCP,31,"\0/\0\x06\x85\0\0\x01\0\x01\0\0\0\0\x07version\x04
SF:bind\0\0\x10\0\x03\xc0\x0c\0\x10\0\x03\0\0\0\0\0\x05\x04none");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port53-UDP:V=7.80%I=7%D=1/20%Time=5E25BE60%P=x86_64-pc-linux-gnu%r(DNSV
SF:ersionBindReq,2F,"\0\x06\x85\0\0\x01\0\x01\0\0\0\0\x07version\x04bind\0
SF:\0\x10\0\x03\xc0\x0c\0\x10\0\x03\0\0\0\0\0\x05\x04none")%r(DNSStatusReq
SF:uest,C,"\0\0\x90\x04\0\0\0\0\0\0\0\0")%r(NBTStat,1FD,"\x80\xf0\x80\x90\
SF:0\x01\0\0\0\r\0\x0e\x20CKAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\0\0!\0\x01\0\0\
SF:x02\0\x01\0\x07\xe8\xc6\0\x14\x01f\x0croot-servers\x03net\0\xc02\0\x02\
SF:0\x01\0\x07\xe8\xc6\0\x04\x01k\xc0\?\xc02\0\x02\0\x01\0\x07\xe8\xc6\0\x
SF:04\x01e\xc0\?\xc02\0\x02\0\x01\0\x07\xe8\xc6\0\x04\x01g\xc0\?\xc02\0\x0
SF:2\0\x01\0\x07\xe8\xc6\0\x04\x01h\xc0\?\xc02\0\x02\0\x01\0\x07\xe8\xc6\0
SF:\x04\x01d\xc0\?\xc02\0\x02\0\x01\0\x07\xe8\xc6\0\x04\x01c\xc0\?\xc02\0\
SF:x02\0\x01\0\x07\xe8\xc6\0\x04\x01b\xc0\?\xc02\0\x02\0\x01\0\x07\xe8\xc6
SF:\0\x04\x01l\xc0\?\xc02\0\x02\0\x01\0\x07\xe8\xc6\0\x04\x01a\xc0\?\xc02\
SF:0\x02\0\x01\0\x07\xe8\xc6\0\x04\x01j\xc0\?\xc02\0\x02\0\x01\0\x07\xe8\x
SF:c6\0\x04\x01m\xc0\?\xc02\0\x02\0\x01\0\x07\xe8\xc6\0\x04\x01i\xc0\?\xc0
SF:\xdd\0\x01\0\x01\0\t:F\0\x04\xc6\)\0\x04\xc0\xbd\0\x01\0\x01\0\t:F\0\x0
SF:4\xc7\t\x0e\xc9\xc0\xad\0\x01\0\x01\0\t:F\0\x04\xc0!\x04\x0c\xc0\x9d\0\
SF:x01\0\x01\0\t:F\0\x04\xc7\x07\[\r\xc0m\0\x01\0\x01\0\t:F\0\x04\xc0\xcb\
SF:xe6\n\xc0=\0\x01\0\x01\0\t:F\0\x04\xc0\x05\x05\xf1\xc0}\0\x01\0\x01\0\t
SF::F\0\x04\xc0p\$\x04\xc0\x8d\0\x01\0\x01\0\t:F\0\x04\xc6a\xbe5\xc1\r\0\x
SF:01\0\x01\0\t:F\0\x04\xc0\$\x94\x11\xc0\xed\0\x01\0\x01\0\t:F\0\x04\xc0:
SF:\x80\x1e\xc0\]\0\x01\0\x01\0\t:F\0\x04\xc1\0\x0e\x81\xc0\xcd\0\x01\0\x0
SF:1\0\t:F\0\x04\xc7\x07S\*\xc0\xfd\0\x01\0\x01\0\t:F\0\x04\xca\x0c\x1b!\x
SF:c0\xdd\0\x1c\0\x01\0\t:F\0\x10\x20\x01\x05\x03\xba>\0\0\0\0\0\0\0\x02\x
SF:000");
MAC Address: 02:42:AC:11:00:02 (Unknown)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 16.55 seconds
```
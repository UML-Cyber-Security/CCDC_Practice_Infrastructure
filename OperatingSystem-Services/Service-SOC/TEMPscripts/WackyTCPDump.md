## Bad TCP Dump Output Searching ##

### Running the TCP-Dump for your Subnet ###
```bash
#!/bin/bash
rm traffic.pcap

# Start tcpdump in the background and write output to traffic.pcap
sudo tcpdump -i ens18 -w traffic.pcap &

# Get the PID of the tcpdump process
tcpdump_pid=$!

# Sleep for 30 seconds
sleep 15m

# Send SIGINT signal to terminate tcpdump process
sudo kill -SIGINT $tcpdump_pid

# Wait for tcpdump to finish and print message
wait $tcpdump_pid && echo -e "\n\n\n\n\n\n\n------------------\nTCP DUMP FINISHED\n------------------" || echo -e "TCP DUMP TERMINATED!"
```

## Analyze ##

#### Most Popular DESTINATION Ip's 

```bash
echo -e "\n--------------\nPopular DESTINATION IP's:\n--------------\n"
tcpdump -nr traffic.pcap 'net 192.168.0.0/21' | awk '{print $5}' | cut -d. -f1,2,3,4 | sort | uniq -c | sort -nr
```

#### Most Popular DESTINATION Ip's and PORT

```bash
echo -e "\n--------------\nPopular DESTINATION IP's and PORT:\n--------------\n"
tcpdump -nr traffic.pcap 'net 192.168.0.0/21' | awk '{print $5,$4}' | cut -d. -f1,2,3,4 | sort | uniq -c | sort -nr
```

#### Most Popular SOURCE Ip's 

```bash
echo -e "\n--------------\nPopular SOURCE IP's:\n--------------\n"
tcpdump -nr traffic.pcap 'net 192.168.0.0/21' | awk '{print $3}' | cut -d. -f1,2,3,4 | sort | uniq -c | sort -nr
```

#### Most Popular SOURCE Ip's W/ PORT (reverse shell/beacon catcher??)
```bash
echo -e "\n--------------\nPopular SOURCE IP's and PORTS:\n--------------\n"
tcpdump -nr traffic.pcap 'net 192.168.0.0/21' | awk '{print $3,$4}' | sort | uniq -c | sort -nr
```

#### Most Popular SOURCE Ip's W/ PORT W/HOSTNAME
```bash
echo -e "\n--------------\nPopular SOURCE IP's, PORTS, W/ HOSTNAMES:\n--------------\n"
tcpdump -r traffic.pcap 'net 192.168.0.0/21' | awk '{print $3,$4}' | sort | uniq -c | sort -nr
```



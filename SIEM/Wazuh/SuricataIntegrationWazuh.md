# Integration of Suricata into Wazuh

Process to setup Wazuh to monitor and parse Suricata logs/alerts

## 1. Linux Steps (Ubuntu only...?)

Install Suricata on the endpoint

```bash
sudo add-apt-repository ppa:oisf/suricata-stable
sudo apt-get update
sudo apt-get install suricata -y
```

Download and extract the Emerging Threats Suricata ruleset

```bash
sudo suricata-update
```

If fails try following
```bash
sudo suricata-update

cd /tmp/ && curl -LO https://rules.emergingthreats.net/open/suricata-6.0.8/emerging.rules.tar.gz
sudo tar -xvzf emerging.rules.tar.gz && sudo mv rules/*.rules /var/lib/suricata/rules/
cd ~
cd /var/lib/suricata/rules
sudo chmod 640 *.rules
```

Check the network interface on the machine\
(should be top left)\
Check the subnet range (convert subnet mask to CIDR notation)

```bash
ifconfig
```

Modify Suricata settings in `/etc/suricata/suricata.yaml`
Set following variables->

```bash
HOME_NET: "[ubuntu-IP-LOW-Range/CIDR Notation]"
EXTERNAL_NET: "any"

default-rule-path: /var/lib/suricata/rules
rule-files:
- suricata.rules

# Global stats configuration
stats:
enabled: yes

# Linux high speed capture support
af-packet:
  - interface: enp0s3
```

If above suricata update did not add rules, add them manually
```bash
default-rule-path: /var/lib/suricata/rules/
rule-files:
- 3coresec.rules                  
- emerging-ftp.rules             
- emerging-scada.rules
- botcc.portgrouped.rules         
- emerging-games.rules           
- emerging-scan.rules
- botcc.rules                     
- emerging-hunting.rules         
- emerging-shellcode.rules
- ciarmy.rules                    
- emerging-icmp_info.rules       
- emerging-icmp.rules            
- emerging-snmp.rules
- drop.rules                      
- emerging-imap.rules            
- emerging-sql.rules
- dshield.rules                   
- emerging-inappropriate.rules   
- emerging-telnet.rules
- emerging-activex.rules          
- emerging-info.rules            
- emerging-tftp.rules
- emerging-adware_pup.rules       
- emerging-ja3.rules             
- emerging-user_agents.rules
- emerging-attack_response.rules  
- emerging-malware.rules         
- emerging-voip.rules
- emerging-chat.rules             
- emerging-misc.rules            
- emerging-web_client.rules
- emerging-coinminer.rules        
- emerging-mobile_malware.rules  
- emerging-web_server.rules
- emerging-current_events.rules   
- emerging-netbios.rules         
- emerging-web_specific_apps.rules
- emerging-deleted.rules          
- emerging-p2p.rules             
- emerging-worm.rules
- emerging-dns.rules              
- emerging-phishing.rules        
- threatview_CS_c2.rules
- emerging-dos.rules              
- emerging-policy.rules          
- tor.rules
- emerging-exploit_kit.rules      
- emerging-pop3.rules
- emerging-exploit.rules          
- emerging-rpc.rules
```


Restart Suricata service
```bash
sudo systemctl restart suricata
```

Add following to the `/var/ossec/etc/ossec.conf` file on agent machine

```bash
<ossec_config>
  <localfile>
    <log_format>json</log_format>
    <location>/var/log/suricata/eve.json</location>
  </localfile>
</ossec_config>
```

Restart Agent :)
```bash
sudo systemctl restart wazuh-agent
```


## Contributors

Author: Viktor Akhonen
Position: SIEM Team member @ RTUML

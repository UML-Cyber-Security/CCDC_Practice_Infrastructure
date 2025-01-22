## Creating a Port Inventory Dashboard on Wazuh ##
WHAT THIS IS:  
Guide shows how to setup a "port inventory" dashboard for Wazuh, making it able to monitor any/all open ports across the infrastructure, including port numbers, processes used, port count, machine names, etc.  
more info here: <br>
```
https://wazuh.com/blog/detecting-threats-using-inventory-data/
https://documentation.wazuh.com/current/user-manual/capabilities/system-inventory/using-syscollector-information-to-trigger-alerts.html
```
(Some information from blog is outdated and not working on newer Wazuh versions) <br>

### 1. Configure Syscollecter on the Agent
In the ```/var/ossec/etc/ossec.conf```, make sure the following are set: <br>
```
<disabled>no</disabled>
<interval>1m</interval>
<ports all="yes">yes</ports>
```

### 2. Create a Custom Database list for Port that are "Safe" ###
This in on the MANAGER!! <br>
Create CDB file:<br>
```
touch /var/ossec/etc/lists/common-ports
```
List of "safe" ports that won't be tracked: <br>
```
22:
53:
1514:
1515:
```
Configure chmods: <br>
```
chown wazuh:wazuh /var/ossec/etc/lists/common-ports
chmod 660 /var/ossec/etc/lists/common-ports
```

### 3. Add the ruleset to the manager ###
In the ```/var/ossec/etc/ossec.conf``` add the CDB in the ```<ruleset>``` block. <br>
```
<ruleset>
    <!-- Default ruleset -->
    <list>etc/lists/common-ports</list>
</ruleset>
```

### 4. Add specific rules to the xml file ###
Add the rules below to the ```/var/ossec/etc/rules/local_rules.xml``` file to generate alerts when a specific port is opened<br>
```
<group name="syscollector,">
  <!-- ports -->
  <rule id="100310" level="5" >
      <if_sid>221</if_sid>
      <field name="type">dbsync_ports</field>
      <description>Syscollector ports event.</description>
  </rule>

  <rule id="100311" level="5" >
      <if_sid>100310</if_sid>
      <field name="operation_type">INSERTED</field>
      <description>The port: $(port.local_port) was OPENED. </description>
  </rule>

  <rule id="100312" level="5" >
      <if_sid>100310</if_sid>
      <field name="operation_type">MODIFIED</field>
      <description>The port: $(port.local_port) was MODIFIED. </description>
  </rule>

  <rule id="100313" level="5" >
      <if_sid>100310</if_sid>
      <field name="operation_type">DELETED</field>
      <description>The port: $(port.local_port) was CLOSED. </description>
  </rule>
</group>
```
Restart manager: ```systemctl restart wazuh-manager```

### 5. Add monitoring for new Network Interfaces ###
This will push a alert to the dashboard when syscollecter detects new network interface on a agent.<br><nr>
Add the rules below to the ```/var/ossec/etc/rules/local_rules.xml``` file:
```
<group name="syscollector2,">
  
<!-- New network interface -->
  <rule id="100371" level="2">
    <if_sid>221</if_sid>
    <field name="type">dbsync_network_iface</field>
    <description>Syscollector network interface event.</description>
  </rule>

 <rule id="100372" level="9">
   <if_sid>100371</if_sid>
   <field name="operation_type">INSERTED</field>
   <description>New network interface $(netinfo.iface.name) detected!</description>
  </rule>

</group>
```
Restart manager: ```systemctl restart wazuh-manager```



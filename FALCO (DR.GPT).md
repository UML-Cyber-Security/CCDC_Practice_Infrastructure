FALCO (DR.GPT)

1. Install Falco

Follow the official Falco installation guide for your platform
1.	Add Falco’s GPG key and repository:
curl -s https://falco.org/repo/falcosecurity-packages.asc | sudo apt-key add -
echo "deb https://download.falco.org/packages/deb stable main" | sudo tee /etc/apt/sources.list.d/falcosecurity.list

2.	Install Falco:
sudo apt update
sudo apt install falco 
3.	Start and enable Falco: sudo systemctl start falco
sudo systemctl enable falco  ——————————————————————————————————

2. Configure Falco Alert Output
Falco supports various output methods (stdout, file, syslog). Configure it to write alerts to a destination that Wazuh can collect.

Option 1: Write Alerts to a File
1.	Open the Falco configuration file: sudo nano /etc/falco/falco.yaml 2.	Enable file output: file_output:
  enabled: true
  keep_alive: false
  filename: /var/log/falco_alerts.log 3.Restart Falco sudo systemctl restart falco  Option 2: Send Alerts to Syslog
1.	Enable syslog output in falco.yaml: syslog_output:
  enabled: true 2.	Restart Falco: sudo systemctl restart falco
3.	Verify Falco alerts are being sent to the syslog (usually /var/log/syslog on Ubuntu).


 3. Configure Wazuh to Collect Falco Logs

Option 1: Collect Logs from a File 1.	Open the Wazuh agent configuration file: sudo nano /var/ossec/etc/ossec.conf 2.	Add a new <localfile> entry for Falco logs: <localfile>
  <log_format>syslog</log_format>
  <location>/var/log/falco_alerts.log</location>
</localfile> 3.	Restart the Wazuh agent: sudo systemctl restart wazuh-agent  Option 2: Collect Logs from Syslog
1.	Ensure Wazuh is configured to monitor syslog: <localfile>
  <log_format>syslog</log_format>
  <location>/var/log/syslog</location>
</localfile> 2.	Restart the Wazuh agent: sudo systemctl restart wazuh-agent     4. Create Wazuh Decoders and Rules for Falco Alerts

To properly interpret Falco alerts, you need to define decoders and rules in Wazuh.

Step 1: Create a Falco Decoder
1.	Edit or create a custom decoder file: sudo nano /var/ossec/etc/decoders/falco_decoders.xml  2.	Add the decoder for Falco logs: <decoder>
  <name>falco</name>
  <program_name>falco</program_name>
</decoder>  Step 2: Add Rules for Falco Alerts 1.	Edit or create a custom rules file: sudo nano /var/ossec/etc/rules/falco_rules.xml 2.	Add a rule for Falco alerts: <group name="falco">
  <rule id="100001" level="10">
    <decoded_as>falco</decoded_as>
    <description>Falco Alert</description>
    <match>.*</match>
  </rule>
</group> 3.	Restart Wazuh Manager to apply the changes: sudo systemctl restart wazuh-manager . Verify the Integration
1.	Generate a Falco alert:
	Simulate activity that violates a Falco rule (e.g., running a chmod 777 on sensitive files)
2.	Check the Falco output:
	Look for the alert in /var/log/falco_alerts.log or /var/log/syslog.
3.	Check Wazuh:
	Open the Wazuh dashboard and verify that the Falco alert appears in the “Alerts” section.      
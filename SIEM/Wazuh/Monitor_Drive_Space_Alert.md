# How to Monitor Drive Space and Alert

# Windows

## First you want to enable Remote Command Execution on the windows endpoints:

In the `C:\Program Files (x86)\ossec-agent\local_internal_options.conf` append:

`logcollector.remote_commands=1`

Restart Wazuh Agent to Apply Changes:

`Restart-Service -Name wazuh`

## Then Move to the Wazuh Server and Make Changes There

Edit the Shared Agent Config File: 

`nano /var/ossec/etc/shared/default/agent.conf`

Append:

```xml
<agent_config os="Windows">
  <localfile>
    <log_format>command</log_format>
    <command>Powershell -c "Get-Volume -DriveLetter C | Select-Object -Property @{'Name' = '% Free'; Expression = {'{0:P}' -f ($_.SizeRemaining / $_.Size)}}"</command>
    <alias>check_win_disk_space</alias>
  </localfile>
</agent_config>
```

Edit the local rules file:

`nano /var/ossec/etc/rules/local_rules.xml`

Append this:
```xml
<group name="disk_space_utilization,">
  <rule id="100014" level="7">
    <if_sid>530</if_sid>
    <match>^ossec: output: 'check_win_disk_space': </match>
    <regex type="pcre2">[0-1]\d.\d+%$</regex>
    <description>C: Drive free space less than 20%.</description>
  </rule>
</group>
```

Restart Wazuh-Manager:

`service wazuh-manager restart`

## LINUX TODO 
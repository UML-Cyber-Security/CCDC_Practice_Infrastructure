#!/bin/bash
# WHAT IS THIS:
# Script that should be run to reinstall + configure ALL Wazuh agents. This script should work for
# all Linux types and should automatically uninstall and reinstall a Wazuh agent
# Created by VA

if [ "$EUID" -ne 0 ]; then
  echo "ERROR: Must run as superuser"
  exit
fi

# Adds port + inventory + SCA
sed -i.bak 's|<interval>1h</interval>|<interval>5min</interval>|g' /var/ossec/etc/ossec.conf
sed -i.bak 's|<ports all="no">yes</ports>|<ports all="yes">yes</ports>|g' /var/ossec/etc/ossec.conf
sed -i.bak '/<!-- Log analysis -->/a \\n  <localfile>\n    <log_format>audit</log_format>\n    <location>/var/log/audit/audit.log</location>\n  </localfile>' /var/ossec/etc/ossec.conf
sed -i.bak 's|<interval>12h</interval>|<interval>1h</interval>|g' /var/ossec/etc/ossec.conf

# Adds realtime FIM for following files
bash -c 'cat <<EOF | sed "/<!-- Directories to check  (perform all possible verifications) -->/r /dev/stdin" /var/ossec/etc/ossec.conf > /var/ossec/etc/ossec.conf.new
<ignore>/root/.bash_history</ignore>
<directories realtime="yes">/etc/update-motd.d/</directories>
<directories realtime="yes">/etc/motd</directories>
<directories realtime="yes">/etc/sudoers</directories>
<directories realtime="yes">/etc/ssh/sshd_config</directories>
<directories realtime="yes">/etc/sudoers.d</directories>
<directories realtime="yes">/etc/sudoers</directories>
<directories realtime="yes">/etc/bash/bashrc</directories>
<directories realtime="yes">/var/ossec/etc/ossec.conf</directories>
<directories realtime="yes">/var/spool/cron/</directories>
<directories realtime="yes">/etc/security/</directories>
<directories realtime="yes">/etc/hosts.allow</directories>
<directories realtime="yes">/home/*/.ssh/authorized_keys</directories>
<directories realtime="yes">/home/*/.bashrc</directories>
<directories realtime="yes">/etc/group</directories>
<directories realtime="yes">/etc/shadow</directories>
<directories realtime="yes">/etc/passwd</directories>
<directories realtime="yes" check_all="yes" restrict=".sh$">/home</directories>

EOF'

# Adds active response alerts against new user+group creations
bash -c 'cat <<EOF | sed "</active-response>/r /dev/stdin" /var/ossec/etc/ossec.conf > /var/ossec/etc/ossec.conf.new
<active-response>
  <command>user-creation-alert</command>
  <location>local</location>
  <rules_id>5902</rules_id>
</active-response>

EOF'

# Adds proper custom active resopnse script
touch /var/ossec/active-response/bin/user-creation-alert
cat << EOF >> /var/ossec/active-response/bin/user-creation-alert
#!/bin/bash
wall "WAZUH WARNING: A new user has been added to this system"
EOF
sudo chmod 750 /var/ossec/active-response/bin/user-creation-alert
sudo chown root:wazuh /var/ossec/active-response/bin/user-creation-alert

# Adds auditd logging + alerts
######## THIS PART NOT DONE YET #########
<localfile>
    <location>/var/log/audit/audit.log</location>
    <log_format>audit</log_format>
</localfile>
######## THIS PART NOT DONE YET #########
sudo mv /var/ossec/etc/ossec.conf.new /var/ossec/etc/ossec.conf
sudo systemctl restart wazuh-agent

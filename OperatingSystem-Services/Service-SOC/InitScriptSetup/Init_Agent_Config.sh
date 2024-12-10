#!/bin/bash
# WHAT IS THIS:
# Initial Wazuh agent configuration that should be ran on each new agent that is created.
#
# TODO: Currently just appends everything to the config file, would be nice to not add all the rules if they are already there
# OSSEC CONFIG FOR AUDITD IS CURRENTLY BROKEN? This needs to be tested as I am not sure
# Created by VA
## Must run as superuser ##

if [ "$EUID" -ne 0 ]; then
  echo "ERROR: Must run as superuser"
  exit
fi

# Below adds port+system inventory scanning every 3 minutes on each endpoint. Also adds auditd logging (agents need auditd installed)
sed -i.bak 's|<interval>1h</interval>|<interval>3min</interval>|g' /var/ossec/etc/ossec.conf
sed -i.bak 's|<ports all="no">yes</ports>|<ports all="yes">yes</ports>|g' /var/ossec/etc/ossec.conf
sed -i.bak '/<!-- Log analysis -->/a \\n  <localfile>\n    <log_format>audit</log_format>\n    <location>/var/log/audit/audit.log</location>\n  </localfile>' /var/ossec/etc/ossec.conf

# Below adds realtime FIM location monitoring on each endpoint
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
sudo mv /var/ossec/etc/ossec.conf.new /var/ossec/etc/ossec.conf
sudo systemctl restart wazuh-agent

# Bash Script for Linux FIM setup

Copy and paste into terminal as ROOT user

```
sudo bash -c 'cat <<EOF | sed "/<!-- Directories to check  (perform all possible verifications) -->/r /dev/stdin" /var/ossec/etc/ossec.conf > /var/ossec/etc/ossec.conf.new
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
<directories realtime="yes">/var/ossec/etc/wazuh-auto-restart.sh</directories>
<directories realtime="yes">/etc/group</directories>
<directories realtime="yes">/etc/shadow</directories>
<directories realtime="yes">/etc/passwd</directories>
<directories realtime="yes" check_all="yes" restrict=".sh$">/home</directories>

<directories realtime="yes">/opt/vault/config.hcl</directories>
<directories realtime="yes">/vault/config.hcl</directories>
<directories realtime="yes">/opt/vault/tls*</directories>
<directories realtime="yes">/opt/vault/tls/tls.cert</directories>
<directories realtime="yes">/opt/vault/tls/tls.key</directories>

EOF'
sudo mv /var/ossec/etc/ossec.conf.new /var/ossec/etc/ossec.conf
sudo systemctl restart wazuh-agent
```
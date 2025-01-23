#!/bin/bash
# Linux Audit Script
# UML and RIT edits
# Must be run as superuser #

if [ "$EUID" -ne 0 ]; then
  echo "Must run as superuser"
  exit
fi

sl="sleep"
s="sudo"
t="0s"

timestamp() {
  echo -e "\n------------------------------"
  echo -e "-------- Init_Audit.sh --------"
  echo -e "------------------------------\n"
  echo -e "\n\n-------- $(date) --------\n\n"
}

basic(){
    echo -e "\n-------------\n > Machine INFO <\n------------- "
    $s cat /etc/os-release | grep -i PRETTY_NAME
    $s cat /etc/hostname
    echo -e "Most likely MAC below(check this)"
    $s ip a | grep -i link/ether | head -n 1

    echo -e "\nHardware: "
    $s lscpu | grep -i Architecture

    echo -e "\n"
    $s df -h
    sleep $t

    echo -e "\n-------------\n > Aliases <\n------------- "
    alias
    sleep $t

    echo -e "\n--------------\n > SSH Keys <\n-------------- "
    $s cat /etc/ssh/sshd_config | grep -i AuthorizedKeysFile
    $s head -n 20 /home/*/.ssh/authorized_keys*
    $s head -n 20 /root/.ssh/authorized_keys*
    sleep $t

    echo -e "\n-----------------------\n > User Accounts <\n----------------------- "
    echo -e "/home directory: "
    $s ls /home/
    echo -e "All users w/ shells: \n"
    user_list=$(grep -E "/bin/(bash|sh|zsh|fish)" /etc/passwd | cut -d':' -f1); # shells to check for

    for user in $user_list; do
      echo "$user"
    done
    sleep $t

    echo -e "\n-------------\n > Important Groups <\n------------- "
    $s cat /etc/group | grep -i root
    $s cat /etc/group | grep -i wheel
    $s cat /etc/group | grep -i sudo
    $s cat /etc/group | grep -i docker
    $s cat /etc/group | grep -i ansible
    $s cat /etc/group | grep -i crontab
    sleep $t

    echo -e "\n-------------\n > .bashrc Command Check <\n------------- "
    $s cat /home/*/.bashrc | grep -Ei 'exec |.sh |systemctl'
    echo -e "\n"
    $s cat /root/.bashrc | grep -Ei 'exec |.sh |systemctl'
    echo -e "\n"
    $s tail -n 7 /home/*/.bashrc
    echo -e "\n"
    $s tail -n 7 /root/.bashrc
    echo -e "\n"
    sleep $t

    echo -e "\n-------------\n > /etc/profile Check <\n------------- "
    $s tail -n 7 /etc/profile
    sleep $t

    echo -e "\n-------------\n > SSHD Config Check <\n------------- "
    cat /etc/ssh/sshd_config | grep -i Include
    echo -e "\n"
    cat /etc/ssh/sshd_config | grep -i PasswordAuthentication | head -n 1
    cat /etc/ssh/sshd_config | grep -i PubkeyAuthentication | head -n 1
    cat /etc/ssh/sshd_config | grep -i PermitRootLogin | head -n 1
    cat /etc/ssh/sshd_config | grep -i X11Forwarding
    echo -e "\n.conf file includes: (check these!)"
    ls /etc/ssh/sshd_config.d/
    sleep $t

    echo -e "\n--------------------\n > Auth Backdoors <\n-------------------- "
    $s cat /etc/sudoers | grep NOPASS
    $s cat /etc/sudoers | grep NOPASSWD
    $s cat /etc/sudoers | grep !AUTH
    $s find / -type f \( -name ".rhosts" -o -name ".shosts" -o -name "hosts.equiv" \) -exec ls -l {} \;
    cat /etc/sudoers | grep -i secure_path=
    sleep $t

    echo -e "\n-------------------------\n > Currently Logged In <\n------------------------- "
    $s who
    $s w
    sleep $t

    echo -e "\n-------------------\n > login history <\n------------------- "
    $s last | grep -Ev 'system' | head -n 20
    sleep $t

    echo -e "\n-------------\n > Firewall <\n------------- "
    $s ufw status
    sleep $t

    echo -e "\n-------------------------------\n > Current Network Listening <\n------------------------------- "
    $s ss -tulpnw
    sleep $t

    echo -e "\n-----------------\n > lsof Remote <\n----------------- "
    $s lsof -i
    sleep $t

    echo -e "\n----------------------------\n > Potental Rootkit Signs <\n---------------------------- "
    $s dmesg | grep taint
    $s env | grep -i 'LD'
    sleep $t

    echo -e "\n-----------------------\n > Mounted Processes <\n----------------------- "
    $s mount | grep "proc"
    sleep $t
}

verbose(){
    echo -e "\n-------------\n > Wazuh Agent Check <\n------------- "
    $s test -e /var/ossec/etc/ossec.conf && echo "Agent ossec.conf exists" || echo "Agent ossec.conf file is missing!"
    echo -e "Manager IP: "
    $s cat /var/ossec/etc/ossec.conf | grep -i "<address>"
    echo -e "Agent Name: "
    $s cat /var/ossec/etc/ossec.conf | grep -i "<agent_name>"
    sleep $t

    echo -e "\n-------------\n > Graylog Basic Monitoring <\n------------- "
    echo -e "(If blank here no (basic) logging found)"
    # checks basic rsyslog logging
    $s cat /etc/rsyslog.conf | grep -i RSYSLOG_SyslogProtocol23Format
    $s cat /etc/rsyslog.d/* | grep -i RSYSLOG_SyslogProtocol23Format

    # checks for sidecar for all linux OS
    if [ -f /etc/graylog/sidecar/sidecar.yml ]; then
      echo "GRAYLOG SIDECAR configuration file found. There should be logging happening..."
    fi

    # CHECK HERE FOR JOURNALD LOGGING?

    sleep $t

    echo -e "\n-------------\n > History Traces <\n------------- "
    $s find /home/* -name "docker-compose"

    echo -e "Bash history snippet: "
    $s tail -n 350 /root/.bash_history | grep -Ei 'compose|curl|apt|yum|dnf|wget|git clone|docker|ctr|pip|snap'
    $s tail -n 350 /home/*/.bash_history | grep -Ei 'compose|curl|apt|yum|dnf|wget|git clone|docker|ctr|pip|snap|sudo'
    sleep $t

    echo -e "\n-------------\n > Auto Runs <\n------------- "
    $s cat /etc/crontab | grep -Ev '#|PATH|SHELL'
    $s cat /etc/cron.d/* | grep -Ev '#|PATH|SHELL'
    $s find /var/spool/cron/crontabs/ -printf '%p\n' -exec cat {} \;
    $s systemctl list-timers
    sleep $t

    echo -e "\n---------------\n > Processes <\n--------------- "
    $s ps af
    sleep $t

    echo -e "\n-------------------------\n > Poisoned Networking <\n------------------------- "
    $s cat /etc/nsswitch.conf
    $s cat /etc/hosts
    $s cat /etc/resolv.conf | grep -Ev '#|PATH|SHELL'
    $s ip netns list
    $s ip route
    sleep $t

    echo -e "\n---------------\n > Ips and macs <\n--------------- "
    ip -c route | grep "default"
    echo -e ""
    ip -br -c a
    echo -e "\n[MAC]"
    ip -br -c link

    echo -e "\n---------------\n > Services <\n--------------- "
    $s find /etc/systemd/system -name "*.service" -exec cat {} + | grep ExecStart | cut -d "=" -f2  | grep -Ev "\!\!"
    sleep $t

    echo -e "\n------------------------------\n > Files Modified Last 10Min <\n------------------------------ "
    echo -e "/etc"
    $s find / -xdev -mmin -10 -ls 2> /dev/null
    echo -e "/home"
    $s find /home -xdev -mmin -10 -ls 2> /dev/null
    echo -e "/root"
    $s find /root -xdev -mmin -10 -ls 2> /dev/null
    echo -e "/bin"
    $s find /bin -xdev -mmin -10 -ls 2> /dev/null
    echo -e "/sbin"
    $s find /sbin -xdev -mmin -10 -ls 2> /dev/null
    sleep $t

    echo -e "\n------------------\n > Repositories <\n------------------ "
    $s cat /etc/apt/sources.list | grep -Ev "##|#"
    sleep $t

    echo -e "\n------------------\n > Malware? <\n------------------"
    dpkg -l | grep "sniff"
    dpkg -l | grep "packet"
    dpkg -l | grep "wireless"
    dpkg -l | grep "test"
    dpkg -l | grep "password"
    dpkg -l | grep "crack"
    dpkg -l | grep "spoof"
    dpkg -l | grep "brute"
    dpkg -l | grep "log"
    dpkg -l | grep "network"
    dpkg -l | grep "server"
    dpkg -l | grep "CVE"
    dpkg -l | grep "exploit"
    dpkg -l | grep "ncat"
    dpkg -l | grep "socat"
    dpkg -l | grep "netcat"
    dpkg -l | grep "tcpdump"
    dpkg -l | grep "rsh"
    dpkg -l | grep "rexec"
    dpkg -l | grep "rlogin"
    dpkg -l | grep "rlogin"
    dpkg -l | grep "rpcbind"
    dpkg -l | grep "lynis"
    sleep $t

    echo -e "\n------------------\n > Active Running Services <\n------------------ "
    $s systemctl list-units --type=service --state=running
    sleep $t
}

# Get User Input to get sleep time and Type
timestamp
echo -ne "Enter Option (Default : Basic)\n1) Basic Mode\n2) Verbose Mode\n\n : "
read opt
echo -n "Pause Time For Each Section (Default 0) : "
read sec

# Set Pause Time
if [[ -n $sec ]]; then
  t=${sec}s
fi

# Run User Selected Mode
if [[ $opt == 1 ]]; then 
  basic
  #exit 0
else
  basic
  verbose
  #exit 0
fi
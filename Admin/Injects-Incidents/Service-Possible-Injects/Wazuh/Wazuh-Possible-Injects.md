## Introduction
The hope of this document is to provide two very possible vulnerabilities that SOC can encounter using Wazuh.
A description and mitigation will be provided for each.
Apart from vulnerabilities, it will showcase two very possible Injects that SOC can recieve.
Predicting possible injects is good practice to stay ahead of the competition.

## Common Attack Tool Execution Inject I

### Description
By creating a Reverse Shell threat actors can gain remote access and compromise the integrity of our systems.
Common technique and tools are available to stablish such shells.
Create a custom alert to notify execution of software such as netcat or other suspicious one.

### steps
1. Gather All Running Processes
    1. Inside every agent ossec.conf located at
        ```bash
            foo@bar:/var/ossec/etc$
        ```
        add the following
        ```yml
        <ossec_config>
            <localfile>
                <log_format>full_command</log_format>
                <alias>process list</alias>
                <command>ps -e -o pid,uname,command</command>
                <frequency>30</frequency>
            </localfile>
        </ossec_config>
        ```
    2. Restart the Wazug Agent
        ``` bash
        foo@bar:/var/ossec/etc$ sudo systemctl restart wazuh-agent
        ```
2. Create a rule to gather all running processes and also trigger if a specific one is found
    1. Inside Wazuh Server's local_rules.xml located at
        ```bash
            foo@bar:/var/ossec/etc/rules#
        ```
        Insert the following rule (modify accordingly)
        ```yml
            <group name="ossec,">
                <rule id="100050" level="0">
                    <if_sid>530</if_sid>
                    <match>^ossec: output: 'process list'</match>
                    <description>List of running processes.</description>
                    <group>process_monitor,</group>
                </rule>

                <rule id="100051" level="7" ignore="900">
                    <if_sid>100050</if_sid>
                    <match>nc -l</match>
                    <description>netcat listening for incoming connections.</description>
                    <group>process_monitor,</group>
                </rule>
            </group>
        ```
    2. Restart Wazuh Manager
        ```bash
            foo@bar:/var/ossec/etc/rules sudo systemctl restart wazuh-manager
        ```
    3. Create Dashboard to visualize the new rule id


## Possible Inject II

### Description
Given a list of New Hires, Install Wazuh to secure their system

### Step
1. Configure proper access as an example:
    ```ansible
    # Copyright Joan Montas
    # All rights reserved.
    # License under GNU General Public License v3.0

    ---
    - name: Configure SSH on Hosts
    hosts: machines
    become: yes
    tasks:
        - name: Copy Public Key to Authorized Keys
        authorized_key:
            user: "{{ ansible_user }}"
            key: "{{ lookup('file', '~/.ssh/id_ed25519.pub') }}"
            state: present

        - name: Disable SSH Password Authentication
        lineinfile:
            dest: /etc/ssh/sshd_config
            regexp: '^PasswordAuthentication'
            line: 'PasswordAuthentication no'
            backup: yes

        - name: Disable SSH Root Login
        lineinfile:
            dest: /etc/ssh/sshd_config
            regexp: '^PermitRootLogin'
            line: 'PermitRootLogin no'
            backup: yes
        
        - name: Restart SSH Service
        command: service ssh restart

    ```
2. Install Wazuh Agent (OS Specific)
    ```ansible
    ---
    - name: Install wazuh agent
    hosts: ubuntumachines
    become: yes
    tasks:
        - name: Download Wazuh agent package
        get_url:
            url: https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.7.1-1_amd64.deb
            dest: /home/ansible/wazuh-agent_4.7.1-1_amd64.deb
            mode: 0644
        - name: Install Wazuh agent
        become: yes  # Ensures privilege escalation for installation
        shell: |
            export WAZUH_MANAGER="192.168.2.122"  # Uses ansible_ssh_host for current host
            export WAZUH_AGENT_NAME="{{ inventory_hostname }}"  # Uses inventory hostname
            dpkg -i /home/ansible/wazuh-agent_4.7.1-1_amd64.deb

        - name: Daemon reload 
        command: sudo systemctl daemon-reload
        - name: Enable wazuh-agent 
        command: sudo systemctl enable wazuh-agent
        - name: Start wazuh-agent 
        command: sudo systemctl start wazuh-agent
    ```


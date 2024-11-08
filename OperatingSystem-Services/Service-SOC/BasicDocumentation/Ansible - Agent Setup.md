## Quick Guide on how to use Ansible w/ Wazuh ##
<br>
### Update to use roles from official Guthub repo? Try to pull or push into here, play books as well, then integrate own cmdns into there as well ###

Playbook - List of commands that are sent out to the managed nodes?? <br>
Inventory File - List of machines w/ IP adress plus login info that playbook commands will run on

### Important: copy over your key to all machines? ###
For control node: Python 3.8 or newer required <br>
For managed node: Python 2.6 or newer <br>
ALL Linux based systems to install Ansible <br> 

1. Update ansible Personal Package Archive 
```sudo add-apt-repository --yes --update ppa:ansible/ansible```
2. Install Ansible
```sudo apt install ansible```
3. Can verify installation w/ 
```ansible --version```

### Add Keys to Machines ###

```ssh-keygen -t rsa -b 2048```  
Can copy the keys over with:  
```ssh-copy-id username@remote_host```

### Clone Wazuh Ansible Repo ###

```
cd /etc/ansible/roles/
sudo git clone --branch v4.9.2 https://github.com/wazuh/wazuh-ansible.git
ls
```
IMPORTANT MAKE SURE BRANCH VERSION IS LATEST!!!  
https://documentation.wazuh.com/current/deployment-options/deploying-with-ansible/guide/install-ansible.html  


Output: `wazuh-ansible`

### Install the Agents ###

1. Edit ansible wazuh-agent role file:  
```sudo nano /etc/ansible/roles/wazuh-ansible/playbooks/wazuh-agent.yml```  
Change `hosts` and `wazuh manager address`

2. Add agents to `hosts` file (/etc/ansible/hosts)
```
[wazuh-linux]
test1 ansible_host=192.168.2.94 ansible_ssh_user=blueteam
test2 ansible_host=192.168.2.55 ansible_ssh_user=blueteam
```

3. Run the Playbook
```
cd /etc/ansible/roles/wazuh-ansible/playbooks
ansible-playbook wazuh-agent.yml -b -K
```
/var/ossec/bin/agent_control -l

### Agent Configuration Playbooks ###

For now, replacing the /default/main.yml with the one from repo should setup all configs!!  

1. Pull all playbooks from repo to playbook folder:  
```pull command here lolz```

2. Playbook information
- Agent config -> blahblahblah
- This one -> creates this and this
- playingbook -> plays with the books

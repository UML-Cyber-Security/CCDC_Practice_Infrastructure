# **Adding and Removing Agents**

Change to the playbooks directory using the following command and run the necessary playbooks

``` cd Baremetal_Install/playbooks ```

## **Adding Debian agents**

- The SOC team will give you a command to be run on the Debain agents. Replace the command in *add_agent_debian.sh* with the command the SOC team has given you and then run the following command to add debian machines as an agent

``` ansible-playbook -vvv add_agent_debian.yml ```

## **Removing Debian Agents**

To remove a debian machine as an agent from Wazuh, run the following command

```ansible-playbook remove_agent_debian.yml```

## **Adding CentOS agents**

- The SOC team will give you a command to be run on the CentOS agents. Replace the command in *add_agent_centos.sh* with the command the SOC team has given you and then run the following command to add debian machines as an agent

``` ansible-playbook -vvv add_agent_centos.yml ```

## **Removing CentOS Agents**

To remove a debian machine as an agent from Wazuh, run the following command

```ansible-playbook remove_agent_centos.yml```

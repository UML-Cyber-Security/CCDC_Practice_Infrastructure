# **Deploying SOC**

## **Pre-Requisites**

Change to playbooks directory by using the below command

``` cd Baremetal_Install/playbooks ```

- The playbooks are designed to run the tasks on various remote machines running different operating systems
- Ensure that the ***inventory***  file has the IP addresses of the remote hosts as below

```

[SOC_Server]
192.168.0.121

[Debian_Agents]
192.168.0.66

[Windows_Agents]

[CentOS_Agents]
```

Follow the below mentioned steps to deploy Wazuh and Suricata on the remote machine.

## **Deploying Wazuh**

We are going to deploy Wazuh on a single node initally and it can be done by running the following command

``` ansible-playbook -vvv wazuh-single.yml ```

## **Deploying Suricata**

To deploy suricata and integrate it with Wazuh, run the below command. This will also integrate docker logs into Wazuh.

``` ansible-playbook -vvv suricata.yml ```

We are running the playbooks in verbose mode to be careful when deploying and it is easier to debug when in verbose mode.

## **Enabling Debian Agents to send Docker logs to the server**

To enable the Debian Agents to send docker logs to the wazuh server, run the following command

``` ansible-playbook docker _agent.yml ```

## **Enabling CentOS Agents to send Docker logs to the server**

To enable the CentOS Agents to send docker logs to the wazuh server, run the following command

``` ansible-playbook docker-agent.yml -i CentOS_Agents ```

## **Enabling Wazuh Server to collect the docker logs sent by agents**

To enable the wazuh server to collect docker logs from the remote agents, run the following command

``` ansible-playbook shared_agent.yml ```

## **Additional manual configs to Wazuh Server**

The SOC team is to refer to the [ossec.conf](Baremetal_Install/playbooks/ossec.conf) file in the repo and manually replicate the above file on the wazuh server. This would just involve enabling a lot of the logs.
Remember to restart the Wazuh Manager when any changes are made to the /var/ossec/etc/ossec.conf file

## **Additional manual configs to Suricata Config**

The SOC team is to refer to the [suricata.yaml](Baremetal_Install/playbooks/suricata.yaml) file and replicate the same on the suricata server.

## **Using tags to restart services**

To restart Wazuh and Suricata use the following command

``` ansible-playbook suricata.yml --tags restart_services ```

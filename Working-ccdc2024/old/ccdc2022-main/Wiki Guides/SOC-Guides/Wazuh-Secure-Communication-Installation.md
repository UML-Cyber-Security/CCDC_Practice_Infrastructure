Author: Chris Morales


# Both SOC and NOC members.


## Link for the guide

https://documentation.wazuh.com/current/user-manual/registering/host-verification-registration.html

Remember, this is just to establish a secure communciation, not installing the agent. You will need to install that first.

The general way to go is:

    1. Install Wazuh Agent (Not in this guide.)
    2. Establish the secure communication.

## Advice for both teams

1. **Make sure that the  _"Registration with Wazuh manager verification"_ tab is chosen.**

2. The guide above provides the right commands. You can **almost** simply run them by copying and pasting them.

3. **Make sure that you specify the right name for the server's .pem file that is given by the SOC team.**

4. For example, the guide has "rootCA.pem", but sometimes it can be "root-ca.pem" and cause all types of havoc. Double-check.

5. **Make sure that you're doing this under an administrative / root account.**

6. **When you finish, please confirm with the SOC team.**

# Clients (Wazuh-Agent Hosts)

To register an agent. You will start on the guide from above starting at the *The Wazuh agent registration using CA and enabling the communication with the Wazuh manager.*


## Wazuh Secure Communication - Windows

Justin was nice enough to make a powershell script. It's pretty simple to use, he gives examples of how to run. 

Use the install command if the Wazuh agent has not been installed (it should but just in case). Also, double check with the SOC team to ensure that the version of Wazuh that is being installed is correct. (If the SOC team hasn't already said it.)

## Wazuh Secure Communication - Linux

There isn't a script made for us, but the commands are super simple to copy and paste. Would be more work to make a script asking for user input.

The steps are under the *Linux/Unix Host* tab.

1. Copy the CA .pem file into the /var/ossec/etc directory
    ```
    cp <path to pem file including the pem file> /var/ossec/etc
    ```
2. Register the Wazuh agent and give it a meaningful name.
    ```
    /var/ossec/bin/agent-auth -m <manager_IP> -v /var/ossec/etc/rootCA.pem -A <agent Name>
    ```
3. Make sure that the configuration file specifies the right server IP. Screenshot in the guide. But you'll be looking in the */var/ossec/etc/ossec.conf* file. 


4. Restart the Wazuh agent. 

    ```
    sudo systemctl restart wazuh-agent
    ```

# SOC team specific
We follow the first half of the guide for making the SSL certificates. 

If the Wazuh manager certificate hasn't been made already, run the first command. If the all-in-one installation was done correctly (with the unattended installation), then the root-ca.pem has already been made. 

We just need to generate a SSL certificate that will be used for communication with the agents. That's where the first part comes into play.

Just follow the guide, changing the "manager IP" with the server's IP in step 1, then run the two commands. Again, make sure that name of the **root CA .pem and private key files are correct** in step 2.

Steps 3 and 4 are exactly as they need to be. Now we just need the client stuff.




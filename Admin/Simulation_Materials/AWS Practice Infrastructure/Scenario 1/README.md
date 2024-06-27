# Practice Scenario 1
*Author: Chris Morales*

*First time given out: 3/16/2024*

*Average Deployment Time*: Less than 10 minutes.

## General Idea
This scenario is essentially the beginning of future practices for future CCDC teams at UML. While this is mainly a POC, it can be used as a reference and modified to spin up various different infrastructures with varying degrees of complexity.

Now, this scenario was a result of an unforeseen power outage that caused a rapid shift in original plans. And so, the actual machines and services are completely barebones with the help of some red team pre-compromises already in place :)

And so, this scenario puts the team under the stress of trying to find out what services they have available to them (hint hint, there are no services) and see how fast they can understand the infrastructure that was given to them. It's mainly to understand their process about when their thrown into unfamiliar territory.

## How to deploy

### Prerequisites
You'll need a system that can run:
1) Terraform - May need to do `terraform init` if all the states and the .terraform directory are absent.
2) AWS CLI - Ensure the `region` within the `Terraform/main.tf` file is what the default region of the machine running the `gather_credentials.py` file is using. Also ensure that you have a working Access Token to an account that has permissions to setup VPCs, Security Groups, EC2 instances and do networking with subnets, internet gateways and NAT Gateways.
3) Ansible - Ensure that you're using the `AWS-CCDC-Blackteam.pem` file that is provided.
4) Python - Make sure that you can run some python scripts that are noted below. Testing was done using both python and python3.


### Steps
This is a very linear set of steps to deploy this scenario. Check all the configuration files are correct. For instance, you may want to change the number of instances of each OS you want. You can change that within `Terraform/modules/instance/variables.tf`. Original scenario had 6 windows, 5 Ubuntu, and 3 RHEL machines.

One configuration you may want to change is the `CR-VPN-Pub-IP` variable located within `Terraform/modules/security_group/variables.tf` file. This is because you want this to reflect the public IP address of the machine that is trying to setup this environment. Ansible will be dependent on this SSH connection and so without it, then you can't spin up the WireGuard server; thus not get the full scenario.

1. Run terraform configuration - `cd` into the `Terraform` directory and run
    ```
    terraform apply
    ```

2. Wait for roughly 2 minutes while the machines (particular the Wireguard VPN server) start. This will allow the SSH server on the Wireguard machine to start and accept our connection.
3. Now that this is done, you can now run the `gather-credentials.py` Python script with
   ```
   python gather-credentials.py
   ```
    You'll be given two files named 'instance_information.csv' and 'blackteam-inventory.yml'. These two files are crucial to the scenario. The first will hold the login information to the machines that they have. Most importantly, it will hold the private IP addresses for the team to use to begin their simulation. This can be given to the students directly.

    The other file is needed to setup the Wireguard VPN server. Copy this to the `../Ansible/` directory and replace the existing blackteam-inventory.yml file.

4. Now, you're ready to initialize the blackteam Wireguard VPN server. You can now run

    ```
    ansible-playbook -i blackteam-inventory.yml initialize-environment.yml
    ```

    After a successful run, you will see in the `Ansible/` directory a new directory named `exported-certs`. This will contain all the certs (not organized into subfolders) that were generated for use by the blackteam, blueteam and redteam respectively. Organize and distribute them as you see fit.


And that's it! You now have a full infrastructure ready to go that will help the blue team practice! Good luck!

### Friendly Reminders

1. If you are on the CR VPN, make sure to disconnect before going to WireGuard connection :)

2. The Web GUI for Wireguard VPN will be `http://<WireGuardIP>:51821`. password is the blackteam password given.

3. All the blueteam accounts are given NOPASSWD permissions. If they're wondering about the password for root... why are they not resetting it in the first place ;)

4. When doing a `terraform destroy`, make sure you're disconnected from the WireGuard VPN or else the state of Terraform might be corrupted and manual effort will be needed to clean up the rest.


## RHEL Notes
After much dissection and frustration. The RHEL 9 AMI that this scenario originally used comes with an error that is not present the first time around.

*Problem:* After creating the `blueteam` user on the EC2 instance and giving them all the permissions that they need, I tried to login to confirm access for `blueteam` using the password.

You'll notice if you try to login for the first time that you get an error stating that password-based authentications are not allowed and that public-key authentication likely the only method allowed.


### Solution part 1: Enable PasswordAuthentication

The most common method to fix this is to look at the `/etc/ssh/sshd_config` file and see if `PasswordAuthentication` is set uncommented and set to `yes`.

Restart the service with `sudo systemctl restart sshd`


### Solution part 2: Extra AMI-based default SSH configurations

This didn't work and I see that original error message stating that password-authentication is not allowed.

Now, we need to look into the configuration file to figure out why password authentication isn't allowed. Again, inside of `/etc/ssh/sshd_config`, you'll see the line

```
Include /etc/ssh/sshd_config.d/*.conf
```

buried in the middle of some commented out code. This means that if there are additional configurations inside the `/etc/ssh/sshd_config.d/` directory, then SSH will use those.


Looking through the file that's located in there, we can see that there is a single line in the file that shows

```
PasswordAuthentication no
```

Great. This looks like what we're looking for. Just simply delete the file or comment out the line in this configuration and then restart the SSH service.

Restart the service with `sudo systemctl restart sshd`


Let's try it out.

...

It looks like it worked. And... to no success. Now what?

Lets look at the logs of the SSH service using `sudo systemctl status ssh`

![](Images/SSHD-Status-Shadow-Error.png)

What? What does it mean?

So, it's having trouble consulting the `shadow` file for our user. I then confirmed the permissions of the shadow file which is `000` in the standard RHEL distribution. This doesn't cause an issue. I can even login using the password with a `su blueteam` command. So it's still something wrong with SSH. Let's keep looking.




### Solution part 3: Misconfigured SSH configuration file
You'll notice in the screenshot that something is wrong here.

![](Images/SSHD-Pam-Misconfiguration.png)

This is part of the standard RHEL AMI image that is given. This seems to be Red Hat's way of discouraging password-based authentication.

And so, turning this to `yes` and uncommenting it solved this issue of not having password-based authentication for SSH using a base RHEL AMI image on AWS.
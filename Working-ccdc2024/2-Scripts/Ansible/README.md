# **Install Ansible and setup the Inventory**

## **Install Ansible on a Debian Machine**

To install ansible on a Debian machine, run the following script

``` bash install_ansible_debian.sh ```

To install ansible on a CentOS machine, run the following script

``` bash install_ansible_centos.sh ```

## **Modifying the Inventory file**

- Open the inventory file and put in the IP addresses of the remote machines based on their operating system.
- If you would like to specify a different user to provision services as, make sure to enter the user name under ansible_user=username

# How to install agent on a FreeBSD operating system

First we want to know the name of the agent package we want to install so do:

```bash
pkg search wazuh
```

Then Choose the package that we want to install:

```bash
pkg install <package_name>
```

After the agent is installed you will want to follow these steps to get it set up correctly:

```bash
cp /etc/localtime /var/ossec/etc
```

Edit the Ossec.conf file so it is the same as your machines IP:

```bash
vim /var/ossec/etc/ossec.conf
```

Edit the rc config file so the Wazuh agent boots on start

```bash
vim /etc/rc.conf
```

At the bottom of this file put:

```
sysrc wazuh_agent_enable="YES"
```

Finally start the wazuh-agent with:

```bash
service wazuh-agent onestart
```
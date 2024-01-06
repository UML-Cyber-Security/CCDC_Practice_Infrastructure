# sysctl
##### Written by a sad Matthew Harper
## What is it
This is the command line utility that we use to affect changes in the operations of the kernel. This is done by changing various kernel tunable. They are values (files) we write values to that change the operations of the system's kernel. 

There are a variety of ways we can interact with the tunables, in our case we write to a file in the **/etc/sysctl.d/*.conf** for persistance. We can directly use the **sysctl** utility or write values to files in the virtual process filesystem **/proc/sys** 

## Commands 

We can list all of the tunables with the following commands. They also list their value(s).
```sh
# List all tunables and their values
sysctl -a

# List the named tunable
sysctl <tunable_class>.<tunable>
```


We can write values to the variables by doing the following 
```sh
# Temporary (Also can add a -w)
sysctl <tunable class>.<tunable>=<value>

# Persistent
sysctl -w <tunable class>.<tunable>=<value> >> /etc/sysctl.conf
```

We can also write to a *.conf* file in the **/etc/sysctl.d/** directory which will be loaded at boot. Note that there is a numerical scheme for loading and we should often put custom rules in a file prefixed with 99. However any .conf will be loaded (based on README in the dir).

We can load a conf file without rebooting the system by doing the following.
```sh
sysctl -p /etc/sysctl.d/99-custom.conf
```

## What are we setting 
* net.ipv4.conf.all.send_redirects = 0
  * Default is 1
  * All means apply to all interfaces
    * We also change the default -- not noted here
  * Allows the system to send redirects (Used if acting as a router)-- We disable this.
* net.ipv4.conf.all.accept_source_route = 0
  * Default is 1
  * All means apply to all interfaces
    * We also change the default -- not noted here
  * Allows the system to accept source routed packets. Since this is disable we force the kernel to preform reverse path filtering on a received packet.
* net.ipv6.conf.all.accept_source_route = 0
  * IPv6 version of the IPv4 setting!
* net.ipv4.conf.all.accept_redirects = 0 
  * Defualt value of 1
  * All means apply to all interfaces
    * We also change the default -- not noted here
  * Allows the system to accept ICMP redirect messages. We disable this as it can be exploited to route traffic to malicious hosts.
* net.ipv6.conf.all.accept_redirects = 0 
  * IPv6 version of the IPv4 setting!
* net.ipv4.conf.all.secure_redirects = 0
  * Default of 1
  * All means apply to all interfaces
    * We also change the default -- not noted here
  * Allows the system to accept ICMP redirects from trusted gateways (those in the devices gateway list). We disable this as gateways can be compromised too.
* net.ipv4.conf.all.log_martians = 1
  * Default of 0
  * All means apply to all interfaces
    * We also change the default -- not noted here
  * When enabled the system will log packets with impossible addresses.
* net.ipv4.icmp_echo_ignore_broadcasts = 1
  * Default 1
  * All means apply to all interfaces
    * We also change the default -- not noted here
  * When enabled the system will ignore ICMP Echo broadcasts.
* net.ipv4.icmp_ignore_bogus_error_responses = 1 
  * Default of 1
  * All means apply to all interfaces
    * We also change the default -- not noted here
  * When this is enabled the kernel will not log bogus error responses 
* net.ipv4.conf.all.rp_filter = 1 
  * Default of 0
  * All means apply to all interfaces
    * We also change the default -- not noted here
  * This enables source validation of packets
* net.ipv4.tcp_syncookies = 1 
  * Default of 1
  * All means apply to all interfaces
    * We also change the default -- not noted here
  * This enables the fallback method of sending out syncookies when the syn backlog queue of a socket overflows. Protects against SYN Flood attacks.
* net.ipv6.conf.all.accept_ra 
  * Default ? 
  * All means apply to all interfaces
    * We also change the default -- not noted here
  * We do not accept router advertisements over IPv6.
## How we can test it and apply changes.
We cannot really test it other then checking if the values we have written to the config, or to  files have been applied. 

This would be done by looking at all of the tunable or just some of them. (see commands at the start!)

## Ref
* https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/kernel_administration_guide/working_with_sysctl_and_kernel_tunables
* https://sysctl-explorer.net/net/ipv4/icmp_echo_ignore_broadcasts/
* https://sysctl-explorer.net/net/ipv4/icmp_ignore_bogus_error_responses/
* https://sysctl-explorer.net/net/ipv4/tcp_syncookies/
* https://sysctl-explorer.net/net/ipv6/accept_ra/
* https://www.ibm.com/support/pages/what-icmp-redirect-message#:~:text=An%20ICMP%20redirect%20message%20is,traffic%20to%20a%20specific%20system.
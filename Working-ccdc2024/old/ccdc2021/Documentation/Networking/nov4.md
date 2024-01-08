# Networking Notes (From Monday 11/4 Practice) 

## Objective
* Given the following equipment:
  * router
  * switch
  * wireless access point
  * computer
* Run the following services:
  * Dynamic Host Configuration Protocol (DHCP)
  * Network Address Translation (NAT)
    * port forwarding
  * Domain Name System (DNS)

## End Product
* N/A

## Security Analysis
* N/A

## Testing
* N/A

## Documentation

  
  * interface management network FastEthernet 0/0
    * use 100 base-TX: `yes`
    * full duplex: `no`
    * ip: `192.168.100.1`
    * subnet: `255.255.255.0`

* Set up:
  * Connect the router to the computer (via a rollover cable) and to a power source (via a power cable).
  * Turn on the router (via the router's power button).
* Access the router's terminal emulator:
  * Find out what the model name of the router is (via visual inspection of the router).
    * It's a Cisco 2811.
  * Access the router's manual via a Google search of the router's model name.
    * It's [here](https://csrc.nist.gov/csrc/media/projects/cryptographic-module-validation-program/documents/security-policies/140sp612.pdf).
  * Open PuTTY.
  * For 'Connection type', select 'Serial'.
  * Find out what the arguments required for terminal emulator access are (via a search for "serial" within the manual).
    *
  * Enter these arguments into PuTTY.
  * If it didn't work:
    * There could've been problem(s) with the cable:
      * Make sure you are plugging the cable into the correct:
      	* device: the router, not the switch.
	* router port: the 'CONSOLE' port.
      * Try using a different cable.
    * Make sure the router is showing up in Device Manager. (Looking for COMM ports-- ensure that COMM1 is in device manager)
* Configure the router:
  * Press 'Enter' if the terminal emulator does not display any text.
  * Enter 'enable'. This enables a different set of commands.
  * Follow the instructions within the terminal emulator to begin base management setup.
  * Look up instructions for basic router configuration via Google. [Link](https://community.cisco.com/t5/routing/basic-cisco-2811-configuration/td-p/1419825)
  * Current Configuration for Cisco 2811 (configured on 31 Oct)
    * Hostname: `router`
    * Enable secret: `enable`
    * Enable password: `enablepwd`
    * Virtual terminal password: `virtual`
    * Community string: `[public]`
    * SNMP enabled: `[disabled]`
    * Follow those instructions.
    * We were able to set an IP address.
  * Good to know:
    * Typing "help" will display a list of valid commands.
    * Some commands require that the command "enable" be entered first.
    * This router has two ports, so this router can have two IP addresses. The ports are labeled 'FE0/1' (FastEthernet0/1) and 'FE0/0' (FastEthernet0/0).
    
## Script
* N/A

## ToDo
* All points from the "Objective" section

## References
* N/A

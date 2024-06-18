# Snort Demo

## Objective

To install and configure snort to run in Network Intrusion Detection System Mode
(NIDS mode).

## End Product
To have a system that automatically logs all packets that match the community
ruleset with alerts.

## Security Analysis


## Testing

Scripted:
- F

Active:
- Verify network configuration:
	1. On another machine, ping your current machine: `ping -c 4 <your ip here>`
	1. Check that snort is producing alerts, they should look like:

	```
	11/21-15:59:35.222595  [**] [1:366:7] ICMP PING *NIX [**] [Classification: Misc activity] [Priority: 3] {ICMP} 10.209.82.93 -> 10.209.82.29
	...
	```

## Documentation

1. To use the default setup with community rules, take note of your
network interface's name by running `route -n` and looking at the `Use Iface`
column.
1. Install snort by running 

	```bash
	sudo apt install snort
	```

	- During the install, the setup script should prompt you for your
	  interface name. Enter the name from the first step and hit enter.
	  (Note: if you aren't prompted here, see
	  [manual interface setup](#Manual-Interface-Setup)

1. By default, community rules are also installed, and you can run snort in
NIDS mode by using 

	```bash
	sudo snort -c /etc/snort/snort.conf -A console -k none
	```

1. Add your user-defined rule in `/etc/snort/rules/local.rules`, and add
your [user/subscriber rules](#User-and-Subscriber-Rules) to 
`/etc/snort/rules/` as well

### User and Subscriber Rules

In order to get the registered user rules, you must create an
account at the [snort sign up page](https://www.snort.org/users/sign_up).
Once in you can grab a registered user ruleset.

In Ubuntu, you can install snort using apt. Once installed, extract your 
ruleset tar.xz file, and copy the contents of `rules/*` into `/etc/snort/rules/`

```bash
tar xvf snortrules-snapshot-3000.tar.gz
sudo mv rules/* /etc/snort/rules/
```

In order to start

```bash
sudo snort -c /etc/snort/snort.conf -A console -k none
```

### Manual Interface Setup
Debian-specific configuration is located in:

```bash
/etc/snort/snort.debian.conf
```

Edit this file and change `DEBIAN_SNORT_INTERFACE` to be your network interfaces
name.

## Script with Comments

## Todo

- ~~[x] Verification of detection!!!!!~~
- ~~[x] Basic manual rule triggering tests~~
* [ ] PulledPork script configuration (may not be necessary for the competition,
	but useful overall)
* [ ] Scripted setup.
* [ ] Daemonize with notifications?

## References
[Snort Manual](https://www.snort.org/documents/snort-users-manual) \
[Snort Ubuntu Setup Guide](https://snort.org/documents/snort-3-on-ubuntu-18-19) \

```
   ,,_   
  o"  )~ 
   '''' 
```

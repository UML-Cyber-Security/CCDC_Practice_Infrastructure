# Lab Setup

## Windows 10 Router host setup

1. Connect the USB to Ethernet cable to the Windows 10 router host
2. Connect the new interface to the switch via RJ45
3. Verify the public and private interface on the Windows 10 router host are using DHCP
   - On Windows 10 search for `Network` and navigated to `Change adapter options`
   - Identify the `USB 3.0 to Gigabit Ethernet Adapter` (safe zone / private), likely named `Ethernet3`
   - Right click and select `Properties`
   - Select `Internet Protocol Version 4 (TCP/IPv4)`
   - Select `Properties`
   - Toggle on `Obtain an IP address automatically` and `Obtain DNS server address automatically`
   - Identify the public interface, likely a `Intel(R) Ethernet Connection (7) I219-LM` (unsafe zone / public) named `Ethernet2`
   - Repeated the above steps to toggle on `Obtain an IP address automatically` and `Obtain DNS server address automatically`

## VyOS 1.1.8 installation in Virtual Box

- Ensure VMs are saved on the `D drive`
  - In the top left, select `File` > `Preferences`
  - Ensure the `Default Machine Folder` is located on the `D:`
  - If it's not, make a new folder on `D:` and change the `Default Machine Folder` to the new location
- Create the VyOS VM
  - Select `New`
  - Name the VM `VyOS 1.1.8` or something similar
  - Change the `Type` to `Linux`
  - Change the `Version`to `Debian (64-bit)`
  - Select `Next`
  - To the right of slider, change `1024` `MB` to `256` `MB`
  - Select `Next`
  - Do not change the `Hard disk` settings and select `Create`
  - Do not change the `Hard disk file type` and select `Next`
  - Do not change the `Storage on physical hard disk` and select `Next`
  - Do not change the `File location and size` and select `Create`
- Insert the VyOS 1.1.8 ISO into the new VM
  - Select the `VyOS 1.1.8` VM
  - Select `Settings`
  - Select `Storage`
  - Under `Controller: IDE`, select `Empty`
  - On the right menu, under `Attributes`, within the `Optical Drive:` dropdown, select `IDE Primary Master`
  - Select the blue disk to the right of the dropdown
  - Select `Choose a disk file`
  - Navigate to and select the `vyos-1.1.8-amd64` ISO
  - Select `OK`
- Configure the VM networking adapters
  - Select the `VyOS 1.1.8` VM
  - Select `Settings`
  - Select `Network`
  - Select the `Adapter 1` tab
     - Within the `Attached to:` dropdown, select `Bridged Adapter`
     - Ensure the `Name:` field contains name of the public adapter on the host machine, likely `Intel(R) Ethernet Connection (7) I219-LM`
   - Select `Advanced`
     - Ensure `Cable Connected` is toggled on
  - Select the `Adapter 2`
   - Select `Enable Network Adapter`
   - Repeat the above steps, but ensure the `Name: ` field contains the name of the private adapter, likely `USB 3.0 to Gigabit Ethernet Adapter`
  - Select `OK`
- Install `VyOS 1.1.8` on the VM
  - Select `VyOS 1.1.8` VM
  - Select `Start`
  - At the prompt, select `Cancel` 
  - Press `Enter` (If your mouse is captured in the VM, press the `Right-Ctrl`)
  - Login with `vyos`:`vyos`
  - Run `install image`
  - At the prompt, press `Enter` for `Yes`
  - At the prompt, press `Enter` for `Auto`
  - At the prompt, press `Enter` for `sda`
  - At the prompt, type `yes`, press `Enter`
  - At the prompt, press `Enter`, for `8589 MB`
  - At the prompt, press `Enter`, for `1.1.8`
  - At the prompt, press `Enter`, for `/config/config.boot`
  - At the prompt, type a secure password, press `Enter`
  - At the prompt, re-type the secure password, press `Enter`
  - At the prompt, press `Enter`, for `sda`
  - Ensure `Done!` was output to screen before continuing
  - Select `File` > `Close` > `OK` from the top menu
- Remove disk from virtual drive
  - Select `VyOS 1.1.8`
  - Select `Settings`
  - Select `Storage`
  - Select `vyos-1.1.8-amd64.iso`
  - Select the blue disk to the right of the dropdown
  - Select `Remove Disk from Virtual Drive`
  - Select `OK`
  
## VyOS 1.1.8 configuration

- Ensure host interfaces for public/private networks match guest VM public/private interfaces `VyOS 1.1.8` VM
  - Login to the VM
    - Select `VyOS 1.1.8` VM
    - Select `Start`
    - Wait for auto boot or press `Enter`
    - Login with to the user `vyos` your secure password
  - Run `show interfaces` and confirm both are marked with `u/u`
  - Run `ip a` and note the `MAC address` of the `eth0` `link/ether` 
  - Open up the VM adapter settings's `Network` tab again and confirm that the `MAC address` is the same as the public interface under the `Adapter 1` tab's `Advanced` section, likely named `Intel(R) Ethernet Connection (7) I219-LM`
    - Note: We assume, moving forward, that `eth0` is the public interface, if it is not, space `eth0` and `eth1` in the rest of the guide
  - Run `conf` (short hand for `configure`)
  - Run `set interfaces ethernet eth0 description public`
    - Note: Tab complete all commands in VyOS to ensure syntax correctness
  - Run `set interfaces ethernet eth1 description private`   
  - Run `commit`
 - Configure public interface   
  - Run `set interfaces ethernet eth0 address 192.168.7.210/24`
  - Run `set service dns forwarding listen-on 127.0.0.1`
  - Run `set service dns forwarding name-server 8.8.8.8`
  - Run `set protocols static route 0.0.0.0/0 next-hop 192.168.7.254`
  - Run `commit`
  - Run `ping google.com` and confirm success
- Configure private interface
  - Run `set interfaces ethernet eth1 address 10.0.0.1/24` 
  - Run `commit`
 
## Enable services

- Enable DHCP on the 10.0.0.0/24 network
  - Run `set service dhcp-server shared-network-name lab authoritative enable`
  - Run `set service dhcp-server shared-network-name lab subnet 10.0.0.0/24 start 10.0.0.10 stop 10.0.0.100`
  - Run `set service dhcp-server shared-network-name lab subnet 10.0.0.0/24 default-router 10.0.0.1`
  - Run `set service dhcp-server shared-network-name lab subnet 10.0.0.0/24 dns-server 8.8.8.8`
  - Run `commit`
  - Confirm that a computer on the `10.0.0.0/24` network received an IP address via `DHCP`
- Enable NAT
  - Run `set nat source rule 100 outbound-interface eth0`
  - Run `set nat source rule 100 source address 10.0.0.0/24`
  - Run `set nat source rule 100 translation address masquerade`
  - Run `commit`
  - Confirm that a computer on the `10.0.0.0/24` network can `ping` `google.com`
- Forward required services
  - SSH
    - Run `set nat destination rule 20`
    - Run `set nat destination rule 20 description ssh`
    - Run `set nat destination rule 20 inbound-interface eth0`
    - Run `set nat destination rule 20 protocol tcp`
    - Run `set nat destination rule 20 destination address 192.168.7.211`
    - Run `set nat destination rule 20 destination port 22`
    - Run `set nat destination rule 20 translation address 10.0.0.19`
    - Run `set nat destination rule 20 translation port 22`
    - Run `commit`
  - HTTP
    - Run `set interfaces ethernet eth0 address 192.168.7.212/24`
    - Run `set nat destination rule 21`
    - Run `set nat destination rule 21 description 'http'`
    - Run `set nat destination rule 21 inbound-interface eth0`
    - Run `set nat destination rule 21 protocol tcp`
    - Run `set nat destination rule 21 destination address 192.168.7.212`
    - Run `set nat destination rule 21 destination port 80`
    - Run `set nat destination rule 21 translation address 10.0.0.14`
    - Run `set nat destination rule 21 translation port 80`
    - Run `commit`

## Establish VPN (untested notes)

  - PKI setup
    - Move RSA scripts
      - 1.1.8
        - Run `cp -rv /usr/share/doc/openvpn/examples/easy-rsa/2.0/ /config/my-easy-rsa-config`
      - 1.2.x / 1.3.x
        - Run `cp -r /usr/share/easy-rsa/ /config/my-easy-rsa-config`
    - Run `cd /config/my-easy-rsa-config`
    - Run `nano vars`
      ```
      export KEY_COUNTRY="US"
      export KEY_PROVINCE="MA"
      export KEY_CITY="Lowell"
      export KEY_ORG="UML-CCDC"
      export KEY_EMAIL="admin@umlccdc.com"
      export KEY_EMAIL=admin@umlccdc.com
      export KEY_CN=umlccdc
      export KEY_NAME=vyos
      export KEY_OU=net
      export PKCS11_MODULE_PATH=changeme
      export PKCS11_PIN=1234
      ```
    - Run `source ./vars`
    - Run `./clean-all`
    - Run `./build-ca`
    - Run `./build-dh`
    - Run `./build-key-server central`
    - Run `./build-key branch1`
    - Run `./build-key branch2`
    - Run `sudo mkdir /config/auth/ovpn`
    - Run `sudo cp keys/ca.crt /config/auth/ovpn`
    - Run `sudo cp keys/dh2048.pem /config/auth/ovpn`
    - Run `sudo cp keys/central.key /config/auth/ovpn`
    - Run `sudo cp keys/central.crt /config/auth/ovpn`
  - Enable VPN
    - Run `set interfaces openvpn vtun10 mode server`
    - Run `set interfaces openvpn vtun10 local-port 1194`
    - Run `set interfaces openvpn vtun10 persistent-tunnel`
    - Run `set interfaces openvpn vtun10 protocol udp`
    - Run `set interfaces openvpn vtun10 server push-route 10.0.0.0/24`
    - Run `set interfaces openvpn vtun10 server subnet 192.168.7.0/24`
  - Configure clients on the VPN 
    - Note: clients are identified by the CN in their x.509 certificate
      - Example client is client0
      - Current LAN config has DHCP for 10.0.0.10 - 10.0.0.100
      - VPN IPs are going to be 10.0.0.110 - 10.0.0.120
    - Run `set interfaces openvpn vtun10 server client client0 ip 10.0.0.110`
    - Run `set interfaces openvpn vtun10 server client client0 subnet 192.168.7.0/24`
    - Run `set protocols static interface-route 10.0.0.0/24 next-hop-interface vtun10`
- Set up flow-accounting
  - Run `set system flow-accounting interface eth0`
  - Run `set system flow-accounting interface eth0`
  - Run `set system flow-accounting interface eth1`
  - Run `set system flow-accounting interface eth1`
  - Run `commit`
- Save changes to persist between boot
- Save changes to persist between boot
  - Run `save`
  - Run `save`
- Set up SSH on the gateway
  - Run `set service ssh port 22`
  - Run `commit`
- Set up flow-accounting
  - Run `set system flow-accounting interface eth0`
  - Run `set system flow-accounting interface eth1`
  - Run `commit`
- Save changes to persist between boot
  - Run `save`
  
## VyOS Lab Script (Static Public & Private IP, Private DHCP server, NAT, and SSH)
```
#!/bin/vbash
source /opt/vyatta/etc/functions/script-template
configure
set interfaces ethernet eth0 description public
set interfaces ethernet eth1 description private`  
set interfaces ethernet eth0 address 192.168.7.210
set service dns forwarding listen-address 127.0.0.1
set service dns forwarding name-server 8.8.8.8
set protocols static route 0.0.0.0/0 next-hop 192.168.7.254
set interfaces ethernet eth1 address 10.0.0.1/24
set service dhcp-server shared-network-name lab authoritative enable
set service dhcp-server shared-network-name lab subnet 10.0.0.0/24 start 10.0.0.10 stop 10.0.0.100
set service dhcp-server shared-network-name lab subnet 10.0.0.0/24 default-router 10.0.0.1
set service dhcp-server shared-network-name lab subnet 10.0.0.0/24 dns-server 8.8.8.8
set nat source rule 100 outbound-interface eth0
set nat source rule 100 source address 10.0.0.0/24
set nat source rule 100 translation address masquerade
set nat destination rule 20
set nat destination rule 20 description ssh
set nat destination rule 20 inbound-interface eth0
set nat destination rule 20 protocol tcp
set nat destination rule 20 destination address 192.168.7.211
set nat destination rule 20 destination port 22
set nat destination rule 20 translation address 10.0.0.19
set nat destination rule 20 translation port 22
set service ssh port 22
commit
exit
```

## VyOS Lab Outdated config

```
vyos@vyos# show
 interfaces {
     ethernet eth0 {
         address 192.168.7.210/24
         address 192.168.7.211/24
         description public
         duplex auto
         hw-id 08:00:27:14:ed:3e
         speed auto
     }
     ethernet eth1 {
         address 10.0.0.1/24
         description private
         duplex auto
         hw-id 08:00:27:28:fc:a2
         speed auto
     }
 }
 nat {
     destination {
         rule 20 {
             description ssh
             destination {
                 address 192.168.7.211
                 port 22
             }
             inbound-interface eth0
             protocol tcp
             translation {
                 address 10.0.0.19
                 port 22
             }
         }
     }
     source {
         rule 100 {
             outbound-interface eth0
             source {
                 address 10.0.0.0/24
             }
             translation {
                 address masquerade
             }
         }
     }
 }
 protocols {
     static {
         route 0.0.0.0/0 {
             next-hop 192.168.7.254 {
             }
         }
     }
 }
 service {
     dhcp-server {
         shared-network-name lab {
             subnet 10.0.0.0/24 {
                 default-router 10.0.0.1
                 dns-server 8.8.8.8
                 lease 86400
                 range 0 {
                     start 10.0.0.10
                     stop 10.0.0.100
                 }
             }
         }
     }
     dns {
         forwarding {
             allow-from 0.0.0.0/0
             allow-from ::/0
             cache-size 150
             listen-address 127.0.0.1
             name-server 8.8.8.8
         }
     }
     ssh {
         listen-address 10.0.0.1
         port 22
     }
 }
 system {
     config-management {
         commit-revisions 20
     }
     console {
         device ttyS0 {
             speed 9600
         }
     }
     flow-accounting {
         interface eth0
         interface eth1
     }
     host-name vyos
     login {
         user vyos {
             authentication {
                 encrypted-password $6$QCVs6Nijf48okYD$PC5VzqipYskSmOcB.j4P9qJ7NhHLPrWx9IIvPHt5I8HxNf4.V6uOxCZhDmxJ.q.L9lHHrXfzV78aTVYc7DWjZ0
                 plaintext-password ""
             }
             level admin
         }
     }
     ntp {
     }
     time-zone UTC
 }
```

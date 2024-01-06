# Cisco2811

## Security Items

- Implement access control lists [documentation](https://www.cisco.com/c/en/us/support/docs/security/ios-firewall/23602-confaccesslists.html)
  - How access control lists work
    - Lists are read top to bottom, starting at access list 1
    - The first rule that matches the traffic is used
    - There's an implict `deny ip any any` at the end
      - Even though we can specify protocols like `deny icmp any any`, `ip` will still deny everything, as all traffic being routed has an ip address
    - Traffic can be controlled by "inbound" and "outbound" rules, which determine whether or not a list is applied to traffic that is comming into the router or leaving it
    - Standard ACLs apply rules based on the IP address in the packet
    - Extended ACLs apply rules based on source and destination IP
    - Reflexive ACLs apply rules based on upper-layer sessions, usually used to allow outbound traffic but limit inbound traffic
      - Example: Allow ICMP inbound if it originated from outbound traffic
  - Useful commands:
    - `show access-list`, view current access control lists
    - `no access-list [...]` (where `[...]` is the rest of the rule for the list), remove an access control list 
  - As access control lists are evaluated from top to bottom, we want anything we was to permit at the top and anything we want to deny at the bottom

- Password protect terminal access [documentation](https://www.cisco.com/c/en/us/td/docs/routers/access/1800/1801/software/configuration/guide/scg/routconf.html)
  - There are four ways to access the terminal (implied by documentation) `aux`, `console`, `tty`, `vty`
    - Each one should have a password set
    - Each one should be configured to enforce login
  - Useful commands:
    - `line [aux | console | tty | vty] [line-number]`, where `[aux...vty] is the specific line and `[line_number]` is the line identifier 
    - After executing `line...`, execute `password` to set the password
    - After executing `line...`, `password`, execute `login`

- Secure Shell (SSH) [documentation](https://www.cisco.com/c/en/us/td/docs/ios/sec_user_services/configuration/guide/12_4/sec_securing_user_services_12-4_book/sec_cfg_secure_shell.html)
  - Configuration steps:
    - enable
    - configure terminal
    - ip ssh {timeout seconds | authentication-retries integer}
  - Invokation steps:
    - enable
    - ssh -l username -vrf vrf-name ip-address

- AAA [documentation](https://www.cisco.com/c/en/us/td/docs/ios/sec_user_services/configuration/guide/12_4/sec_securing_user_services_12-4_book/sec_cfg_authentifcn.html)
  - AAA (Authentification, Authorization, and Accounting) is a protocol used to secure access to a Cisco network device.
    - Can be used to configure:
      - login authentification
      - PPP authentification
      - AAA scalability for PPP requests
      - ARAP authentification
      - NASI authentification
      - AAA packet of disconnect
      - the Dynamic Authorization Service for RADIUS CoA
      - the router to ignore Bounce and Disable RADIUS CoA requests
    - Can be used to enable:
      - password protection at the priveliged level
      - double authentication
      - automated double authentication
    - Can be used to prevent:
      - an access request with a blank username from being sent to the RADIUS server
    - Can be used to specify:
      - the amount of time for a login input
    - Can be used to change:
      - the text displayed at the password prompt
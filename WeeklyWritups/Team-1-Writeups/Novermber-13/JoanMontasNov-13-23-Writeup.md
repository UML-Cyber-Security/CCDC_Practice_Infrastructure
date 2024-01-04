# Write-up: RED Team (RDP - Persistent)

## Overview
Name: `Joan Montas`

### What We Worked On:
- Install Graphical Environemnt and RDP (Rocky and Ubuntu)
- Allow RDP via firewall
- In terminal based machine, disable the Graphical Environment upon startup
- Create script to maintain persistent:
    1) Create root priviledge user every so often
    2) Set wazuh password to the default password every so often
    3) Change the wazuh configuration client side
    4) Setup Command and Control server
    5) obfuscate processes

### Challenges Faced:
- Installing Graphical environment on some machine gave some error
- Trying to hide malicious processes

### Future Plans:
- create more persistent.
- Hide better, user created should not create home directory.
- Attack the wazuh API. Usually people change password, but never the API token.
- No only rely on hand-build tool but also off the shelf ones.
- Infected machine should send their reconnaissance (open ports, services running) to the CC
- Be more annoying, from time to time, let the machine administrator that I am there.
- Have a way to disable permissions to certain or all accounts automatically.

# IPTables
For the Linux machines this is the Firewall of choice. IPTables has been superseded by NFTables, but NFTables can still use the command syntax of IPTables (Which is what we do!)

## Dependencies
This service does not have any dependencies, it however other Firewall services must be disabled, and IPTables installed. Of course it is dependent on the Host Linux System.

## First 15
* Log current rules on system from the previous Firewall Solution (Firewalld, NFTables, IPTables, etc)
* Install IPTables packages
* Disable all other Firewall Solutions.
* Add Rule to allow SSH access
* Add Rule to allow Wazuh Agents to function
* Ensure ACCEPT Rules are catching
* Audit Network Connections (what is on the system making communications)
* Default Deny inbound Rule
* Add Rules to allow other inbound services.

## First 30
* Audit all Outbound Connections.
* Add rules to ensure known services can make outbound connections
* Ensure Those rules are working as expected
* Default Deny rule


## Stretch Goals
* Select machine to be an internal Gateway
* Configure IPTables for NAT forwarding and whatnot (Never done this before!)
* Configure internal machines to set Internal Gateway as the Default Gateway.
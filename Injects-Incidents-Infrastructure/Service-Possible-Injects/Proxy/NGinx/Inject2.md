# Nginx
HAProxy: Medium

**Time**: 1 HR

## Expectations 
1. A Public service such as Vault is migrated to the private subnet
2. The web interface is still accessible to external users.

## Dependencies
An instance of Vault must be setup and configured in the internal subnet, or the Firewall of Vault must be configured so no external machines may communicate with it (Psudo-Subnet)

## Inject
We do not like all our secrets being public... please make this not the case. 
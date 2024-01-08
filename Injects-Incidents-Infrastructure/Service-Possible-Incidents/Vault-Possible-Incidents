# Attacking a vault Server

# Possible Misconfigurations
1. vault as a root user
2. Write privileges for the Vault user
3. Lack of end to end encryption with TLS
4. Token Permissions
5. Swap is Enabled


## Do not run vault as a root user
### Impact
   - When an application is running as a root user, that application has the ability to take control of the entire machine/server.
   - If an attacker gains control of the service, then they can perform any task on that machine
    
### Mitigate
   - Create a Vault user to run and control the vault service only
   - Use a dedicated, unprivileged service account to run Vault, rather than running as the root or Administrator account. Vault is designed to be run by an unprivileged user, and doing so adds significant defense against various privilege-escalation attacks.
### Indicator of Compromise
   - Unauthorized change in Vault's user privileges to root
    

## Minimal write privileges for the Vault user
### Impact
   - Vault as a service should not able to rewrite it’s own executable or configuration files.
    Unprivileged user should be the one writing secrets/data to the vault.
### Mitigate
   - Create suitable user permissions - 
   - Take away write permission to the config file and executables
### Indicator of Compromise
   - Unusual or unauthorized file modifications, especially inthe config file & executables directories by the vault user.
    

## End to end encryption with TLS
### Impact
   - Without encryption the machine is susceptible to impersonation based attacks data tampering, and interception.
    
### Mitigation
   - Ensure all traffic is encrypted in transit to and from Vault
   - Using SSL certificates to setup TLS based communication
   - Enable the HTTP Strict Transport Security (HSTS) header using Vault’s custom response header.
### Indicator of Compromise
   - Monitoring network traffic and discovering sensitive data transmitted in plaintext. An analysis of network packets might reveal sensitive information without encryption.
   - Connections by unknown machines/IPs.
    

## Token Permissions
### Impact
   - Creating a root a persisting root token allows for a person to continuously have root permissions, in the event the root token somehow misused.
    
### Mitigation 
   - Revoke the root token after Vault initialization 
   - Generate the root token as needed & revoke immediately.
    
### Indicator of Compromise
   - Unexpected token usage or attempts to escalate privileges could indicate compromise.
   - Unknown generate root tokens
    

## **Disable Swap**
### Impact 
   - Vault encrypts data in transit and at rest, however it must still have sensitive data in memory to function. Unencrypted sensitive data in unwanted locations.
    
### Mitigation
   - Disable swap to prevent the operating system from paging sensitive data to disk
    
### Indicator of Compromise 
   - Logs showing unexpected disk writes or paging behavior.
   - Check Swap file for unencrypted sensitive data
   - Much more likely to occur when using integrated storage
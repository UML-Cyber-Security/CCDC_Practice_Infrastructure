# FreeIPA
FreeIPA is an identity management system that allows users to authenticate as a user before they try to gain access to materials that they are cleared to have access to. This is a critical portion of the infrastructure because without it there can be no login process.

## Possible Misconfigurations 

### IPA to AD Communication ###
    While communications between IPA and AD are base64 encoded, they are not encrypted. Intercepting communications between the 2 services could allow attacker to take part in offline brute force attacks on any password hashes sent between AD and IPA. This can be mitigated by not merging the 2 services or by encrypting the data.

Link: https://book.hacktricks.xyz/linux-hardening/freeipa-pentesting 

### Kerberos Ticket Replay Attack ###
    With the Kerberos Ticket held in its default location (in the /tmp directory) it can be easily copied for a replay attack. This can be mostly mitgated by mkaing use of the linux keyring which stores it at the kernel level.

Link: https://book.hacktricks.xyz/linux-hardening/freeipa-pentesting 

### Anonymous Binds ###
    As a default value there are queries that can be made on FreeIPA without any authentification which can reveal sensitive information like usernames and number of users. This is a configurations that can be turned off and shoulb be.

Link: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/linux_domain_identity_authentication_and_policy_guide/disabling-anon-binds  

## Impact

### IPA to AD Communication & Kerberos Ticket Replay Attack ###
    Both of these attacks give an attacker access to a specific account in a way that seems valid to any outside observers. The severity of this attack depends on the access of the account that they gain access to. For example, a breach in a user is not at severe as an access to an administrative account.

### Anonymous Binds ###
    The severity of this attack is much smaller because no access is given to the attacker, it is more of a means of recon and information gathering by them on our system.

## Indicators of Compromise

### IPA to AD Communication ###
    This is unlikely to be done in CCDC as it would take considerable time, but if it were to happen it would only be shown as a correct login to a user because the attacker would have the correct password.

### Kerberos Ticket Replay Attack ###
    This attack could leave behind a trace in the history of file access, but other than that it would all seem like valid actions because the tiket used by the attacker is valid.

### Anonymous Binds ###
    This attack could be revealed in a command history where a lot of information is queried by a user in a short amount of time, specifically from an unauthorized user.
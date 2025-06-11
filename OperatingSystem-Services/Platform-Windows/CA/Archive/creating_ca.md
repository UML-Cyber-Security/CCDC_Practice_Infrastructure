# Creating CA

1. Join the machine to your domain
2. Download the CA from Server Manager. AD CS
3. Select all options when installing the CA. The web portal & extra features are useful.
4. On the domain controller, add a user to the `Cert Publishers` group in AD Users and Computers
5. Log into the CA with this user, so they have the necessary permissions.

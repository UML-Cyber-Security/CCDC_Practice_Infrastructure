# What is it
##### Written by a sad Matthew Harper

This is the Pluggable Authentication Module. We can use it to configure the authentication process when logging into linux.
# What we do
Require a minimum length password.

We have a part of the script that will increase the required complexity to use 4 classes of charicters **upper, lower, number, special, ect** This is **Commented out** to ensure it will not conflict with the password script.

Limit the user to 3 tries.

Lock out the user for a specific amount of time (or indefinitely) after a number of failed log in attempts.

Deny access 

Remember a defined number of previous passwords the user has used, and reject new passwords that attempt to reuse the old ones.


# What is possible
https://documentation.suse.com/sles/12-SP5/html/SLES-all/cha-pam.html

Quite alot Including MFA
(We can exclude groups from the MFA so Black Team will be safe)

# Why we do not want to break it
IF this does not work, we cannot authenticate or create new ssh sessions, as PAM is evaluated before access is given.

# Procedure 
Create three SSH sessions (at least 2), where two of the sessions will **sudo su** into root. This is so they can edit the PAM Files and possibly run scripts.    

When debugging I used the method of make a change and try to sudo something. If the sudo worked then I was fine. If it did not I would revert the change and see what went wrong.

sudo -k would reset the sudo timer which was good.

# Imporvements
* https://deer-run.com/users/hal/linux_passwords_pam.html

# Resources
* https://www.redhat.com/sysadmin/linux-security-pam
* https://linuxhint.com/linux_pam_tutorial/
* https://linux.die.net/man/8/pam_pwquality
* https://linux.die.net/man/8/pam_faillock
* https://linux.die.net/man/8/pam_deny
* https://linux.die.net/man/8/pam_unix
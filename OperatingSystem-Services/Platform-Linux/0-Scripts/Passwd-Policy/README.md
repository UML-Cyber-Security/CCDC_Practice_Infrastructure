# Password-Policy Scripts
Password Policy Scripts for Linux Systems.

## Passwd-Pol
This script sets a basic, common sense password policy on local Linux systems through PAM.
* Minlength is set to 12 characters.
* One upper case is required.
* One Digit is required.
* One Other Special Character is required.

This script is ran with no arguments as a sudo user. You should have a **Root Shell** open or something that allows you to perform super user actions without a password as you *may* break pam depending on how they configured it. Once done you should test password authentication and SSH access.
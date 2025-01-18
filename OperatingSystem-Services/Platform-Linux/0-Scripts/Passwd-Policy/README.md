# Password-Policy Scripts
Password Policy Scripts for Linux Systems.

## Passwd-Pol
This script sets a basic, common sense password policy on local Linux systems through PAM.
* Minlength is set to 12 characters.
* One upper case is required.
* One Digit is required.
* One Other Special Character is required.

This script is ran with no arguments as a sudo user. You should have a **Root Shell** open or something that allows you to perform super user actions without a password as you *may* break pam depending on how they configured it. Once done you should test password authentication and SSH access.

> [!NOTE]
> When you corrupt one of the PAM files used when authenticating a user, you will no longer be able to login to the system, do `sudo` commands or change the user's password. When performing an action that requires a PAM module you will get a "Token Manipulation Error" message. This means you messed PAM up!

The `/etc/pam.d/common-password` file will have the following line inserted into it, this could overwrite existing configuration or it may be appended to the end:
```
password        requisite                       pam_pwquality.so retry=3 minlen=12 dcredit=-1 ucredit=-1 ocredit=-1
```

If you have a `/etc/security/pwquality.conf` it will have the following lines inserted, either replacing existing lines or appended at the end.
```
# Minimum acceptable size for the new password (plus one if
# credits are not disabled which is the default). (See pam_cracklib manual.)
# Cannot be set to lower value than 6.
minlen=12
#
# The maximum credit for having digits in the new password. If less than 0
# it is the minimum number of digits in the new password.
dcredit=-1
#
# The maximum credit for having uppercase characters in the new password.
# If less than 0 it is the minimum number of uppercase characters in the new
# password.
ucredit=-1
#
# The maximum credit for having lowercase characters in the new password.
# If less than 0 it is the minimum number of lowercase characters in the new
# password.
# lcredit = 0
#
# The maximum credit for having other characters in the new password.
# If less than 0 it is the minimum number of other characters in the new
# password.
ocredit=-1
```

You can modify the script to add additional configurations to the script by adding them to the `configs` dictionary/map. If we wanted to add a `usercheck` configuration we would add it in the following way.

```
configs=(
    ["retry"]="3"
    ["usercheck"]="3"
    ["minlen"]="12"
    ["dcredit"]="-1"
    ["ucredit"]="-1"
    ["ocredit"]="-1"
)
```
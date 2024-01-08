#!/bin/bash

#********************************
# Written by someone.
#********************************

if [ $EUID -ne 0 ]; then
    echo "Run me as a superuser"
    exit 1
fi

# If Debian
# If there exists this file, it is a debian based system. Use APT
if [ -f "/etc/debian_version" ]; then
    apt-get install libpam-pwquality -y
elif [ -f "/etc/redhat-release" ]; then
    yum install pam -y
elif [ -f "/etc/arch-release" ]; then
    echo "Arch, Will this come up -- probably should do fedora"
fi

cp -r /etc/pam.d /backups/configs

# Seth the minimum length of a password to 14 charicters 
if [ "$(grep 'minlen' /etc/security/pwquality.conf | wc -l)" -eq 0 ]; then
    echo "minlen = 14" >> /etc/security/pwquality.conf
else
    sed -i "s/.*minlen.*/minlen = 9/g" /etc/security/pwquality.conf
fi

# Comment out as this will cause issues with random char passwds
# # OR dcredit = -1 ucredit = -1 ocredit = -1 lcredit = -1 
# if [ "$(grep 'minclass' /etc/security/pwquality.conf | wc -l)" -eq 0 ]; then
#     echo "minclass = 4" >> /etc/security/pwquality.conf
# else
#     sed -i "s/.*minclass.*/minclass = 4/g" /etc/security/pwquality.conf
# fi

# User SHA512 Hash insted of defualt MD5
# Need to reset all prexisting passwords (RUN PASSWD CHANGE AFTER THIS 
if [ "$(grep 'password [success=1 default=ignore] pam_unix.so obscure sha512 rounds=10000 minlen=8' /etc/pam.d/common-password | wc -l)" -eq 0 ]; then
    echo "password [success=1 default=ignore] pam_unix.so obscure sha512 rounds=10000 minlen=8" >> /etc/pam.d/common-password
else
    sed  -i "s/.*password\s*[success=1 default=ignore]\s*pam_unix.so.*/password [success=1 default=ignore] pam_unix.so obscure sha512 rounds=10000 minlen=8/g" /etc/pam.d/common-password
fi


# Limits the user to 3 tries 
if [ "$(grep 'password requisite pam_pwquality.so' /etc/pam.d/common-password | wc -l)" -eq 0 ]; then
    echo "password requisite pam_pwquality.so retry 3" >> /etc/pam.d/common-password
else
    sed -i "s/password requisite pam_pwquality.so.*/password requisite pam_pwquality.so retry 3/g" /etc/pam.d/common-password
fi

# Locks out the user after a number of failed attempts 
if [ "$(grep 'auth required pam_faillock.so' /etc/pam.d/common-auth | wc -l)" -eq 0 ]; then
    echo "auth required pam_faillock.so preauth silent audit deny=3 unlock_time=900" >> /etc/pam.d/common-auth
else
    sed  -i "s/.*auth required pam_faillock.so.*/auth required pam_faillock.so preauth silent audit deny=3 unlock_time=900/g" /etc/pam.d/common-auth
fi
 
 # Deny access 
if [ "$(grep 'account\s*requisite\s*pam_deny.so' /etc/pam.d/common-account | wc -l)" -eq 0 ]; then
    echo "account     requisite    pam_deny.so" >> /etc/pam.d/common-account
else
    sed  -i "s/.*account\s*requisite\s*pam_deny.so.*/account     requisite    pam_deny.so/g" /etc/pam.d/common-account
fi


# Lock user accounts after certain number of failed ssh login attempts
# https://www.tecmint.com/use-pam_tally2-to-lock-and-unlock-ssh-failed-login-attempts/
if [ "$(grep 'account\s*required\s*pam_faillock' /etc/pam.d/common-account | wc -l)" -eq 0 ]; then
    echo "account     required    pam_faillock.so" >> /etc/pam.d/common-account
else
    sed  -i "s/.*account\s*required\s*pam_faillock.*/account     required    pam_faillock.so/g" /etc/pam.d/common-account
fi

# Remember the previous 5 passwords (prevents reuse) 
if [ "$(grep 'password\s*required\s*pam_pwhistory.so' /etc/pam.d/common-password | wc -l)" -eq 0 ]; then
    echo "password required pam_pwhistory.so remember=5" >> /etc/pam.d/common-password
else
    sed  -i "s/.*password\s*required\s*pam_pwhistory.so.*/password required pam_pwhistory.so remember=5/g" /etc/pam.d/common-password
fi


#Set the PASS_MIN_DAYS parameter to 1 in /etc/login.defs : PASS_MIN_DAYS 1 Modify user parameters for all users with a password set to match: # chage --mindays 1 <user>
#Set the PASS_MAX_DAYS parameter to conform to site policy in /etc/login.defs : PASS_MAX_DAYS 365 Modify user parameters for all users with a password set to match: # chage --maxdays 365 <user>
#Set the PASS_WARN_AGE parameter to 7 in /etc/login.defs: PASS_WARN_AGE 7. Modify user parameters for all users with a password set to match: # chage --warndays 7 <user>. Notes: You can also check this setting in /etc/shadow directly. The 6th field should be 7 or more for all users with a password.
#Run the following command to set the default password inactivity period to 30 days: # useradd -D -f 30. Modify user parameters for all users with a password set to match: # chage --inactive 30 <user>. Notes: You can also check this setting in /etc/shadow directly. The 7th field should be 30 or less for all users with a password. A value of -1 would disable this setting.

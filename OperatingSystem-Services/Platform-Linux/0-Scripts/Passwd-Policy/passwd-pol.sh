#!/bin/bash

#********************************
# Written by a sad Matthew Harper
#********************************
if [ $EUID -ne 0 ]; then
    echo "Run me as a superuser"
    exit 1
fi

PWFILE="/etc/security/pwquality.conf"
PAMFILE="/etc/pam.d/common-password"

declare -A configs
configs=(
    ["minlen"]="12"
    ["dcredit"]="-1"
    ["ucredit"]="-1"
    ["ocredit"]="-1"
)

if [ -f $PWFILE ]; then
    for item in "${!configs[@]}"; do

        if grep -q "^.*$item.*$" $PWFILE; then
            sed -i "s/^.*$item.*$/$item=${configs[$item]}/" $PWFILE
        else
            echo "$item=${configs[$item]}" | tee -a $PWFILE
        fi
    done
else
    if [ -x "$(command -v yum)" ]; then
        yum install -y pam
    elif [ -x "$(command -v apt)" ]; then
        apt update && sudo apt install -y libpam-pwquality
    fi

    if grep -q "/pam_pwquality\.so/ s/$/" $PAMFILE; then
        sed -i "/pam_pwquality\.so/ s/pam_pwquality\.so.*/pam_pwquality.so retry=3 minlen=${configs[minlen]} dcredit=${configs[dcredit]} ucredit=${configs[ucredit]} ocredit=${configs[ocredit]}/" $PAMFILE
    else
        echo "password required pam_pwquality.so retry=3 minlen=${configs[minlen]} dcredit=${configs[dcredit]} ucredit=${configs[ucredit]} ocredit=${configs[ocredit]}/" >> $PAMFILE
    fi
fi
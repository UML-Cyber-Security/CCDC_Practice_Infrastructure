#!/bin/bash

# set a 15 ssh minute idle timeout
sed -i -e 's/#\?ClientAliveInterval.*/ClientAliveInterval 900/' /etc/ssh/sshd_config

# disable at
systemctl disable atd.service

# disable empty password login

sed --follow-symlinks -i 's/\<nullok\>//g' /etc/pam.d/system-auth
sed --follow-symlinks -i 's/\<nullok\>//g' /etc/pam.d/password-auth
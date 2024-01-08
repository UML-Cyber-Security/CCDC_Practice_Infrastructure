#!/bin/bash
sudo pacman -Syu openssh python  #change this 
sudo rm /etc/ssh/sshd_config
sudo mkdir ./authorized_keys

touch sshd_config

sudo cat <<EOF > sshd_config
Protocol 2

#AllowUsers
DenyUsers *

AuthorizedKeysFile	./authorized_keys

HostKey /etc/ssh/ssh_host_ecdsa_key

PasswordAuthentication no
ChallengeResponseAuthentication no
PubkeyAuthentication yes

PermitRootLogin no
X11Forwarding no
IgnoreRhosts yes

#Stricter retry
MaxAuthTries 3

KexAlgorithms curve25519-sha256,diffie-hellman-group-exchange-sha256,diffie-hellman-group-exchange-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group14-sha256       
EOF

sudo cp sshd_config /etc/ssh/
sudo rm sshd_config

sudo sshd -t

git clone https://github.com/arthepsy/ssh-audit
python ssh-audit/ssh-audit.py --verbose --no-colors localhost > report.txt
rm -rf ssh-audit
cat report.txt | less

sudo systemctl restart sshd
sudo systemctl status sshd

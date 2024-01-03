
#!/bin/bash

if [ $EUID -ne 0 ]; then
  echo "Please run as superuser"
  exit 1
fi
apt-get -y install john
wget https://gitlab.com/kalilinux/packages/wordlists/-/raw/kali/master/rockyou.txt.gz
gunzip rockyou.txt.gz
/usr/sbin/unshadow /etc/passwd /etc/shadow > /tmp/pwds.db
john /tmp/pwds.db -wordlist=rockyou.txt
rm /tmp/pwds.db
apt purge john
rm rockyou.txt

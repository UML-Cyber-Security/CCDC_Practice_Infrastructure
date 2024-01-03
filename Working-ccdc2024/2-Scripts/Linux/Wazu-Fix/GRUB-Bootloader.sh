#! /bin/bash

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Bootloader Permissions
chown root:root /boot/grub2/grub.cfg 
chmod og-rwx /boot/grub2/grub.cfg

# Create an encrypted password with 
grub-mkpasswd-pbkdf2 
# Add the following into a custom /etc/grub.d configuration file:     
#cat <<EOF     set superusers="<username>"   password_pbkdf2 <username> <encrypted-password>      EOF  
#The superuser/user information and password should not be contained in the /etc/grub.d/00_header file as this file could be overwritten in a package update.
#If there is a requirement to be able to boot/reboot without entering the password, edit /etc/grub.d/10_linux and add --unrestricted to the line CLASS=  Example: CLASS="--class gnu-linux --class gnu --class os --unrestricted"
update-grub
# Edit /etc/default/grub and add the apparmor=1 and security=apparmor parameters to the GRUB_CMDLINE_LINUX= line   GRUB_CMDLINE_LINUX="apparmor=1 security=apparmor"      Run the following command to update the grub2 configuration # update-grub    Notes: This recommendation is designed around the grub bootloader, if LILO or another bootloader is in use in your environment enact equivalent settings.

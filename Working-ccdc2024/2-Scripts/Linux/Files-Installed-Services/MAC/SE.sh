# If there exists this file, it is a debian based system. Use APT
if [ -f "/etc/debian_version" ]; then
    systemctl stop apparmor
    systemctl disable apparmor
    apt-get install policycoreutils selinux-basics selinux-utils -y
    selinux-activate
elif [ -f "/etc/redhat-release" ]; then
    yum install sudo yum install policycoreutils policycoreutils-python setools setools-console setroubleshoot
    selinux-activate
elif [ -f "/etc/arch-release" ]; then
    echo "Arch, Will this come up -- probably should do fedora"
fi


# Ubuntu
#https://www.linode.com/docs/guides/how-to-install-selinux-on-ubuntu-22-04/
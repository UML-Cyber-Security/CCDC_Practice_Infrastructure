#! /bin/bash
# Installs Glusterfs, starts and enables the service

#********************************
# Written by a sad Matthew Harper...
#********************************

# Check if the scrip is ran as root.
# $EUID is a env variable that contains the users UID
# -ne 0 is not equal zero
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Install 
# Stolen from online. Differnet package managers
# Declare an array, and map values 
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/debian_version]=apt-get
#osInfo[/etc/alpine-release]=apk # Not avalable on Alpine linux
#osInfo[/etc/SuSE-release]=zypp
#osInfo[/etc/gentoo-release]=emerge
echo "[+] Installing Gluster"

PKG="apt-get"
for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then # Could move the ifs in here.
        PKG=${osInfo[$f]}
        if [ "$PKG" = "apt-get" ];then
          export DEBIAN_FRONTEND=noninteractive
          $PKG install -y glusterfs
        elif [ "$PKG" = "yum" ]; then
          $PKG install -y glusterfs
        elif [ "$PKG" = "pacman" ]; then
          echo "We Have more issues"
        fi
        break
    fi
done

# Need to make it agnostic"

apt-get install glusterfs-server -y

echo "[+] Setting permissions to gluster config files"
# Create Backups of configs
mkdir -p /backups/configs/gluster
# Change ownership of the directory to root (explicit, should inherit from parent?)
chown root:root /backups/configs/gluster
# Make it read-write for root but only read for others
chmod 644 /backups/configs/gluster
# Copy entire directory (I am lazy, most all of it is configurable)
cp -r /etc/glusterfs/ /backups/configs/gluster/

# Enable and Start 
echo "[+] Strating Gluster"
systemctl enable --now glusterd


# Limit number of bricks 
echo "[+] Liniting number of ports (bricks) gluster can use"
sed -i 's/.*base-port.*/    option base-port 49152/g' /etc/glusterfs/glusterd.vol
sed -i 's/.*max-port.*/    option max-port 49162/g' /etc/glusterfs/glusterd.vol

echo "[!!] Creating Gluster Firewall Rules"

# Make Chain for Gluster-IN Rules 
iptables -N GLUSTER-IN
# Make Chain for Gluster-OUT Rules
iptables -N GLUSTER-OUT
# Make Chain for Gluster-IN Rules
ip6tables -N GLUSTER-IN
# Make Chain for Gluster-OUT Rules 
ip6tables -N GLUSTER-OUT

# --------------------------------------    Setup GLUSTER Chain      ------------------------------------------------
## IPv4
### IN
# Gluster Management Ports -- they mention TCP and UDP
iptables -A GLUSTER-IN -p tcp -m multiport --dport 24007,24008 -m conntrack --ctstate NEW -j ACCEPT
# Gluster Brick Ports (May be randomized in range after gluster 10)
iptables -A GLUSTER-IN -p tcp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT
# iptables -A GLUSTER -p udp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT # UDP is not mentioned, we will see if it works without

### OUT --> Pain we may have to deal with traffic to a gluster management port, or from a gluster port (responce)
iptables -A GLUSTER-OUT -p tcp -m multiport --sport 24007,24008 -j ACCEPT
# Gluster Brick Ports (May be randomized in range after gluster 10)
iptables -A GLUSTER-OUT -p tcp -m multiport --sport 49152:49162 -j ACCEPT
# iptables -A GLUSTER -p udp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT # UDP is not mentioned, we will see if it works without
# Gluster Management Ports -- they mention TCP and UDP
iptables -A GLUSTER-OUT -p tcp -m multiport --dport 24007,24008 -j ACCEPT
# Gluster Brick Ports (May be randomized in range after gluster 10)
iptables -A GLUSTER-OUT -p tcp -m multiport --dport 49152:49251 -j ACCEPT
# iptables -A GLUSTER -p udp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT # UDP is not mentioned, we will see if it works without


## IPv6
### IN
# Gluster Management Ports -- they mention TCP and UDP
ip6tables -A GLUSTER-IN -p tcp -m multiport --dport 24007:24008 -m conntrack --ctstate NEW -j ACCEPT
# Gluster Brick Ports (May be randomized in range after gluster 10
ip6tables -A GLUSTER-IN -p tcp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT
# ip6tables -A GLUSTER -p udp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT # UDP is not mentioned, we will see if it works without

### OUT --> Pain we may have to deal with traffic to a gluster management port, or from a gluster port (responce)
# Gluster Management Ports -- they mention TCP and UDP
ip6tables -A GLUSTER-OUT -p tcp -m multiport --sport 24007:24008 -j ACCEPT
# Gluster Brick Ports (May be randomized in range after gluster 10
ip6tables -A GLUSTER-OUT -p tcp -m multiport --sport 49152:49162 -j ACCEPT
# ip6tables -A GLUSTER -p udp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT # UDP is not mentioned, we will see if it works without
# Gluster Management Ports -- they mention TCP and UDP
ip6tables -A GLUSTER-OUT -p tcp -m multiport --dport 24007:24008 -j ACCEPT
# Gluster Brick Ports (May be randomized in range after gluster 10
ip6tables -A GLUSTER-OUT -p tcp -m multiport --dport 49152:49162 -j ACCEPT
# ip6tables -A GLUSTER -p udp -m multiport --dport 49152:49162 -m conntrack --ctstate NEW -j ACCEPT # UDP is not mentioned, we will see if it works without
# -------------------------------------------------------------------------------------------------------------------

iptables -A INPUT -j GLUSTER-IN
iptables -A OUTPUT -j GLUSTER-OUT
ip6tables -A INPUT -j GLUSTER-IN
ip6tables -A OUTPUT -j GLUSTER-OUT


# GLUSTER=$(iptables -nvL | grep "GLUSTER" | wc -l ) 
# echo $GLUSTER
# if [ "$GLUSTER" != 0 ]
#   then echo "Appending Gluster Firewall Chains to the Firewall"
#   iptables -A INPUT -j GLUSTER-IN
#   iptables -A OUTPUT -j GLUSTER-OUT
#   ip6tables -A INPUT -j GLUSTER-IN
#   ip6tables -A OUTPUT -j GLUSTER-OUT
# fi


# Create Gluster directory and Inital Brick
echo "[+] Creating Gluster Directory in Root Directory for Brick Dirs"
mkdir -p /gluster/brick1

echo "[!!] Restarting Gluster"
systemctl restart glusterd
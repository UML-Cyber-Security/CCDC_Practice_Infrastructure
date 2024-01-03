
# Modprobe : Removing support for unneeded filesystem types reduces the local attack surface of the server. If this filesystem type is not needed, disable it.
# Filesystems -- disabling/removing the kernel modules for them
# Remove CRAM Filesystem
touch /etc/modprobe.d/cramfs.conf
echo "install cramfs /bin/true" > /etc/modprobe.d/cramfs.conf
rmmod cramfs

# Remove freevx filesystem
touch /etc/modprobe.d/cramfs.conf 
echo "install freevxfs /bin/true" > /etc/modprobe.d/cramfs.conf 
rmmod freevxfs

# Remove jffs2 Filesystem
touch /etc/modprobe.d/jffs2.conf 
echo "install jffs2 /bin/true" > /etc/modprobe.d/jffs2.conf 
rmmod jffs2

# Remove hfs Filesystem
touch /etc/modprobe.d/hfs.conf 
echo "install hfs /bin/true" > /etc/modprobe.d/hfs.conf 
rmmod hfs

# Remove hfsplus Filesystem
touch /etc/modprobe.d/hfsplus.conf 
echo "install hfsplus /bin/true" > /etc/modprobe.d/hfsplus.conf 
rmmod hfsplus

# Remove udf
touch /etc/modprobe.d/udf.conf
echo "install udf /bin/true" > /etc/modprobe.d/hfsplus.conf 
rmmod udf

# Dont care?
# USB storage provides a means to transfer and store files insuring persistence and availability of the files independent of network connection status. Its popularity and utility has led to USB-based malware being a simple and common means for network infiltration and a first step to establishing a persistent threat within a networked environment.
touch /etc/modprobe.d/usb_storage.conf 
echo "install usb-storage /bin/true" > /etc/modprobe.d/usb_storage.conf  
rmmod usb-storage	



#### Protocols -- disabiling them
#The Datagram Congestion Control Protocol (DCCP) is a transport layer protocol that supports streaming media and telephony. 
# DCCP provides a way to gain access to congestion control, without having to do it at the application layer, 
#but does not provide in- sequence delivery.
# If the protocol is not being used, it is recommended that kernel module not be loaded, disabling the service to reduce the potential attack surface.
touch /etc/modprobe.d/dccp.conf # Need to check if it is required.
echo "install dccp /bin/true" > /etc/modprobe.d/dccp.conf 

# The Stream Control Transmission Protocol (SCTP) is a transport layer protocol used to support message oriented communication, with several streams of messages in one connection. It serves a similar function as TCP and UDP, incorporating features of both. It is message-oriented like UDP, and ensures reliable in-sequence transport of messages with congestion control like TCP.
#If the protocol is not being used, it is recommended that kernel module not be loaded, disabling the service to reduce the potential attack surface.
touch /etc/modprobe.d/sctp.conf # Need to check if it is required.
echo "install sctp /bin/true" >> /etc/modprobe.d/sctp.conf 

# The Reliable Datagram Sockets (RDS) protocol is a transport layer protocol designed to provide low-latency, high-bandwidth communications between cluster nodes. It was developed by the Oracle Corporation.
#If the protocol is not being used, it is recommended that kernel module not be loaded, disabling the service to reduce the potential attack surface.
touch /etc/modprobe.d/rds.conf # Need to check if it is required.
echo "install rds /bin/true" >> /etc/modprobe.d/rds.conf

# The Transparent Inter-Process Communication (TIPC) protocol is designed to provide communication between cluster nodes.
# Again if not needed disable 
touch /etc/modprobe.d/tipc.conf # Need to check if it is required.
echo "install tipc /bin/true" >> /etc/modprobe.d/rds.conf
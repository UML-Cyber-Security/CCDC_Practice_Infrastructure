FROM archlinux/base
COPY named.conf /etc
RUN 	pacman -Syu bind --noconfirm && \
	dnssec-keygen -a NSEC3RSASHA1 -b 2048 -n ZONE cst.com && \	
	dnssec-keygen -f KSK -a NSEC3RSASHA1 -b 4096 -n ZONE cst.com && \
	mkdir /var/named/master && \
	cp Kcst.com* /var/named/master && \	
	chmod 444 /etc/named.conf
EXPOSE 53

FROM alpine:latest

ARG DOMAIN
ARG ZONE_FILE

RUN apk update
RUN apk add --no-cache bind bind-dnssec-tools

# setup file system
WORKDIR /etc/bind
RUN mkdir -m 700 keys

# zone signing keys
RUN dnssec-keygen -a ECDSAP256SHA256 $DOMAIN. && \
	mv K$DOMAIN*.key keys/zsk.key && \
	mv K$DOMAIN*.private keys/zsk.private

# key signing key
RUN dnssec-keygen -a ECDSAP256SHA256 -fKSK -n ZONE $DOMAIN && \
	mv K$DOMAIN*.key keys/ksk.key && \
        mv K$DOMAIN*.private keys/ksk.private

# copy and sign zones
COPY bind/ /etc/bind/
RUN dnssec-signzone \
	-o $DOMAIN \
	-N INCREMENT \
	-t \
	-k keys/ksk.private \
	$ZONE_FILE \
	keys/zsk.private

# setup permissions
RUN chmod -R go-rwx /etc/bind /var/log && \
	chown -R named:named /etc/bind /var/log && \
	setcap 'cap_net_bind_service=+ep' /usr/sbin/named
USER named

ENTRYPOINT ["named", "-c", "/etc/bind/named.conf", "-g"]

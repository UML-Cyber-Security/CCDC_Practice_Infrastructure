FROM alpine:latest as easyrsa

RUN apk update
RUN apk add --no-cache easy-rsa && \
	mv /usr/share/easy-rsa /easy-rsa

COPY vars /easy-rsa/vars

# build the ca and server certificates
RUN cd /easy-rsa && \
	./easyrsa init-pki && \
	./easyrsa --batch build-ca nopass && \
	./easyrsa --batch gen-req ccdc_web nopass && \
	./easyrsa --batch sign-req server ccdc_web


FROM alpine:latest as apache2

RUN apk update
RUN apk add --no-cache apache2 apache2-ssl syslog-ng libcap

# setup apache2 files
COPY apache2/ /etc/apache2/
COPY www/ /var/www/localhost/htdocs/

# copy apache2 keys
RUN mkdir -m 700 /etc/apache2/ssl
COPY --from=easyrsa /easy-rsa/pki/issued/ccdc_web.crt /etc/apache2/ssl/server.crt
COPY --from=easyrsa /easy-rsa/pki/private/ccdc_web.key /etc/apache2/ssl/server.key

# setup syslog-ng files
# note that the CA certificate must be provided in the source. all nodes connecting
# to a central SIEM must be configured using the same certificate.
COPY syslog-ng/ /etc/syslog-ng/

# setup permissions
RUN chmod -R go-rwx /etc/apache2 /etc/syslog-ng/ /var/www /var/log /run && \
        chown -R apache:apache /etc/apache2 /etc/syslog-ng/ /var/www /var/log /run && \
        setcap 'cap_net_bind_service=+ep' /usr/sbin/httpd
USER apache

ENTRYPOINT ["httpd", "-DFOREGROUND"]

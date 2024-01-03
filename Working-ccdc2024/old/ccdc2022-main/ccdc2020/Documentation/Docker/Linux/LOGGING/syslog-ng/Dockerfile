FROM alpine:latest

ARG CONFIG_DIR

RUN apk update && \
	apk add --no-cache syslog-ng

COPY $CONFIG_DIR /etc/syslog-ng/
RUN chmod -R go-rwx /etc/syslog-ng/

ENTRYPOINT ["/usr/sbin/syslog-ng", "-F"]

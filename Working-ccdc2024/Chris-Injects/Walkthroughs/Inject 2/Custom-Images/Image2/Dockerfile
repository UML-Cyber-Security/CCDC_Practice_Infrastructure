FROM ubuntu:20.04

RUN apt-get update -y
RUN apt-get install -y vim

COPY ../entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/bin/sh", "entrypoint.sh" ]
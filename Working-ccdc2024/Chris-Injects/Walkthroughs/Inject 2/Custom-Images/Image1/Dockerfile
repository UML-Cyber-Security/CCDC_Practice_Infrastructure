FROM ubuntu:20.04

RUN apt-get update -y
RUN apt-get install -y emacs
RUN apt-get install -y vim
RUN apt-get install -y nano 

COPY ../entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/bin/sh", "entrypoint.sh" ]
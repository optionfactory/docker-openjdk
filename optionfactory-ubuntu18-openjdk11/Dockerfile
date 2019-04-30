FROM ubuntu:18.04
LABEL maintainer="Lorenzo Caenazzo <lorenzo.caenazzo@optionfactory.net>"

COPY deps /tmp/
RUN cp /tmp/install-ps1.sh /etc/bash.bashrc
RUN cp /tmp/gosu-*  /usr/local/bin/gosu
RUN /tmp/install-spawn-and-tail.sh
# install OpenJDK 11
RUN /tmp/install-openjdk11.sh
RUN rm -rf /tmp/*

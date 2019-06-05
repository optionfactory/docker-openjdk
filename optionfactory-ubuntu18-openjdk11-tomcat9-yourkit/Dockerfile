FROM optionfactory/ubuntu18-openjdk11-tomcat9
COPY deps /tmp/

RUN /tmp/install-yourkit.sh
RUN rm -rf /tmp/*

EXPOSE 8080 8084 10001

ENTRYPOINT ["/tomcat"]

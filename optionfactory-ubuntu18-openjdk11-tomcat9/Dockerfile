FROM optionfactory/ubuntu18-openjdk11
COPY deps /tmp/

RUN /tmp/install-tomcat9.sh
RUN cp /tmp/init-tomcat9.sh /tomcat
RUN rm -rf /tmp/*

EXPOSE 8080 8084

ENTRYPOINT ["/tomcat"]
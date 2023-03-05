FROM redhat/ubi8:8.7
LABEL maintainer="patrik.gulija1@gmail.com"
RUN dnf install -y java-1.8.0-openjdk-devel-1:1.8.0.362.b09-2.el8_7 npm-1:6.14.11-1.10.24.0.1.module+el8.3.0+10166+b07ac28e && dnf -y clean all && rm -rf /var/cache
ARG NEXUS_HOME=/opt/nexus
COPY nexus-3.37.3-02-unix.tar.gz /tmp
RUN mkdir $NEXUS_HOME && tar -xvf /tmp/nexus-3.37.3-02-unix.tar.gz -C $NEXUS_HOME --strip-components 1
WORKDIR $NEXUS_HOME
RUN npm install
EXPOSE 8081
VOLUME $NEXUS_HOME/sonatype-work
ENTRYPOINT ["./bin/nexus", "run"]
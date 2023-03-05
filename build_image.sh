#!bin/bash
wget https://download.sonatype.com/nexus/3/nexus-3.37.3-02-unix.tar.gz
docker build . -t nexus
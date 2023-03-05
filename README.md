<h1> Description of project</h1>
<h2>This project provides an easy way to deploy container Nexus Repository Manager using bash scripts to build an image and run the container.</h2>

<h1>How to run container</h1>

1. Run the build_image.sh script to build an image.
    - navigate to the location of the script
    - execute script with the command: bash build_image.sh
2. Run the run_container.sh script to create the container.
    - navigate to the location of the script
    - execute script with the command: bash build_image.sh



<h1>Dockerfile</h1>

>FROM redhat/ubi8:8.7

This line specifies the base image that the Docker image will be built on. Red Hat Universal base image version 8.7.

>LABEL maintainer="patrik.gulija1@gmail.com"

Label to the docker image to indicate the email address of the maintainer.

>RUN dnf install -y java-1.8.0-openjdk-devel-1:1.8.0.362.b09-2.el8_7 npm-1:6.14.11-1.10.24.0.1.module+el8.3.0+10166+b07ac28e && dnf -y clean all && rm -rf  var/cache

This line installs Java 1.8.0 and npm package manager using dnf package manager.
dnf -y we use to remove any cached package data to reduce the size of the Docker image.

>ARG NEXUS_HOME=/opt/nexus

Declares a variable NEXUS_HOME with the default value of /opt/nexus.

>COPY nexus-3.37.3-02-unix.tar.gz /tmp

This line copies the archived nexus file from the local directory to the Docker images /tmp directory.

>RUN mkdir $NEXUS_HOME && tar -xvf /tmp/nexus-3.37.3-02-unix.tar.gz -C $NEXUS_HOME --strip-components 1

This line creates a NEXUS_HOME directory and extracting the archived nexus file to this directory and we are removing the top-level directory from the extracted file.

>WORKDIR $NEXUS_HOME

This line sets the working directory of a Docker container ro NEXUS_HOME

>RUN npm install

Installs the npm packages.

>EXPOSE 8081

Exposes port 8081 used by nexus.

>VOLUME $NEXUS_HOME/sonatype-work

Creates volume used by nexus to store data.

>ENTRYPOINT ["./bin/nexus", "run"]

Specifies the command which will be ran when the Docker container is started. It runs the nexus using script ./bin/nexus with the run argument.

<h1>Scripts</h1>

<h2>build_image.sh</h2>

>wget https://download.sonatype.com/nexus/3/nexus-3.37.3-02-unix.tar.gz
>
>docker build . -t nexus

Pulls nexus repository manager file and builds image from the Dockerfile

**-t** tags the container image as `nexus`

<h2>run_container.sh</h2>

>docker run -d --name nexus -p 18081:8081 -v /tn_devops/nexus:/opt/nexus/sonatype-work --restart unless-stopped nexus

**docker run** is the command to run a container

**-d** option runs the container in detached mode (background)

**--name nexus** option specifies the name of the container to nexus

**-p 18081:8081** option maps port 18081 on the host machine to port 8081 on the container.

**-v /tn_devops/nexus:/opt/nexus/sonatype-work** option mounts `/tn_devops/nexus` on the host machine to the `/opt/nexus/sonatype-work` directory in the container.

**--restart** unless-stopped option specifies that the container will be restarted automatically if it stops, except if it is manually stopped.
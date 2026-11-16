#!/bin/bash
#source $(dirname $0)/../alphabot-sh/swarmexec.sh

export date_tag=$(date +"%Y-%m-%d")
#export date_tag=2024-09-10
echo $date_tag

#docker build -t alphabot-java-tomcat-r:latest . --no-cache
docker build -t alphabot-java-tomcat-r:latest .
docker tag alphabot-java-tomcat-r:latest aliaksei1/alphabot:alphabot-java-tomcat-r-$date_tag

# docker login docker.io
docker push aliaksei1/alphabot:alphabot-java-tomcat-r-$date_tag

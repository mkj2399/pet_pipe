#!/bin/sh
docker network create pipeline_network

docker run --name artifactory \
--network pipeline_network \
-v $PWD/jfrog/config:/var/opt/jfrog/artifactory/etc/import \
-v $PWD/data/artifactory/var/:/var/opt/jfrog/artifactory \
-d -p 8081:8081 -p 8082:8082 releases-docker.jfrog.io/jfrog/artifactory-oss:latest
#!/bin/sh
docker network create pipeline_network

docker run -d \
--network pipeline_network \
-v /var/run/docker.sock:/var/run/docker.sock \
-v jenkins_home:/var/jenkins_home \
-e JAVA_OPTS="-Djenkins.install.runSetupWizard=false" \
-e JENKINS_ADMIN_ID=admin \
-e JENKINS_ADMIN_PASSWORD=admin \
-p 8080:8080 \
-p 50000:50000 \
--privileged \
--name jenkins \
jenkins_alfa
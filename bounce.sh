#!/bin/sh 

cd /opt/medied/deploy

docker-compose rm -v -s -f \
&& docker-compose up -d --remove-orphans
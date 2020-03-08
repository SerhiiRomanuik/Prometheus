#!/bin/sh 

cd /opt/medied/deploy

docker-compose pull \
&& docker-compose down -v \
&& docker-compose up -d --remove-orphans

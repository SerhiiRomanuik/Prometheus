#!/bin/sh 

cd /opt/medied/deploy

docker-compose rm -v -s -f \
&& docker system prune -f -a --volumes \
&& docker-compose up -d --remove-orphans
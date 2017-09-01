#!/bin/bash

cname=$1;  # container name (m: manager or w: worker)
cid=$2;    # container id

## (1): delete container if it already exists 
#docker stop ${cname}${cid}
#docker rm ${cname}${cid}

## (2): Create a container with docker 'dind' image
docker run --privileged  --name  ${cname}${cid} -d docker:17.06-dind
sleep 2 # wait 2 second for the dockerd daemon to start

## (3): Set the containers log into the 'debug' mode
docker cp daemon.json   ${cname}${cid}:/etc/docker/daemon.json
sleep 3  # wait 3 seconds  for the dockerd daemon to completely restart
docker exec -it ${cname}${cid} kill -SIGHUP 1  # re-start dockerd
docker exec -it ${cname}${cid} docker info | grep -i debug.*server # checks if debug is enabled

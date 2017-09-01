#!/bin/bash

cn=$1;   # container name (m: manager or w: worker)
cid=$2;  # container id
tokenKey=$3; # swarm master token key  
masterIpAddress=$4; # ipAddress of the master node

## Add node to the docker swarm cluster
docker exec -it ${cn}${cid} docker swarm join --token $tokenKey $masterIpAddress
echo "${cn}${cid} added to the swarm cluster"
sleep 2

#!/bin/bash

c=$1 # controller Id
option=$2  # option selection

ip=$(hostname -I | awk '{print $1}')

if [ $option == 1 ]; then
    docker swarm  init --advertise-addr $ip  
    docker swarm join-token worker >&  /tmp/multi_worker_join.txt

else
    myIp=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $ip-host${c})
    docker exec -it $ip-host${c} docker swarm init --advertise-addr  $myIp
    docker exec -it $ip-host${c} docker swarm join-token worker >&  /tmp/emulated_worker_join.txt
fi

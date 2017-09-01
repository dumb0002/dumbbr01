#!/bin/bash

n=$1; # total number of containers
net=$2  # overlay network name

ip=$(hostname -I | awk '{print $2}') # hostname ipaddress

sleep 3

for (( c=1; c<=$n; c++ ))
do 
   ## (1): Create a container with docker 'dind' image
   docker run --privileged --network $net --name  $ip-host${c} -d docker:17.06-dind
   sleep 2 # wait 2 second for the dockerd daemon to start

   ## (2): Set the containers log into the 'debug' mode 
   docker cp /tmp/daemon.json  $ip-host${c}:/etc/docker/daemon.json
   sleep 3  # wait 3 seconds  for the dockerd daemon to completely restart
   docker exec -it $ip-host${c} kill -SIGHUP 1  # re-start dockerd
   sleep 3
done

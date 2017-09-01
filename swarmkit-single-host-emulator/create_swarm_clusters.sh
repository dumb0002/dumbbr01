#!/bin/bash

n=$1;  # input: number of workers to be added into the swarm cluster
tokenKey=$2; # swarm master token key  
masterIpAddress=$3; # ipAddress of the master node

echo "-------------------------------------------------"
echo $tokenKey
echo $masterIpAddress
echo "-------------------------------------------------"
## assumption: the master node always has container id=1
for (( c=2; c<=$n; c++ ))
do 
   ## Add worker nodes into the docker swarm cluster
   echo ${c} 
   docker exec -it dind${c} docker swarm join --token $tokenKey $masterIpAddress
done

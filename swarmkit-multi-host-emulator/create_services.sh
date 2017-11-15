#!/bin/bash
########################################################
#  Input:
#        mg - manager node Id (container Id)
#        n - total number of services to be create
#        rc - number of replicas
#        net - network name
#        net_id - network given id
#        sname  - service name
#        image  -  docker image type (service image)
#        eth - network interface name
########################################################

mg=$1;
n=$2;
rc=$3;
net=$4;  
net_id=$5;
sname=$6;
image=$7;
eth=$8;


## (1): create  overlay network
#ip=$(hostname -I | awk '{print $2}')
ip=$(/sbin/ifconfig $eth | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

docker exec -it $ip-host${mg} docker network create --driver overlay $net$net_id

## (2): create service  and attach them to the overlay network
for (( c=1; c<=$n; c++ ))
do 
   ## Add worker nodes into the docker swarm cluster
   docker exec -it $ip-host${mg}  docker service create --replicas $rc --network $net${net_id} --name  $sname-$net${net_id}-$c  $image

done

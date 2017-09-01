#!/bin/bash
########################################################
#  Input:
#        mg - manager node Id (container Id)
#        rc - number of replicas
#        n -  total number of services to be created
#        net - network name
#        subnet - network subnet
#        sname  - service name
#        image  -  docker image type (service image)
########################################################

mg=$1;
rc=$2;
n=$3;
net=$4;  
subnet=$5;   
sname=$6;
image=$7;


## (1): create  overlay network
docker exec -it ${mg} docker network create --driver overlay --subnet  $subnet  $net
echo "Finished creating the network: $net"

## (2): create service  and attach them to the overlay network
for (( c=1; c<=$n; c++ ))
do 
   ## Add worker nodes into the docker swarm cluster
   echo ${c} 
   docker exec -it ${mg}  docker service create --replicas $rc --network $net --name $sname${c}  $image
   echo "Finished creating service: $c"
done
echo "Finished creating total number of services: $n"

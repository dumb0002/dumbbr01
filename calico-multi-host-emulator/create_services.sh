#!/bin/bash
################################################################
#  Input:
#        net - network name
#        image  -  docker image type (service image)
#        netnum - total number of networks
#        num_agents - total number of emulated hosts (agents)
#        nwl - total number of workloads to be created
#        eth - interface name
################################################################


net=$1;     
image=$2;
netnum=$3;
num_agents=$4;
nwl=$5;
eth=$6;

ip=$(/sbin/ifconfig $eth | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
hostname=$(hostname)


## (1): creating the workloads for the calico networks
for (( c=1; c<=$netnum; c++ ))
do
   for (( i=1; i<=$num_agents; i++))
   do 
         for ((j=1; j<=$nwl; j++))
         do
            ## Add workload to the calico networks 
            docker exec -it $ip-host${i}  docker run --net $net${c} --name $hostname${i}-net${c}-$j  -tid  $image
         done
   done
done

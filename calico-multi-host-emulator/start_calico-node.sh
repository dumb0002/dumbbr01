#!/bin/bash

n=$1; # total number of containers
etcd_ip=$2;
eth=$3;  # interface

#ip=$(hostname -i) # hostname ipaddress
host_ip=$(/sbin/ifconfig $eth | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')


for (( c=1; c<=$n; c++ ))
do
   docker cp /tmp/calico_helper.sh  $host_ip-host${c}:/tmp/calico_helper.sh
   docker exec -it $host_ip-host${c} sh /tmp/calico_helper.sh $etcd_ip  $host_ip-host${c}   
   sleep 10 # wait 3 second for the dockerd daemon to start
done



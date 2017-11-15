#!/bin/bash

netname=$1
net_id=$2
eth=$3


ip=$(/sbin/ifconfig $eth | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

docker exec -it $ip-host1  docker network create --driver calico --ipam-driver calico-ipam $netname$net_id

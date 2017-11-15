#!/bin/bash


etcd_ip=$1;
cal_ip=$(hostname -i);

## extracting name for calico node 
extra=$(calicoctl node run --init-system --dryrun --node-image=quay.io/calico/node:v2.6.2);

echo $extra > /tmp/calico_commands.txt
#calico_name=$(cat /tmp/calico_commands.txt | grep -Po 'NODENAME=\K[0-9]+');

calico_name=$(python /tmp/calico_helper.py /tmp/calico_commands.txt);

## starting the calico node
docker run -d --net=host --privileged --name=calico-node --rm -e NODENAME=$calico_name -e IP=${cal_ip} -e CALICO_NETWORKING_BACKEND=bird -e CALICO_LIBNETWORK_ENABLED=true -e ETCD_ENDPOINTS=http://$etcd_ip:2379 -v /var/log/calico:/var/log/calico -v /var/run/calico:/var/run/calico -v /lib/modules:/lib/modules -v /run:/run -v /run/docker/plugins:/run/docker/plugins -v /var/run/docker.sock:/var/run/docker.sock quay.io/calico/node:v2.6.2



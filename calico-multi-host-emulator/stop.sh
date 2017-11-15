#!/bin/bash

pkill etcd
docker stop $(docker ps -a -q)
docker rm -v  $(docker ps -a -q)
#docker network rm $netname
rm -r /var/lib/docker/aufs/mnt
docker swarm leave --force

#!/bin/bash
docker stop $(docker ps -a -q)
docker rm -v  $(docker ps -a -q)
#docker rm $(docker ps -a -q)
rm -r /var/lib/docker/aufs/mnt

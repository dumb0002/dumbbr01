#!/bin/bash

docker exec -it c1 docker swarm  init  >&  /tmp/worker_join.txt
docker exec -it c1 docker swarm join-token manager >&  /tmp/manager_join.txt

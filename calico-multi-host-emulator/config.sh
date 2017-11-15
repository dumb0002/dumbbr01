#!/bin/bash


cp /tmp/daemon.json /etc/docker/daemon.json
sleep 5  # wait 5 seconds  for the dockerd daemon to completely restart
sudo kill -SIGHUP $(pidof dockerd)  # re-start dockerd
docker info | grep -i debug.*server # checks if debug is enabled


## configuring docker dind daemon
IP=$1  # etcd store ip address

cat > /tmp/daemon_etcd.json << EOF1
{
  "debug": true,
  "cluster-store": "etcd://$IP:2379",
  "cluster-advertise": "$IP:2379"
}
EOF1

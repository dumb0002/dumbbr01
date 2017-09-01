#!/bin/bash

cp /tmp/daemon.json /etc/docker/daemon.json
sleep 5  # wait 5 seconds  for the dockerd daemon to completely restart
sudo kill -SIGHUP $(pidof dockerd)  # re-start dockerd
docker info | grep -i debug.*server # checks if debug is enabled

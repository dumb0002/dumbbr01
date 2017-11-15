#!/bin/bash

IP=$1

cat > /tmp/daemon_etcd.json << EOF1
{
  "debug": true,
  "cluster-store": "etcd://$IP:2379",
  "cluster-advertise": "$IP:2379"
}
EOF1

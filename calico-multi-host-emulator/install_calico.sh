#!/bin/bash

#(1): Install calico:
sudo wget -O /usr/local/bin/calicoctl https://github.com/projectcalico/calicoctl/releases/download/v1.6.1/calicoctl
sudo chmod +x /usr/local/bin/calicoctl


#(2): Move calico executable:
mkdir /tmp/calico-code/
mv /usr/local/bin/calicoctl   /tmp/calico-code/

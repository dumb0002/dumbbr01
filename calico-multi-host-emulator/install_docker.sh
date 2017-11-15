#!/bin/bash

#(1): Update the apt package index:
sudo apt-get update

#(2): Install packages to allow apt to use a repository over HTTPS:
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

#(3): Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#(4):  Verify that the key fingerprint is 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88.
sudo apt-key fingerprint 0EBFCD88

#(5):  Add repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

#(6): Install Docker
sudo apt-get update
sudo apt-get -y install docker-ce=17.06.0~ce-0~ubuntu
#sudo docker run hello-world

#(7): Install dstat
sudo apt-get -y install dstat

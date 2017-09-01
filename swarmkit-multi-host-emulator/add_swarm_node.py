#!/usr/bin/python
import re
import os
import multiprocessing
import sys
import logging
import gzip
from time import strftime
from socket import gethostname
import datetime
import time
import subprocess
import shlex


class addSwarmNode (multiprocessing.Process):

  def __init__(self, fname, begin, end, option):

        multiprocessing.Process.__init__(self)
        self.fname = fname
        self.begin = int(begin)
        self.end = int(end)
        self.option = int(option)

  def get_containerIp(self, cid):
      output = subprocess.check_output("docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' " + str(cid), shell=True)
      return output


  def get_hostIp(self):
      output = subprocess.check_output("hostname -I | awk '{print $2}' ", shell=True)
      ip = output.strip("\n").strip()
      return ip

  
  def get_clusterToken(self, fname):
       f = open("/tmp/" + fname, "r") ## extracting swarm cluster my token key and ip Address

       for line in f:
           searchObj = re.search("swarm join --token", line, re.M|re.I)
           if searchObj:
              join_command = line.lstrip().strip("\n")
              break
       f.close()
       temp = join_command.split(" ")
       token = temp[4]
       managerIp = temp[5]
       return (managerIp,token)

 
  def run(self):
 
       if self.option == 1:
           (leaderIp, m_token) = self.get_clusterToken(self.fname) ## extracting swarm cluster manager token
           subprocess.call(shlex.split("docker swarm join --token " + m_token + " " + leaderIp)) ## add manager or worker to the swarm cluster

       elif self.option == 2:
           (leaderIp, m_token) = self.get_clusterToken(self.fname) ## extracting swarm cluster manager token
           hostIp = self.get_hostIp()

           for i in range(self.begin, self.end+1):
               cid = str(hostIp) + "-host" + str(i)
               subprocess.call(shlex.split("docker exec -it " + cid + "  docker swarm join --token " + m_token + " " + leaderIp))


if __name__ == "__main__":

    # Run  Process 1
    addSwarmNode = addSwarmNode (sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
    addSwarmNode.start()

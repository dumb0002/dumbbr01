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
import decimal
import numpy as np
import subprocess
import shlex
import math


class cdf (multiprocessing.Process):

  def __init__(self):

        multiprocessing.Process.__init__(self)
        #self.fname = filename
        #calendar_date = str(datetime.date.today())
        #logging.basicConfig(filename='/project/zhang-data06/Braulio/gp_stats/inDegrees/cdf/logs/' + self.f + '_' + calendar_date + '_' + gethostnam$
        #logging.basicConfig(format='%(levelname)s:%(message)s', level=logging.DEBUG)

  def get_managerIp(self, id):
      output = subprocess.check_output("docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' c" + str(id), shell=True)
      return output

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

       logging.info(strftime("%Y-%m-%d %H:%M:%S") + "Started Processing Data ........... ")
       ############ (1): Reading the template file information ###############
       f = open("template.txt", "r")

       metadata = {}
       for line in f:
           if line.startswith("#"):
              continue
           temp = line.strip("\n").split("=")
           key = temp[0]
           value = temp[1]
           metadata[key]=value
       f.close()
   
       ############ (2): Creating Containers (Host Emulator) ############  
       #subprocess.call(shlex.split('./create_containers.sh ' + metadata["k1"]))
       managers_ip = {}
       ############ (3): Creating the Docker Swarm Cluster ##############
       subprocess.call(shlex.split("./build_containers.sh c 1")) 
       subprocess.call(shlex.split("./swarm_init.sh")) ## init swarm cluster leader
       
       (leaderIp, m_token) = self.get_clusterToken("manager_join.txt") ## extracting swarm cluster manager token
       managers_ip[1] = leaderIp
       
       (leaderIp, w_token) = self.get_clusterToken("worker_join.txt")  ## extracting swarm cluster worker token

       nc = int(metadata["k1"])  # number of managers
       nw = int(metadata["k2"])  # number of workers
       k = int(math.ceil((nw+0.0)/nc))  # number of wokers per manager node

       if nc > 1:
          for i in range(2, nc+1):
              subprocess.call(shlex.split("./build_containers.sh c " + str(i)))
              subprocess.call(shlex.split("./add_swarm_node.sh c " + str(i) + " " + m_token + " " + leaderIp)) ## add manager to the swarm cluster
              ip = self.get_managerIp(i)
              managers_ip[i] = ip
       a = 1
       b = k
       for i in range(1, nc+1):
           print "====================        MANAGER: " + str(i) + "    ==========================="
           print "==================== Number of workers:" + str(k)+ "  ==========================="
     
           for j in range(a,b+1):
               print "--------- worker: "+ str(j)+ " -----------"
               managerIp = managers_ip[i]
               print "MANAGER-IP: ",managerIp
               subprocess.call(shlex.split("./build_containers.sh w " + str(j)))
               subprocess.call(shlex.split("./add_swarm_node.sh w " + str(j) + " " + w_token + " " + managerIp)) ## add worker to the swarm cluster
               if j >= nw: # we have created all the workers
                  break
               print "-------------------------------"
           i+=1
           a = b+1
           b = b+k
       ############# (4): Creating Services (running in docker in docker containers) ################
       subprocess.call(shlex.split("./create_services.sh c1  " + metadata["k4"] + " " + metadata["k3"] + " " + metadata["k5"] + " " + metadata["k6"] + " " + metadata["k7"] + " " + metadata["k8"]))
       
       #subprocess.call(shlex.split("./add_containers.sh c1  " + metadata["k4"] + " " + metadata["k3"] + " " + metadata["k5"] + " " + metadata["k6"] + " " + metadata["k7"] + " " + metadata["k8"]))
       ############# (5): Collection the log files from the emulated hosts (container) ##############
       #subprocess.call(shlex.split('./log_parser.sh ' + metadata["k1"] + ' ' + metadata["k2"]  + ' ' + metadata["k3"]))
       
       #logging.info(strftime("%Y-%m-%d %H:%M:%S") + "Finished Processing Data ......... ")

if __name__ == "__main__":

    # Run  Process 1
    cdf = cdf()
    cdf.start()

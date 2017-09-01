#!/usr/bin/python
import re
import sys
from helper import * 


#sname = sys.argv[1]
#snum = int(sys.argv[2])
#key1 = sys.argv[3]
#path_in = sys.argv[4]
#path_out = sys.argv[5]

cnum = 18 # number of containers (workers)
snum = 100 # number of services
#path_in = "/root/logs_" + str(cnum) + "_" + str(snum) + "/"
#path_out = "/root/results_" + str(cnum) + "_" + str(snum) + "/"
#key1 = "addSvcRecords"
#key2 = "web"
#path_in = path_out
#fin_name = "dind1.txt"
#fout_name = "dind1_parsed.txt"
#p = Methods()
#p.findPattern(path_in, path_out, fin_name, fout_name, key1, key2)
#p.SvcLogging(path_in, path_out, fout_name, key1, key2)
#p.location(path_in, path_out, fin_name, fout_name)


####### (1): Extract the svc log record from a list of services ##
path = "/root/overhead/"

f = open(path + "cpu_memory_" + str(cnum) + "_" + str(snum) + ".txt", "r")
ff = open(path + "overhead_" + str(cnum) + "_" + str(snum) + ".txt", "w")

count = 1
read = False
for line in f:
  if line.startswith("#"):
     read = True
     continue
  if read == True:
    temp = line.strip("\n").split(",")
    cpu_idle = float(temp[3])
    memory_free = float(temp[10])

    ff.write(str(count) + "\t" + str(cpu_idle)  + "\t" +  str(memory_free) + "\n")
    ff.flush()
    count = count + 1
f.close()
ff.close()
print "Done .................................."

#!/usr/bin/python
import re
import sys
from helper import * 



key1 =  sys.argv[1]  # e.g: "addSvcRecords"
key2 =  sys.argv[2]  # e.g: "web"
snum =  sys.argv[3]  # number of services
path_in = sys.argv[4]
path_out =  sys.arg[5]



####### (1): Extract the svc log record from a list of services #########
p = Methods()

fout_name = "svc_records.txt"

for i in range(1, snum + 1):
    p.SvcLogging(path_in, path_out, fout_name, key1, key2 + str(i))
print "Done extracting the service svc records......"


####### (2): Computing the svc record update latency #########
fin_name = fout_name
fout_name = "svc_latency.txt"

p.location(path_out, path_out, fin_name, fout_name)
print "Done computing svc records latency .........."

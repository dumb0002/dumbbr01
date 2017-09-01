#!/usr/bin/python
import re
import os
import sys
import datetime
import dateutil.parser
import time



class Methods:

    def __init__(self):
     
    def get_sec(self,time_str):
        h, m, s = time_str.split(':')
        return int(h) * 3600 + int(m) * 60 + float(s)


    def findPattern(self,path_in, path_out, fin_name, fout_name, key1, key2):

        fin = open(path_in+fin_name, "r")
        fout = open(path_out+fout_name, "w")

        for line in fin:
            searchObj1 = re.search(key1, line, re.M|re.I)
            searchObj2 = re.search(key2, line, re.M|re.I)

            if searchObj1 and searchObj2:
               fout.write(line)
               fout.flush()
        fin.close()
        fout.close()
        

    def SvcLogging(self,path_in, path_out, fout_name, key1, key2):

        pattern = {}

        ## find the patterns in the files
        test = 1
        for fname in os.listdir(path_in):
            fin = open(path_in + fname, "r")

            for line in fin:
                line = line.strip("\n")
                searchObj1 = re.search(r'\b' + key1 + r'\b', line, re.M|re.I)
                searchObj2 = re.search(r'\b' + key2 + r'\b', line, re.M|re.I)

                if searchObj1 and searchObj2:

                   if not key2 in pattern:
                      pattern[key2] = {}
                      pattern[key2][fname] = [line]
                   else:
                      if not fname in pattern[key2]:
                          pattern[key2][fname] = [line]
                      else:
                          pattern[key2][fname].append(line)
            fin.close()

          
        ## create the output file
        foutpath = path_out + fout_name
        if os.path.isfile(foutpath):
           fout = open(foutpath, "a")
        else:
           fout = open(foutpath, "w")
       
        for key in pattern:
            s = str(key) + "\t"

            for sim_host in pattern[key]:
                time_ls = pattern[key][sim_host]
                t = ";".join(str(i) for i in time_ls)
                s = s + sim_host + "::" + t + "|"

            fout.write(s + "\n")
            fout.flush()
        fout.close()

                    
                    
    def location(self,path_in, path_out, fin_name, fout_name): 

        fin = open(path_in + fin_name, "r")
        fout = open(path_out + fout_name, "w")

        test = {}
        for line in fin:
            temp = line.strip("\n").split("\t")
            service = temp[0]
            b = temp[1].split("|")
            size = len(b)

 
            svc_time_list = []   ## save the maximum svc latency per host
            for r in b[0:-1]:
                c = r.split("::")
                s = c[1].split(";")

                svc_t = 0
                hello = "" 
                for l in s:
                    h = l.split(" ")
                    temp = h[0].split("=")
                    p = temp[1].replace('"', '')
                    d = dateutil.parser.parse(p)
                    t = d.strftime('%H:%M:%S.%f')
                    t_sec = self.get_sec(t) 

                    if t_sec > svc_t: ## keeps track of the maximum svc latency per host
                       svc_t = t_sec
                     

                svc_time_list.append(svc_t)
            min_svc = min(svc_time_list)
            max_svc = max(svc_time_list)
            latency = max_svc - min_svc

            fout.write(service + "\t" + str(latency) + "\n")
            fout.flush()
        fin.close()
        fout.close()

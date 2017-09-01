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




class cdf (multiprocessing.Process):

  def __init__(self, cnum, snum):

        multiprocessing.Process.__init__(self)
        self.cnum = cnum
        self.snum = snum


  def run(self):

       path = "vm_21_100_results/"
       #path = "/root/vm_50_results/"
       #path = "/root/results_" + self.cnum + "_" + self.snum + "/"
       mypath = path

       f = open(path + "svc_latency.txt", "r")

       #-----------------------------------------------
          # Reading the data from the input filename
       #-----------------------------------------------
       dict_degree = {}
       basic_stats = []

       num =  0.0    # counts the number of records

       for line in f:

          temp = line.strip("\n").split("\t")
          degree = float(temp[1])
          num = num + 1
          basic_stats.append(degree)

          if degree in dict_degree:
              count = dict_degree[degree]

              count = count + 1
              dict_degree[degree] = count


          else:
              dict_degree[degree] = 1
       f.close()


       #------------------------------------------------
           # Calculating the cumulative probabilities
       #------------------------------------------------
       tuple_ls = sorted(dict_degree.items(), key=lambda x:x[0])
       com_prob = 0  # cumulative probability


       ff = open(mypath + "cdf_" + self.cnum + "_" + self.snum + ".txt", "w")


       for i in range(0, len(tuple_ls)):

           t =  tuple_ls[i]

           value = str(t[0])
           prob = t[1]/num

           com_prob = com_prob + prob
           n = str(round(com_prob, 8))


           ff.write(value + "\t" + n + "\n")
           ff.flush()

       ff.close()
       logging.info(strftime("%Y-%m-%d %H:%M:%S") + "Finished Processing Data")



if __name__ == "__main__":

    # Run  Process 1
    cdf = cdf (sys.argv[1], sys.argv[2])
    cdf.start()


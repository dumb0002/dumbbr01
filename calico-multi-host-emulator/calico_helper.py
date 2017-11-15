#!/usr/bin/python
import multiprocessing
import sys



class helper (multiprocessing.Process):

  def __init__(self, fname):

        multiprocessing.Process.__init__(self)
        self.fname = fname
 
  def run(self):
       
       f = open(self.fname, "r")

       for line in f:
           temp = line.strip("\n").split(" ")

           for s in temp:
               if "NODENAME" in s:
                   output = s.split("=")[1]
                   print output
       f.close()


if __name__ == "__main__":

    parser = helper (sys.argv[1])
    parser.start()

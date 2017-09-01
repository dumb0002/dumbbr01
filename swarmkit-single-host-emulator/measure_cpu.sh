#!/bin/bash

############## Dstat Commands ################
#dstat --time -c --top-cpu -m --top-mem
#dstat --top-cpu-adv --top-latency --top-mem
#dstat --time -c --top-cpu-adv -m --top-mem
##############################################


dstat --time -c  -m  --output /tmp/memory_cpu.txt 1 

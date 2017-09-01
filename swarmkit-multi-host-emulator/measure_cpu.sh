#!/bin/bash

############## Dstat Commands ################
#dstat --time -c --top-cpu -m --top-mem
#dstat --top-cpu-adv --top-latency --top-mem
#dstat --time -c --top-cpu-adv -m --top-mem
##############################################

rm -r /tmp/logs
mkdir /tmp/logs

ip=$(hostname -I | awk '{print $2}')

dstat --time -c  -m  --output /tmp/logs/memory_cpu_$ip.txt 1 

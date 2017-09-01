#!/bin/bash

nc=$1;  # total number of managers
nw=$2;  # total number of workers
ns=$3;  # total number of services

rm -r ~/logs_${nw}_${ns}
mkdir ~/logs_${nw}_${ns}
echo "created 'log' directory"
rm  -r ~/results_${nw}_${ns}
mkdir  ~/results_${nw}_${ns}
echo "created 'results' directory"

echo "sleeping for 120 (2 minutes) seconds before starting to collect the log files"
sleep 120

## (1): collect logs from manager nodes
for (( c=1; c<=$nc; c++))
do 
   docker logs c${c} >& ~/logs_${nw}_${ns}/c${c}.log
done

## (2): collect logs from worker nodes
for (( c=1; c<=$nw; c++))
do 
   docker logs w${c} >& ~/logs_${nw}_${ns}/w${c}.log
done

echo "Done collecting the logs files ......"

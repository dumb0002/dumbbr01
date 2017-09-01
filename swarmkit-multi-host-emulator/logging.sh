#!/bin/bash

nc=$1; # total number of containers (emulated hosts)

#rm -r /tmp/logs
#mkdir /tmp/logs
pkill dstat # kill the dstat process if it's running

echo "sleeping for 120 (2 minutes) seconds before starting to collect the log files"
#sleep 120

ip=$(hostname -I | awk '{print $2}')

## (1): collect logs from the emulated hosts
for (( c=1; c<=$nc; c++))
do 
   docker logs $ip-host${c} >& /tmp/logs/$ip-host${c}.log
done

echo "Done collecting the logs files ......"

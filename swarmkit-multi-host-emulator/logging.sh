#!/bin/bash

nc=$1; # total number of containers (emulated hosts)
eth=$2; # interface name

#rm -r /tmp/logs
#mkdir /tmp/logs
pkill dstat # kill the dstat process if it's running


ip=$(/sbin/ifconfig $eth | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
#ip=$(hostname -I | awk '{print $2}')


## (1): collect logs from the emulated hosts
for (( c=1; c<=$nc; c++))
do 
   docker logs $ip-host${c} >& /tmp/logs/$ip-host${c}.log
done

echo "Done collecting the logs files ......"

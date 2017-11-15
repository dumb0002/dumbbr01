eth=$1 # interface to be used

TOKEN=token-01
CLUSTER_STATE=new
IP=$(/sbin/ifconfig $eth | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
NAME_1=machine-1
HOST_1=$IP
CLUSTER=${NAME_1}=http://${HOST_1}:2380


#----------------------------
# Run this on each machine:
#----------------------------

# For machine 1
THIS_NAME=${NAME_1}
THIS_IP=${HOST_1}
/tmp/etcd-download-test/etcd --data-dir=data.etcd --name ${THIS_NAME} \
        --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${THIS_IP}:2380 \
        --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${THIS_IP}:2379,http://127.0.0.1:2379 \
        --initial-cluster ${CLUSTER} \
        --initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}  >& etcdv3.log &







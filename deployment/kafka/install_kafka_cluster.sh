#!/bin/bash

###############################################################################
#
# Install and start Kafka cluster
#
# Prerequisites:
#	  - Java is installed and JAVA_HOME env is configured
#   - Zookeeper is installed and started
#   - hostname is configured for every node
#	  - ssh login without password between all nodes is configured for both
#	    root and non-root user
#
# Note:
#   - This script must be executed on first node, e.g. bigdata01
#   - This script must be executed as root user
#   - This script is only tested on Ubuntu 18.04
#
###############################################################################
INSTALL_DIR=$1
KAFKA_NODES=($2)
KAFKA_USER_NAME=$3
KAFKA_GROUP_NAME=$4
DOWNLOAD_DIR=$5
KAFKA_HOME_DIR="$INSTALL_DIR/kafka"

echo "Downloading kafka..."
mkdir -p $DOWNLOAD_DIR
cd $DOWNLOAD_DIR
if [ ! -f kafka_*.tgz ]; then
	wget https://www.nic.funet.fi/pub/mirrors/apache.org/kafka/2.6.0/kafka_2.12-2.6.0.tgz
fi

if [ ! -f kafka_*.tgz ]; then
	echo "Download kafka failed, exit"
	exit 1
fi

mkdir -p $INSTALL_DIR
cd $INSTALL_DIR

echo "Unpacking kafka..."
rm -rf $KAFKA_HOME_DIR
cp /$DOWNLOAD_DIR/kafka_*.tgz ./
tar -zxvf kafka_*.tgz > /dev/null 2>&1
rm kafka_*.tgz
mv kafka* kafka

echo "Configuring environment..."
if [ `grep -c "export KAFKA_HOME=" /etc/profile` -eq 1 ];then
	echo "KAFKA_HOME environment variable is already configured"
else
	echo "export KAFKA_HOME=$KAFKA_HOME_DIR" >> /etc/profile
	echo "export PATH=\$PATH:\$KAFKA_HOME/bin" >> /etc/profile
	source /etc/profile
fi
echo $KAFKA_HOME

cd $KAFKA_HOME_DIR
mkdir logs

KAFKA_DATA_LOG_DIR=$KAFKA_HOME_DIR/logs

echo "Configuring server.properties..."
# bigdata01:2181,bigdata02:2181,bigdata03:2181
ZK_SERVERS=""
for node in ${KAFKA_NODES[@]}; do
  ZK_SERVERS="$ZK_SERVERS$node:2181,"
done
ZK_SERVERS=${ZK_SERVERS%?}

sed -i "/zookeeper.connect=/czookeeper.connect=$ZK_SERVERS" $KAFKA_HOME_DIR/config/server.properties
sed -i "/log.dirs=/clog.dirs=$KAFKA_DATA_LOG_DIR" $KAFKA_HOME_DIR/config/server.properties
echo "delete.topic.enable=true" >> $KAFKA_HOME_DIR/config/server.properties

# sync to other nodes
for ((i=1; i<${#KAFKA_NODES[@]}; i++)); do
	node=${KAFKA_NODES[$i]}
	echo "Configuring environment for $node..."
	rsync -az --delete /etc/profile $node:/etc/profile
	ssh $node "source /etc/profile"
	echo "Configuring kafka for $node..."
	rsync -az --delete $KAFKA_HOME_DIR $node:$INSTALL_DIR/
done

# set broker.id
sid=0
for node in ${KAFKA_NODES[@]}; do
	ssh $node "sed -i '/broker.id=/cbroker.id=$sid' $KAFKA_HOME_DIR/config/server.properties"
	sid=$((sid + 1))
done

# change owner
for node in ${KAFKA_NODES[@]}; do
	ssh $node "chown -R $KAFKA_USER_NAME:$KAFKA_GROUP_NAME $KAFKA_HOME_DIR"
done

# Start kafka on every node
for node in ${KAFKA_NODES[@]}; do
	echo "Starting kafka on $node..."
	ssh $node "su - $KAFKA_USER_NAME -c \"kafka-server-start.sh -daemon $KAFKA_HOME_DIR/config/server.properties\""
done

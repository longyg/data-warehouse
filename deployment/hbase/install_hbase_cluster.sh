#!/bin/bash
###############################################################################
#
# Install and start hbase 2.2.5 fully distributed cluster
#
# Prerequisites:
#   - Hadoop is installed and running
#	  - JDK is installed and JAVA_HOME env is configured
#   - External zookeeper cluster is used, so zookeeper cluster must be firstly
#     installed and running
#   - hostname is configured for every node
#	  - ssh login without password between all nodes is configured for both
#	    root and non-root user
#
# Note:
#   - This script must be executed on primary master node, e.g. bigdata01
#   - This script must be executed as root user
#   - This script is only tested on Ubuntu 18.04

# Cluster structure:
#   - First node is primary master
#   - Second node is backup master
#   - all nodes are region servers
#
###############################################################################
INSTALL_DIR=$1
HBASE_NODES=($2)
HBASE_USER_NAME=$3
HBASE_GROUP_NAME=$4
DOWNLOAD_DIR=$5
JAVA_HOME_DIR=$(echo $JAVA_HOME)
HBASE_HOME_DIR="$INSTALL_DIR/hbase"
HADOOP_HOME_DIR="$INSTALL_DIR/hadoop"

SCRIPT_DIR=$(dirname $(readlink -f "$0"))
MASTER_BACKUP_NODE=${HBASE_NODES[1]}

echo "Downloading hbase..."
mkdir -p $DOWNLOAD_DIR
cd $DOWNLOAD_DIR
if [ ! -f hbase-*.tar.gz ]; then
	wget http://mirror.netinch.com/pub/apache/hbase/2.2.5/hbase-2.2.5-bin.tar.gz
fi

if [ ! -f hbase-*.tar.gz ]; then
	echo "Download hbase failed, exit"
	exit 1
fi

mkdir -p $INSTALL_DIR
cd $INSTALL_DIR

echo "Unpacking hbase..."
rm -rf $HBASE_HOME_DIR
cp $DOWNLOAD_DIR/hbase-*.tar.gz ./
tar -zxvf hbase-*.tar.gz > /dev/null 2>&1
rm hbase-*.tar.gz
mv hbase* hbase

echo "Configuring environment..."
if [ `grep -c "export HBASE_HOME=" /etc/profile` -eq 1 ];then
	echo "HBASE_HOME environment variable is already configured"
else
	echo "export HBASE_HOME=$HBASE_HOME_DIR" >> /etc/profile
	echo "export PATH=\$PATH:\$HBASE_HOME/bin" >> /etc/profile
	source /etc/profile
fi
echo $HBASE_HOME

cd $HBASE_HOME
rm -rf conf/regionservers
for node in ${HBASE_NODES[@]}; do
	echo $node >> conf/regionservers
done

echo $MASTER_BACKUP_NODE > conf/backup-masters

echo "Configuring hbase-env.sh..."
echo "export JAVA_HOME=$JAVA_HOME_DIR" >> conf/hbase-env.sh
# use existing zk cluster instead of zk inside hbase
echo "export HBASE_MANAGES_ZK=false" >> conf/hbase-env.sh

echo "Configuring hbase-site.xml..."
cp -f $SCRIPT_DIR/hbase-site.xml $HBASE_HOME_DIR/conf/hbase-site.xml

echo "Copying HADOOP config files..."
cp -f $HADOOP_HOME_DIR/etc/hadoop/hdfs-site.xml $HBASE_HOME_DIR/conf/hdfs-site.xml
cp -f $HADOOP_HOME_DIR/etc/hadoop/core-site.xml $HBASE_HOME_DIR/conf/core-site.xml

#echo "Backup slf4j-log4j12 jar in hbase..."
#mv $HBASE_HOME/lib/client-facing-thirdparty/slf4j-log4j12-*.jar $HBASE_HOME/lib/client-facing-thirdparty/slf4j-log4j12.jar.bak

chown -R $HBASE_USER_NAME:$HBASE_GROUP_NAME $HBASE_HOME_DIR

for ((i=1; i<${#HBASE_NODES[@]}; i++)); do
	node=${HBASE_NODES[$i]}
	echo "Configuring environment for $node..."
	rsync -az --delete /etc/profile $node:/etc/profile
	ssh $node "source /etc/profile"
	echo "Configuring hbase for $node..."
	rsync -az --delete $HBASE_HOME_DIR $node:$INSTALL_DIR/
done

echo "Starting hbase cluster..."
su - $HBASE_USER_NAME -c "start-hbase.sh"
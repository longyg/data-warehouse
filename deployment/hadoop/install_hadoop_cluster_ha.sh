#!/bin/bash

###############################################################################
#
# Install and start hadoop 3.2.1 fully distributed cluster
# Also NameNode HA and ResourceManager HA are both enabled
#
# Prerequisites:
#	  - JDK is installed and JAVA_HOME env is configured
#   - Zookeeper cluster is running
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

HADOOP_NODES=("bigdata01" "bigdata02" "bigdata03")
HADOOP_USER_NAME="bigdata"
HADOOP_GROUP_NAME="bigdata"
JAVA_HOME_DIR=$(echo $JAVA_HOME)
INSTALL_DIR="/opt/software"
HADOOP_HOME_DIR="$INSTALL_DIR/hadoop"
HADOOP_ROOT_DIR="/opt"
HADOOP_DATA_DIR="$HADOOP_ROOT_DIR/hadoopdata"
HADOOP_JOURNALNODE_DATA_DIR="$HADOOP_ROOT_DIR/journalnode/data"
DOWNLOAD_DIR="/root/download"
SCRIPT_DIR=$(dirname $(readlink -f "$0"))

echo "Downloading hadoop..."
mkdir -p $DOWNLOAD_DIR
cd $DOWNLOAD_DIR
if [ ! -f hadoop-*.tar.gz ]; then
	wget http://us.mirrors.quenda.co/apache/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz
fi

if [ ! -f hadoop-*.tar.gz ]; then
	echo "Download hadoop failed, exit"
	exit 1
fi

mkdir -p $INSTALL_DIR
cd $INSTALL_DIR

echo "Unpacking hadoop..."
rm -rf $HADOOP_HOME_DIR
cp $DOWNLOAD_DIR/hadoop-*.tar.gz ./
tar -zxvf hadoop-*.tar.gz > /dev/null 2>&1
rm hadoop-*.tar.gz
mv hadoop* hadoop

echo "Configuring environment..."
if [ `grep -c "export HADOOP_HOME=" /etc/profile` -eq 1 ];then
	echo "HADOOP_HOME environment variable is already configured"
else
	echo "export HADOOP_HOME=$HADOOP_HOME_DIR" >> /etc/profile
	echo "export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin" >> /etc/profile
	source /etc/profile
fi
echo $HADOOP_HOME

echo "Configuring hadoop-env.sh..."
echo "export JAVA_HOME=$JAVA_HOME_DIR" >> $HADOOP_HOME_DIR/etc/hadoop/hadoop-env.sh
echo "export HDFS_NAMENODE_USER=$HADOOP_USER_NAME" >> $HADOOP_HOME_DIR/etc/hadoop/hadoop-env.sh
echo "export HDFS_DATANODE_USER=$HADOOP_USER_NAME" >> $HADOOP_HOME_DIR/etc/hadoop/hadoop-env.sh
echo "export HDFS_ZKFC_USER=$HADOOP_USER_NAME" >> $HADOOP_HOME_DIR/etc/hadoop/hadoop-env.sh
echo "export HDFS_JOURNALNODE_USER=$HADOOP_USER_NAME" >> $HADOOP_HOME_DIR/etc/hadoop/hadoop-env.sh

echo "Configuring core-site.xml..."
cp -f $SCRIPT_DIR/core-site.xml $HADOOP_HOME_DIR/etc/hadoop/core-site.xml

echo "Configuring hdfs-site.xml..."
cp -f $SCRIPT_DIR/hdfs-site.xml $HADOOP_HOME_DIR/etc/hadoop/hdfs-site.xml

echo "Configuring mapred-site.xml..."
cp -f $SCRIPT_DIR/mapred-site.xml $HADOOP_HOME_DIR/etc/hadoop/mapred-site.xml

echo "Configuring yarn-site.xml..."
cp -f $SCRIPT_DIR/yarn-site.xml $HADOOP_HOME_DIR/etc/hadoop/yarn-site.xml

echo "Configuring workers..."
rm -rf $HADOOP_HOME_DIR/etc/hadoop/workers
for node in ${HADOOP_NODES[@]}; do
	echo $node >> $HADOOP_HOME_DIR/etc/hadoop/workers
done

#for node in node2 node3; do
for ((i=1; i<${#HADOOP_NODES[@]}; i++)); do
	node=${HADOOP_NODES[$i]}
	echo "Configuring environment for $node..."
	rsync -az --delete /etc/profile $node:/etc/profile
	ssh $node "source /etc/profile"
	echo "Configuring hadoop for $node..."
	rsync -az --delete $HADOOP_HOME_DIR $node:$INSTALL_DIR/
done

for node in ${HADOOP_NODES[@]}; do
	ssh $node "chown -R $HADOOP_USER_NAME:$HADOOP_GROUP_NAME $HADOOP_HOME_DIR"
done

for node in ${HADOOP_NODES[@]}; do
	echo "Configuring data directory on $node..."
	ssh $node "rm -rf $HADOOP_DATA_DIR; mkdir -p $HADOOP_DATA_DIR; chown -R $HADOOP_USER_NAME:$HADOOP_GROUP_NAME $HADOOP_DATA_DIR"
	ssh $node "rm -rf $HADOOP_JOURNALNODE_DATA_DIR; mkdir -p $HADOOP_JOURNALNODE_DATA_DIR; chown -R $HADOOP_USER_NAME:$HADOOP_GROUP_NAME $HADOOP_JOURNALNODE_DATA_DIR"
	echo "Starting journalnode on $node..."
	ssh $node "su - $HADOOP_USER_NAME -c \"hdfs --daemon start journalnode\""
	ssh $node "jps"
done

for node in ${HADOOP_NODES[@]}; do
	ssh $node "rm -rf $HADOOP_DATA_DIR"
	ssh $node "mkdir -p $HADOOP_DATA_DIR"
	ssh $node "chown -R $HADOOP_USER_NAME:$HADOOP_GROUP_NAME $HADOOP_DATA_DIR"
done

echo "Formating namenode..."
su - $HADOOP_USER_NAME -c "hdfs namenode -format"

echo "Copying metadata to second namenode..."
node2=${HADOOP_NODES[1]}
rsync -az --delete $HADOOP_DATA_DIR $node2:$HADOOP_ROOT_DIR/

echo "Formating ZKFC..."
su - $HADOOP_USER_NAME -c "hdfs zkfc -formatZK"

echo "Starting hadoop cluster..."
su - $HADOOP_USER_NAME -c "start-all.sh"

for node in ${HADOOP_NODES[@]}; do
	echo "Starting mapreduce history server on $node..."
	ssh $node "su - $HADOOP_USER_NAME -c \"mapred --daemon start historyserver\""
	ssh $node "jps"
done












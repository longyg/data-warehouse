#!/bin/bash

###############################################################################
#
# Install and start hadoop 3.1.3 fully distributed cluster without HA
#
# Prerequisites:
#   - JDK is installed and JAVA_HOME env is configured
#   - hostname is configured for every node
#   - ssh login without password between all nodes is configured for both
#     root and non-root user
#
# Note:
#   - This script must be executed on first node, e.g. bigdata01
#   - This script must be executed as root user
#   - This script is only tested on Ubuntu 18.04
#
###############################################################################

INSTALL_DIR=$1
HADOOP_NODES=($2)
HADOOP_USER_NAME=$3
HADOOP_GROUP_NAME=$4
DOWNLOAD_DIR=$5
HADOOP_HOME_DIR="$INSTALL_DIR/hadoop"
JAVA_HOME_DIR=$(echo $JAVA_HOME)

SCRIPT_DIR=$(dirname $(readlink -f "$0"))

echo "Downloading hadoop..."
mkdir -p $DOWNLOAD_DIR
cd $DOWNLOAD_DIR
if [ ! -f hadoop-3.1.3.tar.gz ]; then
	wget https://archive.apache.org/dist/hadoop/common/hadoop-3.1.3/hadoop-3.1.3.tar.gz
fi

if [ ! -f hadoop-3.1.3.tar.gz ]; then
	echo "Download hadoop failed, exit"
	exit 1
fi

mkdir -p $INSTALL_DIR
cd $INSTALL_DIR

echo "Unpacking hadoop..."
rm -rf $HADOOP_HOME_DIR
cp $DOWNLOAD_DIR/hadoop-3.1.3.tar.gz ./
tar -zxvf hadoop-3.1.3.tar.gz > /dev/null 2>&1
rm hadoop-3.1.3.tar.gz
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
#echo "export HDFS_NAMENODE_USER=$HADOOP_USER_NAME" >> $HADOOP_HOME_DIR/etc/hadoop/hadoop-env.sh
#echo "export HDFS_DATANODE_USER=$HADOOP_USER_NAME" >> $HADOOP_HOME_DIR/etc/hadoop/hadoop-env.sh
#echo "export HDFS_SECONDARYNAMENODE_USER=$HADOOP_USER_NAME" >> $HADOOP_HOME_DIR/etc/hadoop/hadoop-env.sh
#echo "export YARN_RESOURCEMANAGER_USER=$HADOOP_USER_NAME" >> $HADOOP_HOME_DIR/etc/hadoop/hadoop-env.sh
#echo "export YARN_NODEMANAGER_USER=$HADOOP_USER_NAME" >> $HADOOP_HOME_DIR/etc/hadoop/hadoop-env.sh

echo "Configuring core-site.xml..."
cp -f $SCRIPT_DIR/core-site.xml $HADOOP_HOME_DIR/etc/hadoop/core-site.xml

echo "Configuring hdfs-site.xml..."
cp -f $SCRIPT_DIR/hdfs-site.xml $HADOOP_HOME_DIR/etc/hadoop/hdfs-site.xml

echo "Configuring mapred-site.xml..."
cp -f $SCRIPT_DIR/mapred-site.xml $HADOOP_HOME_DIR/etc/hadoop/mapred-site.xml

echo "Configuring yarn-site.xml..."
cp -f $SCRIPT_DIR/yarn-site.xml $HADOOP_HOME_DIR/etc/hadoop/yarn-site.xml

echo "Copying lzo jar..."
cp -f $SCRIPT_DIR/hadoop-lzo-*.jar $HADOOP_HOME_DIR/share/hadoop/common/hadoop-lzo.jar

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

echo "Formating namenode..."
su - $HADOOP_USER_NAME -c "hdfs namenode -format"

echo "Starting HDFS..."
su - $HADOOP_USER_NAME -c "start-dfs.sh"

echo "Starting YARN..."
ssh ${HADOOP_NODES[1]} "su - $HADOOP_USER_NAME -c \"source /etc/profile; start-yarn.sh\""

echo "Starting history server..."
su - $HADOOP_USER_NAME -c "mapred --daemon start historyserver"



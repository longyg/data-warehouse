#!/bin/bash

###############################################################################
#
# Install and start flume 1.9.0
#
# Prerequisites:
#	  - JDK is installed and JAVA_HOME env is configured
#   - hostname is configured for every node
#	  - ssh login without password between all nodes is configured for both
#	    root and non-root user
#
# Note:
#   - This script must be executed on first flume node, e.g. bigdata01
#   - This script must be executed as root user
#   - This script is only tested on Ubuntu 18.04
#
###############################################################################

# only install on two nodes
INSTALL_DIR=$1
FLUME_NODES=($2)
FLUME_USER_NAME=$3
FLUME_GROUP_NAME=$4
DOWNLOAD_DIR=$5
JAVA_HOME_DIR=$(echo $JAVA_HOME)
FLUME_HOME_DIR="$INSTALL_DIR/flume"
SCRIPT_DIR=$(dirname $(readlink -f "$0"))

echo "Downloading flume..."
mkdir -p $DOWNLOAD_DIR
cd $DOWNLOAD_DIR
if [ ! -f apache-flume-*.tar.gz ]; then
	wget https://www.nic.funet.fi/pub/mirrors/apache.org/flume/1.9.0/apache-flume-1.9.0-bin.tar.gz
fi

if [ ! -f apache-flume-*.tar.gz ]; then
	echo "Download flume failed, exit"
	exit 1
fi

mkdir -p $INSTALL_DIR
cd $INSTALL_DIR

echo "Unpacking flume..."
rm -rf $FLUME_HOME_DIR
cp $DOWNLOAD_DIR/apache-flume-*.tar.gz ./
tar -zxvf apache-flume-*.tar.gz > /dev/null 2>&1
rm apache-flume-*.tar.gz
mv apache-flume* flume

echo "Configuring environment..."
if [ `grep -c "export FLUME_HOME=" /etc/profile` -eq 1 ];then
	echo "FLUME_HOME environment variable is already configured"
else
	echo "export FLUME_HOME=$FLUME_HOME_DIR" >> /etc/profile
	echo "export PATH=\$PATH:\$FLUME_HOME/bin" >> /etc/profile
	source /etc/profile
fi
echo $FLUME_HOME

echo "Configuring flume-env.sh..."
mv $FLUME_HOME_DIR/conf/flume-env.sh.template $FLUME_HOME_DIR/conf/flume-env.sh
echo "export JAVA_HOME=$JAVA_HOME_DIR" >> $FLUME_HOME_DIR/conf/flume-env.sh


# configure on other flume node
for ((i=1; i<${#FLUME_NODES[@]}; i++)); do
	node=${FLUME_NODES[$i]}
	echo "Configuring environment for $node..."
	rsync -az --delete /etc/profile $node:/etc/profile
	ssh $node "source /etc/profile"
	echo "Configuring flume for $node..."
	rsync -az --delete $FLUME_HOME_DIR $node:$INSTALL_DIR/
done

for node in ${FLUME_NODES[@]}; do
	ssh $node "chown -R $FLUME_USER_NAME:$FLUME_GROUP_NAME $FLUME_HOME_DIR"
done












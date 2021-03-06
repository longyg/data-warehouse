#!/bin/bash
###############################################################################
#
# Install Spark 3.0.x with local mode
#
# Prerequisites:
#   - JDK is installed and JAVA_HOME env is configured
#   - hostname is configured for every node
#   - ssh login without password between all nodes is configured for both
#	    root and non-root user
#
# Note:
#   - This script must be executed on first namenode
#   - This script must be executed as root user
#   - This script is only tested on Ubuntu 18.04
#
###############################################################################
INSTALL_DIR=$1
SPARK_USER_NAME=$2
SPARK_GROUP_NAME=$3
DOWNLOAD_DIR=$4
JAVA_HOME_DIR=$(echo $JAVA_HOME)
SPARK_HOME_DIR="$INSTALL_DIR/spark"
HADOOP_HOME_DIR="$INSTALL_DIR/hadoop"

echo "Downloading spark..."
mkdir -p $DOWNLOAD_DIR
cd $DOWNLOAD_DIR
if [ ! -f spark-*.tgz ]; then
	wget http://mirror.netinch.com/pub/apache/spark/spark-3.0.1/spark-3.0.1-bin-hadoop3.2.tgz
fi

if [ ! -f spark-*.tgz ]; then
	echo "Download spark failed, exit"
	exit 1
fi

mkdir -p $INSTALL_DIR
cd $INSTALL_DIR

echo "Unpacking spark..."
rm -rf $SPARK_HOME_DIR
cp $DOWNLOAD_DIR/spark-*.tgz ./
tar -zxvf spark-*.tgz > /dev/null 2>&1
rm spark-*.tgz
mv spark* spark

echo "Configuring environment..."
if [ `grep -c "export SPARK_HOME=" /etc/profile` -eq 1 ];then
	echo "SPARK_HOME environment variable is already configured"
else
	echo "export SPARK_HOME=$SPARK_HOME_DIR" >> /etc/profile
	echo "export PATH=\$PATH:\$SPARK_HOME/bin" >> /etc/profile
	source /etc/profile
fi
echo $SPARK_HOME

echo "Configuring spark-env.sh..."
mv $SPARK_HOME_DIR/conf/spark-env.sh.template $SPARK_HOME_DIR/conf/spark-env.sh
echo "export HADOOP_CONF_DIR=$HADOOP_HOME_DIR/etc/hadoop" >> $SPARK_HOME_DIR/conf/spark-env.sh

chown -R $SPARK_USER_NAME:$SPARK_GROUP_NAME $SPARK_HOME_DIR
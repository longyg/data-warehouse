#!/bin/bash
###############################################################################
#
# Install Sqoop 1.4.7
#
# Prerequisites:
#   - Hadoop is installed and running
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
SQOOP_USER_NAME=$2
SQOOP_GROUP_NAME=$3
DOWNLOAD_DIR=$4
JAVA_HOME_DIR=$(echo $JAVA_HOME)
SQOOP_HOME_DIR="$INSTALL_DIR/sqoop"
SCRIPT_DIR=$(dirname $(readlink -f "$0"))
HADOOP_HOME_DIR="$INSTALL_DIR/hadoop"
HIVE_HOME_DIR="$INSTALL_DIR/hive"
ZOOKEEPER_HOME_DIR="$INSTALL_DIR/zookeeper"
HBASE_HOME_DIR="$INSTALL_DIR/hbase"

echo "Downloading sqoop..."
mkdir -p $DOWNLOAD_DIR
cd $DOWNLOAD_DIR
if [ ! -f sqoop-*.tar.gz ]; then
	wget https://www.nic.funet.fi/pub/mirrors/apache.org/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz
fi

if [ ! -f sqoop-*.tar.gz ]; then
	echo "Download sqoop failed, exit"
	exit 1
fi

mkdir -p $INSTALL_DIR
cd $INSTALL_DIR

echo "Unpacking sqoop..."
rm -rf $SQOOP_HOME_DIR
cp $DOWNLOAD_DIR/sqoop-*.tar.gz ./
tar -zxvf sqoop-*.tar.gz > /dev/null 2>&1
rm sqoop-*.tar.gz
mv sqoop* sqoop

echo "Configuring environment..."
if [ `grep -c "export SQOOP_HOME=" /etc/profile` -eq 1 ];then
	echo "SQOOP_HOME environment variable is already configured"
else
	echo "export SQOOP_HOME=$SQOOP_HOME_DIR" >> /etc/profile
	echo "export PATH=\$PATH:\$SQOOP_HOME/bin" >> /etc/profile
	source /etc/profile
fi
echo $SQOOP_HOME

cd $SQOOP_HOME

echo "Configuring sqoop-env.sh..."
mv $SQOOP_HOME_DIR/conf/sqoop-env-template.sh $SQOOP_HOME_DIR/conf/sqoop-env.sh
echo "export HADOOP_COMMON_HOME=$HADOOP_HOME_DIR" >> $SQOOP_HOME_DIR/conf/sqoop-env.sh
echo "export HADOOP_MAPRED_HOME=$HADOOP_HOME_DIR" >> $SQOOP_HOME_DIR/conf/sqoop-env.sh
echo "export HIVE_HOME=$HIVE_HOME_DIR" >> $SQOOP_HOME_DIR/conf/sqoop-env.sh
echo "export ZOOKEEPER_HOME=$ZOOKEEPER_HOME_DIR" >> $SQOOP_HOME_DIR/conf/sqoop-env.sh
echo "export ZOOCFGDIR=$ZOOKEEPER_HOME_DIR/conf" >> $SQOOP_HOME_DIR/conf/sqoop-env.sh
echo "export HBASE_HOME=$HBASE_HOME_DIR" >> $SQOOP_HOME_DIR/conf/sqoop-env.sh

echo "Copying mysql driver..."
cp -f $SCRIPT_DIR/*.jar $SQOOP_HOME_DIR/lib/

chown -R $SQOOP_USER_NAME:$SQOOP_GROUP_NAME $SQOOP_HOME_DIR

su - $SQOOP_USER_NAME -c "sqoop version"
#!/usr/bin/env bash

###############################################################################
#
# Install phoenix and configure HBase with phoenix
#
# Prerequisites:
#   - HBase is installed
#
# Note:
#   - Phoenix will only be installed on one node
#   - The recompiled phoenix will be used which is supporting HBase 2.2.5
#   - This script is only tested on Ubuntu 18.04
#
###############################################################################
INSTALL_DIR=$1
HBASE_NODES=($2)
PHOENIX_USER_NAME=$3
PHOENIX_GROUP_NAME=$4
DOWNLOAD_DIR=$5
PHOENIX_HOME_DIR="$INSTALL_DIR/phoenix"
HBASE_HOME_DIR="$INSTALL_DIR/hbase"

echo "Downloading phoenix..."
mkdir -p $DOWNLOAD_DIR
cd $DOWNLOAD_DIR
if [ ! -f phoenix-*.tar.gz ]; then
	wget https://github.com/longyg/study/releases/download/Phoenix-5.1_HBase-2.2.5/phoenix-5.1.0-SNAPSHOT.tar.gz
fi

if [ ! -f phoenix-*.tar.gz ]; then
	echo "Download phoenix failed, exit"
	exit 1
fi

mkdir -p $INSTALL_DIR
cd $INSTALL_DIR

echo "Unpacking phoenix..."
rm -rf $PHOENIX_HOME_DIR
cp $DOWNLOAD_DIR/phoenix-*.tar.gz ./
tar -zxvf phoenix-*.tar.gz > /dev/null 2>&1
rm phoenix-*.tar.gz
mv phoenix* phoenix

echo "Configuring environment..."
if [ `grep -c "export PHOENIX_HOME=" /etc/profile` -eq 1 ];then
	echo "PHOENIX_HOME environment variable is already configured"
else
	echo "export PHOENIX_HOME=$PHOENIX_HOME_DIR" >> /etc/profile
	echo "export PATH=\$PATH:\$PHOENIX_HOME/bin" >> /etc/profile
	source /etc/profile
fi
echo $PHOENIX_HOME

chown -R $PHOENIX_USER_NAME:$PHOENIX_GROUP_NAME $PHOENIX_HOME_DIR

cd $PHOENIX_HOME

echo "Configuring hbase..."
cp -f phoenix-server-*.jar $HBASE_HOME_DIR/lib
cp -f phoenix-hbase-compat-2.2.*.jar $HBASE_HOME_DIR/lib

for ((i=1; i<${#HBASE_NODES[@]}; i++)); do
	node=${HBASE_NODES[$i]}
	echo "Configuring hbase for $node..."
	rsync -az --delete $HBASE_HOME_DIR/lib/phoenix-*.jar $node:$HBASE_HOME_DIR/lib
done

echo "Restarting hbase cluster..."
su - $PHOENIX_USER_NAME -c "stop-hbase.sh; sleep 2; start-hbase.sh"
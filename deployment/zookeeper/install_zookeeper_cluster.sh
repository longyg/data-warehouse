#!/bin/bash

###############################################################################
#
# Install and start Zookeeper cluster
#
# Prerequisites:
#	  - Java is installed and JAVA_HOME env is configured
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
ZK_NODES=($2)
ZK_USER_NAME=$3
ZK_GROUP_NAME=$4
DOWNLOAD_DIR=$5
ZK_HOME_DIR="$INSTALL_DIR/zookeeper"

echo "Downloading zookeeper..."
mkdir -p $DOWNLOAD_DIR
cd $DOWNLOAD_DIR
if [ ! -f apache-zookeeper-*.tar.gz ]; then
	wget https://www.nic.funet.fi/pub/mirrors/apache.org/zookeeper/zookeeper-3.5.8/apache-zookeeper-3.5.8-bin.tar.gz
fi

if [ ! -f apache-zookeeper-*.tar.gz ]; then
	echo "Download zookeeper failed, exit"
	exit 1
fi

mkdir -p $INSTALL_DIR
cd $INSTALL_DIR

echo "Unpacking zookeeper..."
rm -rf $ZK_HOME_DIR
cp /$DOWNLOAD_DIR/apache-zookeeper-*.tar.gz ./
tar -zxvf apache-zookeeper-*.tar.gz > /dev/null 2>&1
rm apache-zookeeper-*.tar.gz
mv apache-zookeeper* zookeeper

echo "Configuring environment..."
if [ `grep -c "export ZOOKEEPER_HOME=" /etc/profile` -eq 1 ];then
	echo "ZOOKEEPER_HOME environment variable is already configured"
else
	echo "export ZOOKEEPER_HOME=$ZK_HOME_DIR" >> /etc/profile
	echo "export PATH=\$PATH:\$ZOOKEEPER_HOME/bin" >> /etc/profile
	source /etc/profile
fi
echo $ZOOKEEPER_HOME

cd $ZK_HOME_DIR
mkdir data; mkdir logs

ZK_DATA_DIR=$ZK_HOME_DIR/data
ZK_DATA_LOG_DIR=$ZK_HOME_DIR/logs

cat <<EOF >$ZK_HOME_DIR/conf/zoo.cfg
# tickTime表示服务器之间或客户端与服务器之间心跳的时间间隔，单位为毫秒
tickTime=2000
# follower与leader的初始连接心跳数
initLimit=10
# follower与leader请求和应答的最大心跳数
syncLimit=5
# 快照数据保存目录
dataDir=$ZK_DATA_DIR
# 日志保存目录
dataLogDir=$ZK_DATA_LOG_DIR
# 客户端连接端口
clientPort=2181
# 客户端最大连接数,默认为60个
maxClientCnxns=60
# 默认为false，设置成true，zk将监听所有可用ip地址的连接
quorumListenOnAllIPs=false
EOF

# 服务器节点配置，格式为：
# server.<myid>=<host>:<leader和follower通信端口>:<选举端口>(observer节点最后加上:observer )
# 如：
# server.1=node1:2888:3888
# server.2=node2:2888:3888
# server.3=node3:2888:3888
sid=1
for node in ${ZK_NODES[@]}; do
	echo "server.$sid=$node:2888:3888" >> $ZK_HOME_DIR/conf/zoo.cfg
	sid=$((sid + 1))
done

#echo 10 > $ZK_DATA_DIR/myid

#chown -R $ZK_USER_NAME:$ZK_GROUP_NAME $ZK_HOME_DIR

# config followers
for ((i=1; i<${#ZK_NODES[@]}; i++)); do
	node=${ZK_NODES[$i]}
	echo "Configuring environment for $node..."
	rsync -az --delete /etc/profile $node:/etc/profile
	ssh $node "source /etc/profile"
	echo "Configuring zookeeper for $node..."
	rsync -az --delete $ZK_HOME_DIR $node:$INSTALL_DIR/
done

# create myid file for each node
#ssh node2 "echo 1 > $ZK_DATA_DIR/myid"
#ssh node3 "echo 2 > $ZK_DATA_DIR/myid"
sid=1
for node in ${ZK_NODES[@]}; do
	ssh $node "echo $sid > $ZK_DATA_DIR/myid"
	sid=$((sid + 1))
done

# change owner
for node in ${ZK_NODES[@]}; do
	ssh $node "chown -R $ZK_USER_NAME:$ZK_GROUP_NAME $ZK_HOME_DIR"
done

# Start zookeeper on every node
for node in ${ZK_NODES[@]}; do
	echo "Starting zookeeper on $node..."
	ssh $node "su - $ZK_USER_NAME -c \"zkServer.sh start\""
done
#!/usr/bin/env bash

# start or stop zookeeper cluster
# It can be executed on any one node of the cluster with non-root user

# zk.sh start|stop|status

ZK_NODES="bigdata01 bigdata02 bigdata03"
ZK_HOME="/opt/software/zookeeper"

case $1 in
"start") {
	for node in $ZK_NODES; do
		echo "Starting zookeeper on $node..."
		ssh $node "$ZK_HOME/bin/zkServer.sh start"
	done
};;
"stop") {
	for node in $ZK_NODES; do
		echo "Starting zookeeper on $node..."
		ssh $node "$ZK_HOME/bin/zkServer.sh stop"
	done
};;
"status") {
	for node in $ZK_NODES; do
		echo "Starting zookeeper on $node..."
		ssh $node "$ZK_HOME/bin/zkServer.sh status"
	done
};;
esac

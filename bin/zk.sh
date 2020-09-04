#!/usr/bin/env bash

###############################################################################
#
# start, stop or check status of zookeeper cluster
#
# Usage:
#      zk.sh start|stop|status
#
###############################################################################

ZK_NODES=$2

case $1 in
"start") {
	for i in $ZK_NODES; do
		echo "--------------- 启动 Zookeeper on $i ------------------"
		ssh $i "source /etc/profile; zkServer.sh start"
	done
};;
"stop") {
	for i in $ZK_NODES; do
		echo "--------------- 停止 Zookeeper on $i ------------------"
		ssh $i "source /etc/profile; zkServer.sh stop"
	done
};;
"status") {
	for i in $ZK_NODES; do
		echo "--------------- 检查 Zookeeper 状态 on $i ------------------"
		ssh $i "source /etc/profile; zkServer.sh status"
	done
};;
esac

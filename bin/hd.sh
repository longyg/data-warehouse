#!/usr/bin/env bash

###############################################################################
#
# Start or stop hadoop cluster
#
# Usage:
#      hd.sh start|stop|status nodes
#
###############################################################################

HADOOP_NODES=$2

case $1 in
"start") {
	echo "--------------- 启动 Hadoop ------------------"
	start-all.sh
	for node in ${HADOOP_NODES[@]}; do
		echo "--------------- 启动 mapreduce history server on $node ---------------"
		ssh $node "source /etc/profile; mapred --daemon start historyserver"
	done
};;
"stop") {
	for node in ${HADOOP_NODES[@]}; do
		echo "--------------- 停止 mapreduce history server on $node ---------------"
		ssh $node "source /etc/profile; mapred --daemon stop historyserver"
	done
	stop-all.sh
};;
"status") {
	xcall "jps | grep -i -E \"NameNode|DataNode|JournalNode|DFSZKFailoverController|ResourceManager|NodeManager|JobHistoryServer\""
}
esac
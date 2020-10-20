#!/usr/bin/env bash

###############################################################################
#
# Start or stop hadoop cluster
#
# Usage:
#      hd.sh <start|stop|status> <nodes>
#
###############################################################################

HADOOP_NODES=$2

case $1 in
"start") {
	echo "================= 启动 Hadoop 集群 ================="
	echo "------------- 启动 HDFS -------------"
	ssh bigdata01 "/opt/software/hadoop/sbin/start-dfs.sh"
	echo "------------- 启动 YARN -------------"
	ssh bigdata02 "/opt/software/hadoop/sbin/start-yarn.sh"
	echo "------------- 启动 history server -------------"
	ssh bigdata01 "/opt/software/hadoop/bin/mapred --daemon start historyserver"
};;
"stop") {
	echo "================= 关闭 Hadoop 集群 ================="
	echo "------------- 关闭 history server -------------"
	ssh bigdata01 "/opt/software/hadoop/bin/mapred --daemon stop historyserver"
	echo "------------- 关闭 YARN -------------"
	ssh bigdata02 "/opt/software/hadoop/sbin/stop-yarn.sh"
	echo "------------- 关闭 HDFS -------------"
	ssh bigdata01 "/opt/software/hadoop/sbin/stop-dfs.sh"
};;
"status") {
	echo "================= 检查 Hadoop 集群状态================="
	xcall "jps | grep -i -E \"NameNode|DataNode|JournalNode|DFSZKFailoverController|ResourceManager|NodeManager|JobHistoryServer\""
}
esac
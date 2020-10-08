#!/usr/bin/env bash

###############################################################################
#
# Start or stop hiveserver2
#
# Usage:
#      hv.sh start|stop|status node
#
###############################################################################

HIVE_NODE=$2

case $1 in
"start") {
	echo "--------------- 启动 hiveserver2 on $HIVE_NODE  ------------------"
	ssh $HIVE_NODE "source /etc/profile; nohup hive --service hiveserver2 >/dev/null 2>&1 &"
};;
"stop") {
	echo "--------------- 停止 hiveserver2 on $HIVE_NODE  ------------------"
	ssh $HIVE_NODE "ps -ef | grep org.apache.hive.service.server.HiveServer2 | grep -v grep | awk '{print \$2}' | xargs -n1 kill -9"
};;
"status") {
	xcall "jps | grep -i RunJar"
}
esac
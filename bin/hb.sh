#!/usr/bin/env bash

###############################################################################
#
# Start or stop hbase
#
# Usage:
#      hb.sh <start|stop|status>
#
###############################################################################
case $1 in
"start") {
	echo "--------------- 启动 HBase  ------------------"
	start-hbase.sh
};;
"stop") {
	echo "--------------- 停止 HBase  ------------------"
	stop-hbase.sh
};;
"status") {
	echo "--------------- 检查 HBase 状态 ------------------"
	xcall "jps | grep -i -E \"HMaster|HRegionServer\""
}
esac
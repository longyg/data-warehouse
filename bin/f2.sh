#!/usr/bin/env bash

#########################################
#
# Start or stop flume log collection
#
# Usage:
#      f1.sh start|stop
#
#########################################

FLUME_NODES="bigdata03"
FLUME_HOME=/opt/software/flume
FLUME_BIN_DIR=$FLUME_HOME/bin
FLUME_CONF_DIR=$FLUME_HOME/conf
CONF_FILE=store-log-flume.conf
FLUME_LOG_DIR=$FLUME_HOME/logs

case $1 in
"start") {
	for i in $FLUME_NODES; do
		echo "--------------- 启动 $i 存储日志flume -----------------"
		ssh $i "mkdir -p $FLUME_LOG_DIR; nohup $FLUME_BIN_DIR/flume-ng agent --conf $FLUME_CONF_DIR/ --name a1 --conf-file $FLUME_CONF_DIR/$CONF_FILE -Dflume.root.logger=INFO,LOGFILE >> $FLUME_LOG_DIR/store-log.log 2>&1 &"
	done
};;
"stop") {
	for i in $FLUME_NODES; do
		echo "--------------- 停止 $i 存储日志flume -----------------"
		ssh $i "ps -ef | grep $CONF_FILE | grep -v grep | awk '{print \$2}' | xargs kill"
	done
};;
esac
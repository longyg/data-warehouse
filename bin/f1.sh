#!/usr/bin/env bash

#########################################
#
# 启动或停止用户行为日志收集flume
#
# - 从日志文件收集用户行为日志，并存储到kafka topic中
#
# Usage:
#      f1.sh <start|stop>
#
#########################################

FLUME_NODES="bigdata01 bigdata02"
FLUME_HOME=/opt/software/flume
FLUME_BIN_DIR=$FLUME_HOME/bin
FLUME_CONF_DIR=$FLUME_HOME/conf
CONF_FILE=file-flume-kafka.conf
FLUME_LOG_DIR=$FLUME_HOME/logs

case $1 in
"start") {
	for i in $FLUME_NODES; do
		echo "--------------- 启动 $i 日志采集flume -----------------"
		ssh $i "mkdir -p $FLUME_LOG_DIR; nohup $FLUME_BIN_DIR/flume-ng agent --conf $FLUME_CONF_DIR/ --name a1 --conf-file $FLUME_CONF_DIR/$CONF_FILE -Dflume.root.logger=INFO,LOGFILE >$FLUME_LOG_DIR/log-collection.log 2>&1 &"
	done
};;
"stop") {
	for i in $FLUME_NODES; do
		echo "--------------- 停止 $i 日志采集flume -----------------"
		ssh $i "ps -ef | grep $CONF_FILE | grep -v grep | awk '{print \$2}' | xargs -n1 kill -9"
	done
};;
esac
#!/usr/bin/env bash

#########################################
#
# Start or stop kafka cluster
#
# Usage:
#      kf.sh start|stop
#
#########################################

KAFKA_NODES="bigdata01 bigdata02 bigdata03"
KAFKA_HOME_DIR=/opt/software/kafka

case $1 in
"start") {
	for i in $KAFKA_NODES; do
		echo "--------------- 启动 $i Kafka ------------------"
		ssh $i "$KAFKA_HOME_DIR/bin/kafka-server-start.sh -daemon $KAFKA_HOME_DIR/config/server.properties"
	done
};;
"stop") {
	for i in $KAFKA_NODES; do
		echo "--------------- 停止 $i Kafka ------------------"
		ssh $i "$KAFKA_HOME_DIR/bin/kafka-server-stop.sh stop"
	done
};;
esac
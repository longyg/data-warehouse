#!/usr/bin/env bash

###############################################################################
#
# Start or stop kafka cluster
#
# Usage:
#      kf.sh start|stop|status nodes
#
###############################################################################

KAFKA_NODES=$2
KAFKA_HOME_DIR=/opt/software/kafka

case $1 in
"start") {
	for i in $KAFKA_NODES; do
		echo "--------------- 启动 Kafka on $i ------------------"
		ssh $i "source /etc/profile; kafka-server-start.sh -daemon $KAFKA_HOME_DIR/config/server.properties"
	done
};;
"stop") {
	for i in $KAFKA_NODES; do
		echo "--------------- 停止 Kafka on $i ------------------"
		ssh $i "source /etc/profile; kafka-server-stop.sh stop"
	done
};;
"status") {
	xcall "jps | grep -i kafka"
}
esac
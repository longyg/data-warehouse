#!/usr/bin/env bash

###############################################################################
#
# Orchestration script for installation of bigdata frameworks
#
# Usage:
#      install.sh all|zookeepr|hadoop|hbase|hive|kafka|flume
# Note:
#      - This script must be running as root user
#      - This script must be running on first node of the cluster,
#        e.g., bigdata01
#
###############################################################################

CUR_DIR=$(cd `dirname $0`; pwd)
INSTALL_DIR="/opt/software"
CLUSTER_NODES="bigdata01 bigdata02 bigdata03"
USER_NAME="bigdata"
GROUP_NAME="bigdata"
DOWNLOAD_DIR="/root/download"

mkdir -p $INSTALL_DIR

case $1 in
"flume") {
  $CUR_DIR/flume/install_flume.sh
};;
"hadoop") {
  $CUR_DIR/hadoop/install_hadoop_cluster_ha.sh
};;
"hbase") {
  $CUR_DIR/hbase/install_hbase_cluster.sh
};;
"hive") {
  $CUR_DIR/hive/install_hive.sh
};;
"kafka") {
  $CUR_DIR/kafka/install_kafka_cluster.sh
};;
"zookeeper") {
  $CUR_DIR/zookeeper/install_zookeeper_cluster.sh $INSTALL_DIR $CLUSTER_NODES $USER_NAME $GROUP_NAME $DOWNLOAD_DIR
};;
"all") {
  $CUR_DIR/zookeeper/install_zookeeper_cluster.sh $INSTALL_DIR $CLUSTER_NODES $USER_NAME $GROUP_NAME $DOWNLOAD_DIR
  $CUR_DIR/hadoop/install_hadoop_cluster_ha.sh
  $CUR_DIR/hbase/install_hbase_cluster.sh
  $CUR_DIR/hive/install_hive.sh
  $CUR_DIR/kafka/install_kafka_cluster.sh
  $CUR_DIR/flume/install_flume.sh
};;
esac

for node in $CLUSTER_NODES; do
  ssh $node "chown -R $USER_NAME:$GROUP_NAME $INSTALL_DIR"
done


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
#      - If install each framework one by one, please ensure the installation
#        order that the dependent framework must be firstly installed.
#        Zookeeper should be firstly installed because Hadoop/HBase/Kafka depends
#        on it. HBase and Hive depends on Hadoop.
#        Phoenix must be installed after HBase installed.
#        Before install Hive, MySQL must be installed and meta database must
#        be created.
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
  $CUR_DIR/flume/install_flume.sh $INSTALL_DIR "$CLUSTER_NODES" $USER_NAME $GROUP_NAME $DOWNLOAD_DIR
};;
"hadoop") {
  $CUR_DIR/hadoop/install_hadoop_cluster_ha.sh $INSTALL_DIR "$CLUSTER_NODES" $USER_NAME $GROUP_NAME $DOWNLOAD_DIR
};;
"hbase") {
  $CUR_DIR/hbase/install_hbase_cluster.sh $INSTALL_DIR "$CLUSTER_NODES" $USER_NAME $GROUP_NAME $DOWNLOAD_DIR
};;
"hive") {
  $CUR_DIR/hive/install_hive.sh $INSTALL_DIR $USER_NAME $GROUP_NAME $DOWNLOAD_DIR
};;
"kafka") {
  $CUR_DIR/kafka/install_kafka_cluster.sh $INSTALL_DIR "$CLUSTER_NODES" $USER_NAME $GROUP_NAME $DOWNLOAD_DIR
};;
"phoenix") {
	$CUR_DIR/phoenix/install_phoenix.sh $INSTALL_DIR "$CLUSTER_NODES" $USER_NAME $GROUP_NAME $DOWNLOAD_DIR
};;
"zookeeper") {
  $CUR_DIR/zookeeper/install_zookeeper_cluster.sh $INSTALL_DIR "$CLUSTER_NODES" $USER_NAME $GROUP_NAME $DOWNLOAD_DIR
};;
"all") {
  $CUR_DIR/zookeeper/install_zookeeper_cluster.sh $INSTALL_DIR "$CLUSTER_NODES" $USER_NAME $GROUP_NAME $DOWNLOAD_DIR
  $CUR_DIR/hadoop/install_hadoop_cluster_ha.sh $INSTALL_DIR "$CLUSTER_NODES" $USER_NAME $GROUP_NAME $DOWNLOAD_DIR
  $CUR_DIR/hbase/install_hbase_cluster.sh $INSTALL_DIR "$CLUSTER_NODES" $USER_NAME $GROUP_NAME $DOWNLOAD_DIR
  $CUR_DIR/phoenix/install_phoenix.sh $INSTALL_DIR "$CLUSTER_NODES" $USER_NAME $GROUP_NAME $DOWNLOAD_DIR
  $CUR_DIR/hive/install_hive.sh $INSTALL_DIR $USER_NAME $GROUP_NAME $DOWNLOAD_DIR
  $CUR_DIR/kafka/install_kafka_cluster.sh $INSTALL_DIR "$CLUSTER_NODES" $USER_NAME $GROUP_NAME $DOWNLOAD_DIR
  $CUR_DIR/flume/install_flume.sh $INSTALL_DIR "$CLUSTER_NODES" $USER_NAME $GROUP_NAME $DOWNLOAD_DIR
};;
esac

for node in $CLUSTER_NODES; do
  ssh $node "chown -R $USER_NAME:$GROUP_NAME $INSTALL_DIR"
done


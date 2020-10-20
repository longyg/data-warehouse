#!/usr/bin/env bash

###############################################################################
#
# Load log data from hdfs to ods_log tables in hive
#
# Usage:
#      hdfs_to_ods_log.sh <date>
# Example:
#      hdfs_to_ods_log.sh 2020-10-01
#
###############################################################################

APP=gmall
HADOOP_HOME_DIR=/opt/software/hadoop

if [ -n "$1" ];then
	do_date=$1
else
	do_date=`date -d "-1 day" +%F`
fi

echo "=============日志日期：$do_date============"

sql="
load data inpath '/origin_data/$APP/log/topic_log/$do_date' overwrite into table ${APP}.ods_log partition (dt='$do_date');
"

hive -e "$sql"

hadoop jar $HADOOP_HOME_DIR/share/hadoop/common/hadoop-lzo.jar com.hadoop.compression.lzo.DistributedLzoIndexer /warehouse/$APP/ods/ods_log/dt=$do_date
#!/usr/bin/env bash

###############################################################################
#
# Load log data from hdfs to ods_log tables in hive
#
# Usage:
#      hdfs_to_ods_log.sh [date]
# Example:
#      hdfs_to_ods_log.sh [2020-09-01]
#
###############################################################################

APP=gmall

if [ -n "$1" ];then
	do_date=$1
else
	do_date=`date -d "-1 day" +%F`
fi

echo "=============日志日期：$do_date============"
sql="
load data inpath '/origin_data/$APP/log/topic_start/$do_date' overwrite into table ${APP}.ods_start_log partition (dt='$do_date');
load data inpath '/origin_data/$APP/log/topic_event/$do_date' overwrite into table ${APP}.ods_event_log partition (dt='$do_date');
"

hive -e "$sql"
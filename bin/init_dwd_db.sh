#!/bin/bash

###############################################################################
#
# 初始化dwd业务层：初始化时间维度表，用户拉链表
# 
# 在导dwd层之前（ods_to_dwd_db.sh），需要先执行该脚本进行初始化
#
# Usage:
#      init_dwd_db.sh <date>
# Example:
#      init_dwd_db.sh 2020-10-01
#
###############################################################################

APP=gmall
date_info_path=/home/bigdata/data/date_info.txt

if [ -n "$1" ];then
	do_date=$1
else
	do_date=`date -d "-1 day" +%F`
fi

sql="
SET mapreduce.job.queuename=hive;
SET hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;


load data local inpath '$date_info_path' overwrite into table ${APP}.dwd_dim_date_info_tmp;
insert overwrite table ${APP}.dwd_dim_date_info
select * from ${APP}.dwd_dim_date_info_tmp;


insert overwrite table ${APP}.dwd_dim_user_info_his 
select 
	id, 
	name, 
	birthday, 
	gender, 
	email, 
	user_level, 
	create_time, 
	operate_time, 
	'$do_date', 
	'9999-99-99' 
from ${APP}.ods_user_info
where dt='$do_date';
"

hive -e "$sql"
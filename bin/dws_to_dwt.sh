#!/bin/bash

###############################################################################
#
# 将数据从dws层导入dwt层
#
# Usage:
#      dwd_to_dws.sh <date>
# Example:
#      dwd_to_dws.sh 2020-10-01
#
###############################################################################

APP=gmall

if [ -n "$1" ];then
	do_date=$1
else
	do_date=`date -d "-1 day" +%F`
fi

sql="
SET mapreduce.job.queuename=hive;
SET hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;

insert overwrite table ${APP}.dwt_uv_topic
select 
	nvl(new.mid_id, old.mid_id),
	nvl(new.brand, old.brand),
	nvl(new.model, old.model),
	if(old.mid_id is null, '$do_date', old.login_date_first),
	if(new.mid_id is not null, '$do_date', old.login_date_last),
	if(new.mid_id is not null, new.login_count, 0),
	nvl(old.login_count, 0) + if(new.login_count > 0, 1, 0)
from
(
	select * from ${APP}.dwt_uv_topic
) old
full outer join
(
	select * from ${APP}.dws_uv_detail_daycount
	where dt='$do_date'
) new
on 
	old.mid_id=new.mid_id;



"
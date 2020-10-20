#!/bin/bash

###############################################################################
#
# 将数据从dwd层导入dws层
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

with start_tmp as 
(
	select 
		mid_id,
		brand,
		model,
		count(*) login_count
	from
		${APP}.dwd_start_log
	where dt='$do_date'
	group by mid_id, brand, model
),
page_tmp as 
(
	select
		mid_id,
		brand,
		model,
		collect_set(named_struct('page_id', page_id, 'page_count', page_count)) page_stats
	from 
	(
		select
			mid_id,
			brand,
			model,
			page_id,
			count(*) page_count
		from
			${APP}.dwd_page_log
		where dt='$do_date'
		group by mid_id, brand, model, page_id
	)tmp
	group by mid_id, brand, model
)
insert overwrite table ${APP}.dws_uv_detail_daycount partition (dt='$do_date')
select 
	nvl(st.mid_id, pt.mid_id),
	nvl(st.brand, pt.brand),
	nvl(st.model, pt.model),
	nvl(st.login_count, 0),
	pt.page_stats
from 
	start_tmp st
full outer join 
	page_tmp pt
on 
	st.mid_id=pt.mid_id
	and st.brand=pt.brand
	and st.model=pt.model;




"


hive -e "$sql"
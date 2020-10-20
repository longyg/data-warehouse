create database if not exists gmall;
use gmall;



drop table if exists dws_uv_detail_daycount; 
create external table dws_uv_detail_daycount 
( 
	`mid_id` string COMMENT '设备 id', 
	`brand` string COMMENT '手机品牌', 
	`model` string COMMENT '手机型号', 
	`login_count` bigint COMMENT '活跃次数', 
	`page_stats` array<struct<page_id:string,page_count:bigint>> COMMENT '页面访问统计' 
) COMMENT '每日设备行为表' 
partitioned by(dt string) 
stored as parquet 
location '/warehouse/gmall/dws/dws_uv_detail_daycount' 
tblproperties ("parquet.compression"="lzo");

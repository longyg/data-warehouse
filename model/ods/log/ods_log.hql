create database if not exists gmall;
use gmall;


drop table if exists ods_log;

create external table ods_log (
	`line` string
)
partitioned by (`dt` string)
stored as 
	inputformat 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
	outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_log'
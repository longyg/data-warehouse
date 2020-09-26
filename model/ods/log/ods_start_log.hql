create database gmall;

use gmall;

drop table if exists ods_start_log;

create external table ods_start_log (
    `line` string
)
partitioned by (`dt` string)
location '/warehouse/gmall/ods/ods_start_log';

load data inpath '/origin_data/gmall/log/topic_start/2020-09-01' into table gmall.ods_start_log partition (dt='2020-09-01');
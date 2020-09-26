drop table if exists ods_event_log;

create external table ods_event_log (
    `line` string
)
partitioned by (`dt` string)
location '/warehouse/gmall/ods/ods_event_log';

load data inpath '/origin_data/gmall/log/topic_event/2020-09-01' into table gmall.ods_event_log partition (dt='2020-09-01')
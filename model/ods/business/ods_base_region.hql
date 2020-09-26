drop table if exists ods_base_region;

create external table ods_base_region (
    `id` bigint COMMENT '编号',
    `region_name` string COMMENT '地区名称'
) COMMENT '地区表'
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ods/ods_base_region';
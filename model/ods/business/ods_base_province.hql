drop table if exists ods_base_province;

create external table ods_base_province (
    `id` bigint COMMENT '编号',
    `name` string COMMENT '省份名称',
    `region_id` string COMMENT '地区ID',
    `area_code` string COMMENT '地区编码',
    `iso_code` string COMMENT 'iso 编码'
)
comment '省份表'
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ods/ods_base_province';
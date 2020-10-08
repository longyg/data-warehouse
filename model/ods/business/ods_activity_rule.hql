drop table if exists ods_activity_rule;

create external table ods_activity_rule(
    `id` string COMMENT '编号',
    `activity_id` string COMMENT '活动ID',
    `condition_amount` string COMMENT '满减金额',
    `condition_num` string COMMENT '满减件数',
    `benefit_amount` string COMMENT '优惠金额',
    `benefit_discount` string COMMENT '优惠折扣',
    `benefit_level` string COMMENT '优惠级别'
) COMMENT '优惠规则表'
PARTITIONED BY (`dt` string)
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ods/ods_activity_rule';
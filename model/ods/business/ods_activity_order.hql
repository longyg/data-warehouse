drop table if exists ods_activity_order;

create external table ods_activity_order(
    `id` string COMMENT '编号',
    `activity_id` string COMMENT '优惠券ID',
    `order_id` string COMMENT '订单ID',
    `create_time` string COMMENT '领取时间'
) COMMENT '活动订单关联表'
PARTITIONED BY (`dt` string)
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ods/ods_activity_order';
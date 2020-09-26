drop table if exists ods_coupon_info;

create external table ods_coupon_info(
    `id` string COMMENT '购物券编号',
    `coupon_name` string COMMENT '购物券名称',
    `coupon_type` string COMMENT '购物券类型1 现金券2 折扣券3 满减券4 满件打折券',
    `condition_amount` string COMMENT '满额数',
    `condition_num` string COMMENT '满件数',
    `activity_id` string COMMENT '活动编号',
    `benefit_amount` string COMMENT '减金额',
    `benefit_discount` string COMMENT '折扣',
    `create_time` string COMMENT '创建时间',
    `range_type` string COMMENT '范围类型1、商品2、品类3、品牌',
    `spu_id` string COMMENT '商品id',
    `tm_id` string COMMENT '品牌id',
    `category3_id` string COMMENT '品类id',
    `limit_num` string COMMENT '最多领用次数',
    `operate_time` string COMMENT '修改时间',
    `expire_time` string COMMENT '过期时间'
) COMMENT '优惠券表'
PARTITIONED BY (`dt` string)
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ods/ods_coupon_info';
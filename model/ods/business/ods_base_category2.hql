drop table if exists ods_base_category2;

create external table ods_base_category2 (
    `id` string COMMENT 'id',
    `name` string COMMENT '名称',
    `category1_id` string COMMENT '一级品类id'
)
comment '商品二级分类表'
partitioned by (`dt` string)
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ods/ods_base_category2';
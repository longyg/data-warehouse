drop table if exists ods_base_dic;

create external table ods_base_dic(
    `dic_code` string COMMENT '编号',
    `dic_name` string COMMENT '编码名称',
    `parent_code` string COMMENT '父编码',
    `create_time` string COMMENT '创建日期',
    `operate_time` string COMMENT '操作日期'
) COMMENT '编码字典表'
PARTITIONED BY (`dt` string)
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ods/ods_base_dic';
drop table if exists ods_user_info;

create external table ods_user_info (
    `id` string COMMENT '用户id',
    `name` string COMMENT '姓名',
    `birthday` string COMMENT '生日',
    `gender` string COMMENT '性别',
    `email` string COMMENT '邮箱',
    `user_level` string COMMENT '用户等级',
    `create_time` string COMMENT '创建时间',
    `operate_time` string COMMENT '操作时间'
)
comment '用户表'
partitioned by (`dt` string)
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ods/ods_user_info';
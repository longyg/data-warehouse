create database if not exists gmall;
use gmall;

drop table if exists dwd_start_log; 
CREATE EXTERNAL TABLE dwd_start_log( 
	`area_code` string COMMENT '地区编码', 
	`brand` string COMMENT '手机品牌', 
	`channel` string COMMENT '渠道', 
	`model` string COMMENT '手机型号', 
	`mid_id` string COMMENT '设备 id', 
	`os` string COMMENT '操作系统', 
	`user_id` string COMMENT '会员 id', 
	`version_code` string COMMENT 'app 版本号', 
	`entry` string COMMENT 'icon 手机图标 notice 通知 install 安装后启动', 
	`loading_time` bigint COMMENT '启动加载时间', 
	`open_ad_id` string COMMENT '广告页 ID ', 
	`open_ad_ms` bigint COMMENT '广告总共播放时间', 
	`open_ad_skip_ms` bigint COMMENT '用户跳过广告时点', 
	`ts` bigint COMMENT '时间' 
) COMMENT '启动日志表' 
PARTITIONED BY (dt string)
stored as parquet
LOCATION '/warehouse/gmall/dwd/dwd_start_log'
TBLPROPERTIES('parquet.compression'='lzo');



drop table if exists dwd_page_log; 
CREATE EXTERNAL TABLE dwd_page_log( 
	`area_code` string COMMENT '地区编码', 
	`brand` string COMMENT '手机品牌', 
	`channel` string COMMENT '渠道', 
	`model` string COMMENT '手机型号', 
	`mid_id` string COMMENT '设备 id', 
	`os` string COMMENT '操作系统', 
	`user_id` string COMMENT '会员 id', 
	`version_code` string COMMENT 'app 版本号', 
	`during_time` bigint COMMENT '持续时间毫秒', 
	`page_item` string COMMENT '目标 id ', 
	`page_item_type` string COMMENT '目标类型', 
	`last_page_id` string COMMENT '上页类型', 
	`page_id` string COMMENT '页面 ID ', 
	`source_type` string COMMENT '来源类型', 
	`ts` bigint 
) COMMENT '页面日志表' 
PARTITIONED BY (dt string) 
stored as parquet 
LOCATION '/warehouse/gmall/dwd/dwd_page_log' 
TBLPROPERTIES('parquet.compression'='lzo');



drop table if exists dwd_action_log; 
CREATE EXTERNAL TABLE dwd_action_log( 
	`area_code` string COMMENT '地区编码', 
	`brand` string COMMENT '手机品牌', 
	`channel` string COMMENT '渠道', 
	`model` string COMMENT '手机型号', 
	`mid_id` string COMMENT '设备 id', 
	`os` string COMMENT '操作系统', 
	`user_id` string COMMENT '会员 id', 
	`version_code` string COMMENT 'app 版本号', 
	`during_time` bigint COMMENT '持续时间毫秒', 
	`page_item` string COMMENT '目标 id ', 
	`page_item_type` string COMMENT '目标类型', 
	`last_page_id` string COMMENT '上页类型', 
	`page_id` string COMMENT '页面 id ', 
	`source_type` string COMMENT '来源类型', 
	`action_id` string COMMENT '动作 id', 
	`item` string COMMENT '目标 id ', 
	`item_type` string COMMENT '目标类型', 
	`ts` bigint COMMENT '时间' 
) COMMENT '动作日志表' 
PARTITIONED BY (dt string) 
stored as parquet 
LOCATION '/warehouse/gmall/dwd/dwd_action_log' 
TBLPROPERTIES('parquet.compression'='lzo');


drop table if exists dwd_display_log; 
CREATE EXTERNAL TABLE dwd_display_log( 
	`area_code` string COMMENT '地区编码', 
	`brand` string COMMENT '手机品牌', 
	`channel` string COMMENT '渠道', 
	`model` string COMMENT '手机型号', 
	`mid_id` string COMMENT '设备 id', 
	`os` string COMMENT '操作系统', 
	`user_id` string COMMENT '会员 id', 
	`version_code` string COMMENT 'app 版本号', 
	`during_time` bigint COMMENT 'app 版本号', 
	`page_item` string COMMENT '目标 id ', 
	`page_item_type` string COMMENT '目标类型', 
	`last_page_id` string COMMENT '上页类型', 
	`page_id` string COMMENT '页面 ID ', 
	`source_type` string COMMENT '来源类型', 
	`ts` bigint COMMENT 'app 版本号', 
	`display_type` string COMMENT '曝光类型', 
	`item` string COMMENT '曝光对象 id ', 
	`item_type` string COMMENT 'app 版本号', 
	`order` bigint COMMENT '出现顺序'
) COMMENT '曝光日志表' 
PARTITIONED BY (dt string) 
stored as parquet 
LOCATION '/warehouse/gmall/dwd/dwd_display_log' 
TBLPROPERTIES('parquet.compression'='lzo');



drop table if exists dwd_error_log; 
CREATE EXTERNAL TABLE dwd_error_log( 
	`area_code` string COMMENT '地区编码', 
	`brand` string COMMENT '手机品牌', 
	`channel` string COMMENT '渠道', 
	`model` string COMMENT '手机型号', 
	`mid_id` string COMMENT '设备 id', 
	`os` string COMMENT '操作系统', 
	`user_id` string COMMENT '会员 id', 
	`version_code` string COMMENT 'app 版本号', 
	`page_item` string COMMENT '目标 id ', 
	`page_item_type` string COMMENT '目标类型', 
	`last_page_id` string COMMENT '上页类型', 
	`page_id` string COMMENT '页面 ID ', 
	`source_type` string COMMENT '来源类型', 
	`entry` string COMMENT ' icon 手机图标 notice 通知 install 安装后启动', 
	`loading_time` string COMMENT '启动加载时间', 
	`open_ad_id` string COMMENT '广告页 ID ', 
	`open_ad_ms` string COMMENT '广告总共播放时间', 
	`open_ad_skip_ms` string COMMENT '用户跳过广告时点', 
	`actions` string COMMENT '动作', 
	`displays` string COMMENT '曝光', 
	`ts` string COMMENT '时间', 
	`error_code` string COMMENT '错误码', 
	`msg` string COMMENT '错误信息' 
) COMMENT '错误日志表' 
PARTITIONED BY (dt string) 
stored as parquet 
LOCATION '/warehouse/gmall/dwd/dwd_error_log' 
TBLPROPERTIES('parquet.compression'='lzo');


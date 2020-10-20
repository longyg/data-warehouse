use gmall;

create function explode_json_array as 'com.yglong.bigdata.hive.udtf.ExplodeJsonArray'
using jar 'hdfs://bigdata01:8020/user/hive/jars/hivefunction-1.0-SNAPSHOT.jar';
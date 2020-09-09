#!/bin/bash
###############################################################################
#
# Install hive 3.1.2 and start hiveserver2
#
# Prerequisites:
#   - Hadoop is installed and running
#   - JDK is installed and JAVA_HOME env is configured
#   - MYSQL is installed and dedicated meta database is created (e.g., hive) and
#     user/password (e.g., hive) is created
#   - hostname is configured for every node
#   - ssh login without password between all nodes is configured for both
#	    root and non-root user
#
# Note:
#   - This script must be executed on first namenode
#   - This script must be executed as root user
#   - This script is only tested on Ubuntu 18.04
#   - Hive 3.1.2 is compatible with Hadoop 3.x.y
#
###############################################################################
INSTALL_DIR=$1
HIVE_USER_NAME=$2
HIVE_GROUP_NAME=$3
DOWNLOAD_DIR=$4
JAVA_HOME_DIR=$(echo $JAVA_HOME)
HIVE_HOME_DIR="$INSTALL_DIR/hive"
SCRIPT_DIR=$(dirname $(readlink -f "$0"))

echo "Downloading hive..."
mkdir -p $DOWNLOAD_DIR
cd $DOWNLOAD_DIR
if [ ! -f apache-hive-*.tar.gz ]; then
	wget https://mirrors.bfsu.edu.cn/apache/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz
fi

if [ ! -f apache-hive-*.tar.gz ]; then
	echo "Download hive failed, exit"
	exit 1
fi

mkdir -p $INSTALL_DIR
cd $INSTALL_DIR

echo "Unpacking hive..."
rm -rf $HIVE_HOME_DIR
cp $DOWNLOAD_DIR/apache-hive-*.tar.gz ./
tar -zxvf apache-hive-*.tar.gz > /dev/null 2>&1
rm apache-hive-*.tar.gz
mv apache-hive* hive

echo "Configuring environment..."
if [ `grep -c "export HIVE_HOME=" /etc/profile` -eq 1 ];then
	echo "HIVE_HOME environment variable is already configured"
else
	echo "export HIVE_HOME=$HIVE_HOME_DIR" >> /etc/profile
	echo "export PATH=\$PATH:\$HIVE_HOME/bin" >> /etc/profile
	source /etc/profile
fi
echo $HIVE_HOME

cd $HIVE_HOME

echo "Configuring hive-site.xml..."
cp -f $SCRIPT_DIR/hive-site.xml $HIVE_HOME_DIR/conf/hive-site.xml

echo "Configuring hive-log4j2.properties..."
mv $HIVE_HOME_DIR/conf/hive-log4j2.properties.template $HIVE_HOME_DIR/conf/hive-log4j2.properties
HIVE_LOG_DIR="$HIVE_HOME_DIR/logs"
sed -i "/property.hive.log.dir = /cproperty.hive.log.dir = $HIVE_LOG_DIR" $HIVE_HOME_DIR/conf/hive-log4j2.properties

echo "Copying mysql driver..."
cp -f $SCRIPT_DIR/mysql-connector-java-*.jar $HIVE_HOME_DIR/lib/

rm $HIVE_HOME_DIR/lib/guava-*.jar
cp -f /opt/software/hadoop/share/hadoop/common/lib/guava-*.jar $HIVE_HOME_DIR/lib/

chown -R $HIVE_USER_NAME:$HIVE_GROUP_NAME $HIVE_HOME_DIR

# 初始化数据库前，需要删除已存在的hive表
echo "Try to drop existing hive table in MySQL..."
mysql -uroot -proot << EOF
drop database if exists hive;
EOF

echo "Initializing mysql schema..."
su - $HIVE_USER_NAME -c "schematool -dbType mysql -initSchema"

su - $HIVE_USER_NAME -c "hive --version"

echo "Starting hiveserver2..."
su - $HIVE_USER_NAME -c "nohup hive --service hiveserver2 >/dev/null 2>&1 &"
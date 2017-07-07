#! /bin/bash
# Author:wangxiaolei 王小雷
# Blog: http://blog.csdn.net/dream_an
# Github: https://github.com/wangxiaoleiai
# Date: 201707
# Organization: https://github.com/whaleai

HBASE_VERSION=1.3.1
HBASE_HOME=/opt/hbase-$HBASE_VERSION
install()
{
begin_time=$(date +%s)
source whaleai-config.sh
source /etc/profile
if [[ ! -f hbase-$HBASE_VERSION-bin.tar.gz ]]; then
  echo "目标文件不存在,请将　hbase-$HBASE_VERSION.tar.gz　下载并放置本文件中
5 秒后自动退出......"
  sleep 5
  exit 0
fi

if [[  -d $HBASE_HOME ]]; then
  #statements
  echo "需要移除hbase残余文件
请执行 . whaleai-hbase.sh -r
8　秒后自动退出
"
  sleep 8
  exit 0

fi

if [[ ! -d $HADOOP_HOME ]]; then
  #statements
  echo "请先正确部署hadoop
推荐: https://github.com/whaleai/whaleai-hadoop
再执行 . whaleai-hbase.sh -r
8　秒后自动退出
"
  sleep 8
  exit 0

fi

#解压
echo "hbase-$HBASE_VERSION　伪分布式正在自动安装部署..."
tar -zxf hbase-$HBASE_VERSION-bin.tar.gz
echo "hbase-$HBASE_VERSION　>>解压完成"
sudo mv  hbase-$HBASE_VERSION /opt/
#配置hbase的配置文件
echo "export JAVA_HOME=$JAVA_HOME">>$HBASE_HOME/conf/hbase-env.sh
create_config --file hbase-site.xml
put_config --file hbase-site.xml --property fs.defaultFS --value "true"
put_config --file hbase-site.xml --property hbase.rootdir --value "hdfs://localhost:9000/hbase"

echo "hbase-$HBASE_VERSION　>>xml文件配置完成"
#创建变量文件
echo "${Author} ${HBaseEnv}">hbase-$HBASE_VERSION.sh
sudo mv  hbase-$HBASE_VERSION.sh /etc/profile.d
sudo mv  hbase-site.xml -t $HBASE_HOME/conf/
source /etc/profile
echo "hbase-$HBASE_VERSION　>>变量配置完成 "

echo "hbase-$HBASE_VERSION　>>服务启动中..."
$HBASE_HOME/bin/start-hbase.sh
echo "hbase-$HBASE_VERSION　>>启动完成 "
jps

echo "hbase-$HBASE_VERSION　>>开启成功...服务已经启动...

HBase Web UI

  Master - http://localhost:16010

  RegionServer - http://localhost:16301/  或者　16030

耗时 : $(($(date +%s) - $begin_time)) S

"

#
}

remove()
{
echo "hbase-$HBASE_VERSION　正在卸载..."
$HBASE_HOME/bin/stop-hbase.sh
sudo rm -rf $HBASE_HOME
sudo rm -rf /tmp/hbase*

sudo rm -rf /etc/profile.d/hbase-$HBASE_VERSION.sh
source /etc/profile
echo "hbase-$HBASE_VERSION　卸载完成

使用　. whaleai-hbase -i　进行安装
"
}

help()
{
cat << EOF
已支持版本　hbase-2
This script installs hbase  with basic data, log, and pid directories.

USAGE:  whaleai-hbase.sh [options]
OPTIONS:
   -i, --install　        伪分布式安装部署hbase

   -r, --remove           卸载hbase

   -h, --help             Show this message.

EXAMPLES:
  如何安装？hbase install:

		 . whaleai-hbase.sh -i　

		 Or . install-hbase.sh --install

  如何卸载？hbase remove:

		 . whaleai-hbase.sh -r

		 Or . install-hbase.sh --remove
EOF
}

while true;

do
  case "$1" in

    -i|--install)
      install
			break
      ;;
    -r|--remove)
      remove
			break
      ;;
    *)
			help
      break
      ;;
  esac
done

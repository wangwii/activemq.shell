#!/bin/bash
#parameter==================================================
#{"component":"ActiveMQ",
#"operation":"uninstall",
#"depends":["recyle.sh"],
#"params":[{"text": "安装目录", "hidden": true, "value": "install_path", "desc": "ActiveMQ安装目录"},
#{"text": "实例目录", "hidden": true, "value": "instance_path", "desc": "ActiveMQ实例目录"},
#{"text": "停止脚本路径", "hidden": true, "value": "stop_script_path", "desc": "停止ActiveMQ脚本文件"}]
#}
#parameter==================================================
set -e

install_path=$1
instance_path=$2
stop_script_path=$3

exec_user=$4
host_ip=$5
activemq_version=$6
host_name=$7
confItem_name=$8

if [ -f $stop_script_path ]; then
    sh $stop_script_path
fi
rm -rf ${instance_path}
rm -rf ${install_path}

echo "#output=================================================="
echo "名称,主机名,IP,版本,安装目录,DEL_INSTALL_INFO"
echo "${confItem_name},${host_name},${host_ip},${activemq_version},${install_path},Y"
echo "#output=================================================="

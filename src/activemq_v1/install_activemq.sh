#!/bin/bash
#parameter==================================================
#{"component":"ActiveMQ",
#"operation":"install",
#"depends":["recyle.sh","start_activemq.sh","stop_activemq.sh"],
#"params":{"data": [
#{"text": "安装目录", "value": "install_path", "required": true, "desc": "activemq安装目录"},
#{"text": "介质目录", "value": "media_path", "required": true, "desc": "activemq安装介质所在目录"},
#{"text": "实例名称", "value": "instance_name", "required": true, "desc": "activemq实例名称"},
#{"text": "管理端口", "value": "admin_port", "required": false, "default": 8161, "desc": "管理控制台端口"}
#{"text": "wire端口", "value": "wire_port", "required": false, "default": 61616, "desc": "tcp协议端口"}
#{"text": "amqp端口", "value": "amqp_port", "required": false, "default": 5672, "desc": "amqp协议端口"}
#{"text": "stomp端口", "value": "stomp_port", "required": false, "default": 61613, "desc": "stomp协议端口"}
#{"text": "mqtt端口", "value": "mqtt_port", "required": false, "default": 1883, "desc": "mqtt协议端口"}
#{"text": "ws端口", "value": "ws_port", "required": false, "default": 61614, "desc": "websocket协议端口"}
#{"text": "JAVA路径", "value": "java_path", "required": false, "default":"which-java","desc": "假设java命令在$PATH中,不存在时报错"}],
#"version": [{"text": "5.16.6", "value": "5.16.6"}]
#}}
#parameter==================================================
set -e

install_dir=$1
media_path=$2
instance_name=$3
admin_port="${4:-8161}"
wire_port="${5:-61616}"
amqp_port="${6:-5672}"
stomp_port="${7:-61613}"
mqtt_port="${8:-1883}"
ws_port="${9:-61614}"
java_path="${10:-java}"

exec_user=${11:-root}
host_ip=${12:-0.0.0.0}
activemq_version="${13:-5.16.6}"
host_name=${14:-HOSTNAME}

BASE_PATH=$(cd `dirname $0`; pwd)
alias rm="sh ${BASE_PATH}/recyle.sh"

## check inputs
check_params(){
    # 检查安装包
    if [[ ! -d $media_path ]]; then
        echo "The media path [${media_path}] does not exists!"
        exit 1
    fi
    install_package_path="${media_path%*/}/apache-activemq-${activemq_version}-bin.tar.gz"
    if [[ ! -f $install_package_path ]]; then
        echo "The installation package [${install_package_path}] does not exists!"
        exit 1
    fi
    echo "media_path: ${media_path}"
    echo "media package: ${install_package_path}"

    # 检查安装目录
    if [ ! -d "${install_dir}" ]; then
        mkdir -p ${install_dir}
    fi
    echo "install_dir: ${install_dir}"

    # 检查实例目录
    if [ ! -n "${instance_name}" ]; then
        echo "The instance name can not be empty!"
        exit 1
    fi
    # echo "The instance name is [${instance_name}]"
    instance_path="${install_dir%*/}/${instance_name}"
    if [ -d "${instance_path}" ]; then
        num=`ls ${instance_path} | wc -l`
        if [ $num -gt 0 ]; then
            echo "The instance directory [${instance_path}] does not empty!"
            exit 1
        fi
    fi
    echo "instance_path: ${instance_path}"


    echo "admin_port: $admin_port"
    echo "server_port: $server_port"
    echo "activemq_version: $activemq_version"
    echo "exec_user: ${exec_user}"
    echo "host_ip: $host_ip"
    echo "host_name: $host_name"

    ## 检测java版本
    can_not_found_java="Invalid java_path(${java_path}), please install JDK or check your java_path param."
    if which $java_path > /dev/null; then
        java_version=`${java_path} -version 2>&1 |awk 'NR==1{ gsub(/"/,""); print $3 }'`
        if [ $? != 0 ]; then
            echo $can_not_found_java
            exit 1
        fi
    else
        echo $can_not_found_java
        exit 1
    fi
    echo "java_path: $java_path (version: $java_version)"
}

## setup conf
setup_conf(){
    sed -i 's|127.0.0.1|0.0.0.0|' ${instance_path}/conf/jetty.xml
    sed -i "s|8161|${admin_port}|" ${instance_path}/conf/jetty.xml

    sed -i "s|61614|${ws_port}|" ${instance_path}/conf/activemq.xml
    sed -i "s|1883|${mqtt_port}|" ${instance_path}/conf/activemq.xml
    sed -i "s|5672|${amqp_port}|" ${instance_path}/conf/activemq.xml
    sed -i "s|61616|${wire_port}|" ${instance_path}/conf/activemq.xml
    sed -i "s|61613|${stomp_port}|" ${instance_path}/conf/activemq.xml
}

## build start & stop script.
build_start_stop_script(){
    activemq_start_path="${instance_path}/bin/start_activemq.sh"
    echo "${instance_path}/bin/${instance_name} start" > ${activemq_start_path}
    chmod a+x ${activemq_start_path}

    activemq_stop_path="${instance_path}/bin/stop_activemq.sh"
    echo "${instance_path}/bin/${instance_name} stop" > ${activemq_stop_path}
    chmod a+x ${activemq_stop_path}
}

## install package and update conf
install_amq_package() {
    output=`tar -zxvf $install_package_path --strip-components 1 -C ${install_dir}`
    if [ $? == 0 ]; then
        ${install_dir%*/}/bin/activemq create ${instance_path}

        setup_conf
        echo ${activemq_version} > ${install_dir}/.version
    else
        echo "ActiveMQ install failed ! "
        rm ${install_dir}
        exit 1
   fi
}

check_params
install_amq_package
build_start_stop_script

# 完成安装
echo "ActiveMQ ${activemq_version} installed to [${instance_path}]."

echo "#output=================================================="
echo "实例名称,资源名称,版本,安装用户,安装目录,实例目录,IP,主机名,was类型,启动脚本路径,停止脚本路径,实例用户,启停用户,配置文件路径,UPD_INSTALL_INFO"
echo "${instance_name},${instance_name},${activemq_version},${exec_user},${install_dir},${instance_path},${host_ip},${host_name},ActiveMQ,${activemq_start_path},${activemq_stop_path},${exec_user},${exec_user},${instance_path}/conf,Y"
echo "#output=================================================="

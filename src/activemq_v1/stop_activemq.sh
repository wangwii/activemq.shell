#!/bin/sh
#parameter==================================================
#{"component":"ActiveMQ",
#"operation":"stop",
#"params":[{"text": "脚本路径", "required": true, "value": "stop_path", "default":"停止脚本路径", "desc": "停止脚本绝对路径", "type": "select", "fun": "get_script_path_by_amdb", "limit": "instance"}]
#}
#parameter==================================================
set -e

script_path=$1
echo "stop_script: $script_path"

if [ ! -f "${script_path}" ]; then
    echo 'ActiveMQ stop script file does not exist!'
    exit 1
fi
sh ${script_path}

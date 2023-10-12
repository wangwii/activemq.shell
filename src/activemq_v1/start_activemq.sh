#!/bin/sh
#parameter==================================================
#{"component":"ActiveMQ",
#"operation":"start",
#"params":[{"text": "脚本路径", "required": true, "value": "start_path", "default":"启动脚本路径", "desc": "启动脚本绝对路径", "type": "select", "fun": "get_script_path_by_amdb", "limit": "instance"}]
#}
#parameter==================================================
set -e

script_path=$1
echo "start_script: $script_path"

if [ ! -f "${script_path}" ]; then
    echo 'ActiveMQ startup script file does not exist!'
    exit 1
fi

sh $script_path

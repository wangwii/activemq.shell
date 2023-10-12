# ActiveMQ manager scripts
需求：
    https://alidocs.dingtalk.com/spreadsheetv2/My45rW3Nu0qaY8MN/edit

## Commands
* prepare install package of activemq.
```
    cd dat/packages
    curl -O https://archive.apache.org/dist/activemq/5.16.6/apache-activemq-5.16.6-bin.tar.gz
```

* shell to open-euler and test all scripts.
```
    docker-compose pull
    docker-compose run oe bash

    # setup java
    install_jdk8.sh

    ## About input params:
    #  * The media_path must be /packages
    #  * The install_dir can be any path, eg. /opt/apache/activemq
    #  * The instance_name can be any name
    #####

    # To test all scripts
    cd activemq_v1
    # install and create the amq1 instance
    ./install_activemq.sh /opt/apache/activemq /packages amq1

    # start instance amq1
    ./start_activemq.sh /opt/apache/activemq/amq1/bin/start_activemq.sh

    # stop instance amq1
    ./stop_activemq.sh /opt/apache/activemq/amq1/bin/stop_activemq.sh

    # delete instance amq1
    ./delete_activemq.sh /opt/apache/activemq /opt/apache/activemq/amq1 /opt/apache/activemq/amq1/bin/stop_activemq.sh

    # uninstall
    ./uninstall_activemq.sh /opt/apache/activemq /opt/apache/activemq/amq1 /opt/apache/activemq/amq1/bin/stop_activemq.sh
```

## Others
### OS: BCLinux for Euler V21.10
https://mirrors.cmecloud.cn
https://www.openeuler.org/zh/download
[OS Euler V21.10 是 BCLinux for Euler的发行版本，未找到docker镜像，所以使用社区版v21.09代替](https://gitee.com/openeuler/openeuler-docker-images)

### 安装包下载地址
https://activemq.apache.org/activemq-5016006-release
* 5.16.6
    https://archive.apache.org/dist/activemq/5.16.6/apache-activemq-5.16.6-bin.tar.gz

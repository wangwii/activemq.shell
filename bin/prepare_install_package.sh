#!/bin/bash

pkg_url="https://archive.apache.org/dist/activemq/5.16.6/apache-activemq-5.16.6-bin.tar.gz"

echo $pkg_url
(cd dat/packages && curl -O $pkg_url)

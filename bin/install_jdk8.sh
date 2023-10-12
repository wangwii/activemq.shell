#!/bin/bash

dnf clean all
dnf makecache
dnf -y -q install java-1.8.0-openjdk-devel.x86_64

java -version

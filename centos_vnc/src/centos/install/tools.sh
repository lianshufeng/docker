#!/bin/bash


echo "Install some common tools for further installation"
yum -y install epel-release 
yum -y update
yum -y install vim sudo wget which net-tools bzip2 \
    numpy #used for websockify/novnc
yum -y install mailcap
yum clean all

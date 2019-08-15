#!/bin/sh


#安装docker
install_docker_ce(){
	echo "update docker "
	#卸载
	yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine	
	#设置稳定库	
	yum install -y yum-utils device-mapper-persistent-data lvm2
	yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
	#安装docker
	yum install -y docker-ce docker-ce-cli containerd.io
}







#动态执行方法
callFun(){
	echo "call : "$1 && $1
}


callFun "install_docker_ce"






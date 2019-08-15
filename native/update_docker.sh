#!/bin/sh


#安装docker
install_docker_ce(){
	echo "update docker "
	
	#关闭服务
	systemctl stop docker
	
	#卸载
	yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine	
	#设置稳定库	
	yum install -y yum-utils device-mapper-persistent-data lvm2
	yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
	#安装docker
	yum install -y docker-ce docker-ce-cli containerd.io
	
	#开启服务
	systemctl start docker
	
}

#修改docker镜像加速器
updatePullImagesUrl(){
	mkdir -p /etc/docker
	if [ `grep -c "registry-mirrors" /etc/docker/daemon.json` -eq '0' ] ;then
		tee /etc/docker/daemon.json <<-'EOF'
		{
		"registry-mirrors": ["https://yo9l653d.mirror.aliyuncs.com"]
		}
		EOF
		systemctl daemon-reload
	fi
}






#动态执行方法
callFun(){
	echo "call : "$1 && $1
}


callFun "install_docker_ce"
callFun "updatePullImagesUrl"






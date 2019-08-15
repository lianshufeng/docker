#!/bin/sh


#安装docker
install_docker_ce(){
	echo "update docker "
	
	#卸载
	yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine	
	#设置稳定库	
	yum install -y yum-utils device-mapper-persistent-data lvm2
	#设置源
	# yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
	#设置阿里源
	yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
	#安装docker
	yum install -y docker-ce docker-ce-cli containerd.io
	
}

#修改docker镜像加速器
updatePullImagesUrl(){
	mkdir -p /etc/docker	
	tee /etc/docker/daemon.json <<-'EOF'
	{
		"registry-mirrors": ["https://yo9l653d.mirror.aliyuncs.com"]
	}
	EOF
	systemctl daemon-reload
}


#更新docker默认的保存位置
updateDockerStore(){
	dockerStore=`df -k | awk '{print $2 " " $6}' | sort -n -r | head -1 | awk '{print $2}'`
	if [ ! -d $dockerStore"/docker" ];then
		cp -rf /var/lib/docker $dockerStore/docker
		#备份
		mv /var/lib/docker /var/lib/docker.bak
		ln -sf $dockerStore/docker /var/lib/docker
	fi
}




#动态执行方法
callFun(){
	echo "call : "$1 && $1
}


#关闭服务
systemctl stop docker
callFun "install_docker_ce"
callFun "updatePullImagesUrl"
callFun "updateDockerStore"

#开启服务
systemctl start docker
#开机自动启动
chkconfig docker on



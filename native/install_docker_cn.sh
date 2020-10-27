#!/bin/sh
# 适合 centos 及国内环境:
# 1、安装系统时间同步服务
# 2、修改镜像下载阿里的加速源
# 3、安装定期释放缓存服务
# 4、允许防火墙使用网络覆盖端口
#

#安装特性
installFeature(){
	#centos8 必须安装
	releaseVer=`cat /etc/redhat-release | awk '{match($0,"release ") ; print substr($0,RSTART+RLENGTH)}' | awk -F '.' '{print $1}'`
	if [ "$releaseVer" == "8" ];then
		# https://download.docker.com/linux/centos/7/x86_64/stable/Packages/
		yum install -y http://dl.dzurl.top/containerd.io-1.3.7-3.1.el7.x86_64.rpm
	fi
}



#设置防火墙
openFireWall(){
	#允许防火墙
	callFun "firewall-cmd --add-port=2376/tcp --permanent"
	callFun "firewall-cmd --add-port=2377/tcp --permanent"
	callFun "firewall-cmd --add-port=7946/tcp --permanent"
	callFun "firewall-cmd --add-port=7946/udp --permanent"
	callFun "firewall-cmd --add-port=4789/udp --permanent"
	
	callFun "firewall-cmd --zone=public --add-masquerade --permanent"
	callFun "firewall-cmd --permanent --zone=public --change-interface=docker0"
	callFun "firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 4 -i docker0 -j ACCEPT"
	
	
	callFun "firewall-cmd --reload"
	
	#禁用SELINUX：
	setenforce 0
	echo "SELINUX=disabled" > /etc/selinux/config
	echo "SELINUXTYPE=targeted" >> /etc/selinux/config
}

#安装docker
installDocker(){
	curl -fsSL https://get.docker.com | sh
}


#安装docker-compose
installDockerCompose(){
	# https://github.com/docker/compose/releases
	curl -L http://dl.dzurl.top/1.27.4/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
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


#启动服务
startDocker(){
	service docker restart
}


#安装系统助手:时间同步与缓存释放
installSystemHelper(){
	# 同步时区
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	# 安装服务
	mkdir -p /opt/docker/systemhelper
	curl -fsSL http://dl.dzurl.top/systemhelper/docker-compose.yml -o /opt/docker/systemhelper/docker-compose.yml
	cd /opt/docker/systemhelper
	docker-compose down;docker-compose up -d
}



#打印docker日志
printInfo(){
	docker info
	docker -v
	docker-compose -v
}



#动态执行方法
callFun(){
	echo "call : "$1 && $1
}


#安装特性
callFun "installFeature"

#允许防火墙
callFun "openFireWall"

#安装docker
callFun "installDocker"

#docker加速器
callFun "updatePullImagesUrl"

#安装DockerCompose
callFun "installDockerCompose"

#启动docker
callFun "startDocker"

#安装系统助手
callFun "installSystemHelper"


#打印服务
callFun "printInfo"



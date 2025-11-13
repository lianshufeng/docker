#!/bin/bash

# Os Type
if [[ `cat /etc/os-release | grep NAME= | grep CentOS` != "" ]];then
	ostype="centos"
elif [[ `cat /etc/os-release | grep NAME= | grep Ubuntu` != "" ]];then
	ostype="ubuntu"
fi

# Platform Type
platformtype=$(uname -m)
if [[ $platformtype == "x86_64" ]];then
	dockerTagName="latest"
else
	dockerTagName=$platformtype
fi

# centos
preInstallFromCentos(){
	echo "install centos"
	
	# centos > 7 补丁
	releaseVer=`cat /etc/redhat-release | awk '{match($0,"release ") ; print substr($0,RSTART+RLENGTH)}' | awk -F '.' '{print $1}'`	
	if [ "$releaseVer" -gt 7 ];then
		#删除 podman 和 buildah (解决冲突的问题)
		yum erase podman buildah -y
	
		#自动寻找最新的版本
		containerd_url=https://mirrors.aliyun.com/docker-ce/linux/centos/7/$(uname -m)/stable/Packages/
		containerd=$(curl $containerd_url | grep containerd.io- | tail -1 );containerd=${containerd#*>containerd.io};containerd=${containerd%<*};containerd=${containerd%<*};containerd="containerd.io"$containerd
		containerd_url=$containerd_url$containerd
		echo $containerd_url
		yum install -y $containerd_url
	fi

	#SELINUX
	setenforce 0
	echo "SELINUX=disabled" > /etc/selinux/config
	echo "SELINUXTYPE=targeted" >> /etc/selinux/config


}

# ubuntu
preInstallFromUbuntu(){
	echo "install ubuntu"
}


installServiceFromCentos(){
	# 打开防火墙
	firewall-cmd --add-port=2376/tcp --permanent
	firewall-cmd --add-port=2377/tcp --permanent
	firewall-cmd --add-port=7946/tcp --permanent
	firewall-cmd --add-port=7946/udp --permanent
	firewall-cmd --add-port=4789/udp --permanent
	firewall-cmd --reload
}



installServiceFromUbuntu(){
	# 打开防火墙
	ufw allow 2376/tcp
	ufw allow 2377/tcp
	ufw allow 7946/tcp
	ufw allow 7946/udp
	ufw allow 4789/udp
}



# 获取主机ip
updateHostIp(){
	ip route get 1.2.3.4 | awk '{print $7}' | grep -v  '^\s*$'  > /etc/docker_host_ip
}


#安装docker
installDocker(){

	#配置文件
	mkdir -p /etc/docker	
	tee /etc/docker/daemon.json <<-'EOF'
	{
		"log-driver": "json-file",
		"log-opts": {"max-size": "1024m", "max-file": "3"},
		"registry-mirrors": ["https://docker.jpy.wang"]
	}
	EOF

	#安装
	curl -fsSL https://proxy.jpy.wang/get.docker.com | bash -s docker --mirror Aliyun	
	
	#自动启动
	systemctl enable docker.service
	#启动服务
	service docker start
}


# 安装助手
installHelper(){

	#docker-compose
	# chmod +x /usr/local/bin/docker-compose
	# ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

	DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
	mkdir -p $DOCKER_CONFIG/cli-plugins
	
	# 获取版本号
	composeVersion=v$(
	  curl -s https://proxy.jpy.wang/api.github.com/repos/docker/compose/releases/latest \
	  | grep -Po '"tag_name":\s*"\K[^"]+' \
	  | sed 's/^v//'
	)
	echo "docker-compose latest: $composeVersion"
	CMD="curl -SL https://proxy.jpy.wang/github.com/docker/compose/releases/download/$composeVersion/docker-compose-linux-$(uname -m) -o $DOCKER_CONFIG/cli-plugins/docker-compose"
	echo "$CMD"
	eval "$CMD"

	
	# curl -SL https://dl.jpy.wang/docker-compose/2.23.3/docker-compose-linux-$(uname -m) -o $DOCKER_CONFIG/cli-plugins/docker-compose
	# curl -SL https://github.jpy.wang/docker/compose/releases/download/v2.24.7/docker-compose-linux-$(uname -m) -o $DOCKER_CONFIG/cli-plugins/docker-compose
	chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
	ln -s $DOCKER_CONFIG/cli-plugins/docker-compose /usr/bin/docker-compose


	# 同步时区
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	mkdir -p /opt/docker/systemhelper
	
	# systemhelper
	tee /opt/docker/systemhelper/docker-compose.yml <<-'EOF'
version: "3"
services:
  systemhelper:
    image: lianshufeng/systemhelper:$dockerTagName
    privileged: true
    environment:
      - ntpd_host=cn.pool.ntp.org
      - uptetime_timer=86400
      - freemem_timer=7200
    volumes:
      # docker api
      - "/var/run/docker.sock:/var/run/docker.sock"
      # free mem
      - "/proc/sys/vm/drop_caches:/drop_caches"
      # log
      - "./log/:/var/log/"
      # store
      - "./store/:/store/"
    container_name: sh
    cap_add:
      - SYS_TIME
    restart: always
	EOF
	
	sed  -i "s/\$dockerTagName/$dockerTagName/g"  /opt/docker/systemhelper/docker-compose.yml
	
	cd /opt/docker/systemhelper
	docker-compose down;docker-compose up -d
}


printInfo(){
	docker info
	docker -v
	docker-compose -v
}



# main function
main(){
	echo $ostype" : ["$platformtype"] -> "$dockerTagName
	
	#保存当前主机ip到 /etc/docker_host_ip
	updateHostIp
	
	# 安装依赖环境
	if [[ `echo $ostype | grep centos` != "" ]];then
		preInstallFromCentos
	elif [[ `echo $ostype | grep ubuntu` != "" ]];then
		preInstallFromUbuntu
	fi


	#安装docker
	installDocker
	
	#安装服务
	if [[ `echo $ostype | grep centos` != "" ]];then
		installServiceFromCentos
	elif [[ `echo $ostype | grep ubuntu` != "" ]];then
		installServiceFromUbuntu
	fi
	
	#安装助手 docker-compose 与 系统助手
	installHelper
	
	#打印
	printInfo
}



main


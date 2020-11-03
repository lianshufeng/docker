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
	#设置自动启动
	chkconfig docker on
}


#安装docker-compose
installDockerCompose(){
	# https://github.com/docker/compose/releases
	#curl -L http://dl.dzurl.top/1.27.4/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose
	#chmod +x /usr/local/bin/docker-compose
	yum install make gcc python3 python3-devel -y
	ln -sf /usr/bin/python3 /usr/bin/python
	pip3 install --upgrade pip
	pip install  docker-compose 
	

	
	
	
	# docker编译
	# dockerComposeTmpPath=/tmp/build/docker-compose
	# dockercomposeImageName=dockercompose
	# mkdir -p $dockerComposeTmpPath
	# echo "" > $dockerComposeTmpPath/Dockerfile
	# echo "FROM centos" >> $dockerComposeTmpPath/Dockerfile
	# echo "RUN yum install python3 python3-devel -y" >> $dockerComposeTmpPath/Dockerfile
	# echo "RUN ln -sf /usr/bin/python3 /usr/bin/python" >> $dockerComposeTmpPath/Dockerfile
	# echo "RUN pip3 install --upgrade pip" >> $dockerComposeTmpPath/Dockerfile
	# echo "RUN pip install docker-compose" >> $dockerComposeTmpPath/Dockerfile
	# cd $dockerComposeTmpPath
	# docker build ./ -f Dockerfile -t $dockercomposeImageName
	

	#构建命令行
	# DOCKER_HOST='/var/run/docker.sock'
    # DOCKER_ADDR="-v $DOCKER_HOST:$DOCKER_HOST"
	
	# echo exec docker run --rm -t -i $DOCKER_ADDR -w "/usr/local/bin/" $dockercomposeImageName /usr/local/bin/docker-compose > /usr/local/bin/docker-compose
	# cat /usr/local/bin/docker-compose
	# chmod +x /usr/local/bin/docker-compose
	
	# rm -rf $dockerComposeTmpPath
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
	mkdir -p /opt/docker/systemhelper	
	tee /opt/docker/systemhelper/docker-compose.yml <<-'EOF'
version: "3"
services:
  systemhelper:
    image: registry.cn-chengdu.aliyuncs.com/1s/systemhelper
    privileged: true
    environment:
      - ntpd_host=cn.pool.ntp.org
      - uptetime_timer=86400
      - freemem_timer=1800
    volumes:
      # docker api
      - "/var/run/docker.sock:/var/run/docker.sock"
      # free mem
      - "/proc/sys/vm/drop_caches:/drop_caches"
      # log
      - "./log/:/var/log/"
      # log
      - "./store/:/store/"
    container_name: sh
    cap_add:
      - SYS_TIME
    restart: always
	EOF
	
	cd /opt/docker/systemhelper
	docker-compose down;docker-compose up -d
}



#打印docker日志
printInfo(){
	docker info
	docker -v
	docker-compose -v
}


#更新docker主机的ip
updateDockerHostIp(){
	ip route get 1.2.3.4 | awk '{print $7}' | grep -v  '^\s*$'  > /etc/docker_host_ip
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

#获取主机ip
callFun "updateDockerHostIp"

#启动docker
callFun "startDocker"

#安装系统助手
callFun "installSystemHelper"

#打印服务
callFun "printInfo"



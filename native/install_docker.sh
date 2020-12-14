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
		# https://download.docker.com/linux/centos/8/x86_64/stable/Packages/
		#yum install -y http://dl.dzurl.top/containerd.io-1.3.7-3.1.el7.x86_64.rpm
		#自动寻找最新的版本
		containerd_url=https://mirrors.aliyun.com/docker-ce/linux/centos/7/$(uname -m)/stable/Packages/
		containerd=$(curl $containerd_url | grep containerd.io- | tail -1 );containerd=${containerd#*>};containerd=${containerd%<*}
		containerd_url=$containerd_url$containerd
		echo $containerd_url
		yum install -y $containerd_url
	fi
}

#禁用SELINUX：
disableSELINUX(){
	setenforce 0
	echo "SELINUX=disabled" > /etc/selinux/config
	echo "SELINUXTYPE=targeted" >> /etc/selinux/config
}

#设置防火墙
openFireWall(){
	#允许防火墙
	callFun "firewall-cmd --add-port=2376/tcp --permanent"
	callFun "firewall-cmd --add-port=2377/tcp --permanent"
	callFun "firewall-cmd --add-port=7946/tcp --permanent"
	callFun "firewall-cmd --add-port=7946/udp --permanent"
	callFun "firewall-cmd --add-port=4789/udp --permanent"
	
	#callFun "firewall-cmd --zone=public --add-masquerade --permanent"
	#callFun "firewall-cmd --permanent --zone=public --change-interface=docker0"
	#callFun "firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 4 -i docker0 -j ACCEPT"
	
	
	callFun "firewall-cmd --reload"
	

}

#安装docker
installDocker(){
	#curl -fsSL https://get.docker.com | sh
	curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
	sh /tmp/get-docker.sh --mirror Aliyun 
	rm -rf /tmp/get-docker.sh
	
	
	#设置自动启动
	chkconfig docker on
	
	#启动服务
	service docker start
	
}


#安装docker-compose
installDockerCompose(){
	tee /usr/local/bin/docker-compose <<-'EOF'
	#!/bin/sh
	if [[ $(uname -m) == "x86_64" ]];then tag="latest"; else tag=$(uname -m);fi
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):$(pwd) -w $(pwd) lianshufeng/docker-compose:$tag "$@"
	EOF
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



#安装系统助手:时间同步与缓存释放
installSystemHelper(){
	#cpu架构选择
	if [[ $(uname -m) == "x86_64" ]];then cpuUname="latest"; else cpuUname=$(uname -m);fi
	echo "cpu : $cpuUname"

	# 同步时区
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	mkdir -p /opt/docker/systemhelper	
	tee /opt/docker/systemhelper/docker-compose.yml <<-'EOF'
version: "3"
services:
  systemhelper:
    image: lianshufeng/systemhelper:$cpuUname
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
	
	#修改版本号
	sed  -i "s/\$cpuUname/$cpuUname/g"  /opt/docker/systemhelper/docker-compose.yml
	cat /opt/docker/systemhelper/docker-compose.yml
	
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

#禁用selinux
callFun "disableSELINUX"

#获取主机ip
callFun "updateDockerHostIp"

#docker加速器
callFun "updatePullImagesUrl"

#安装docker
callFun "installDocker"

#允许docker防火墙
callFun "openFireWall"

#安装DockerCompose
callFun "installDockerCompose"

#安装系统助手
callFun "installSystemHelper"

#打印服务
callFun "printInfo"



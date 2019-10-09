#!/bin/sh
# 适合 centos7及国内环境:
# 1、安装系统时间同步服务
# 2、修改镜像下载阿里的加速源
# 3、安装定期释放内存服务
# 4、修改docker存放路径为最大挂载磁盘路径根目录下
# 5、允许防火墙使用网络覆盖端口
#


#停止docker服务
stopDocker(){
	service  docker stop
}


#开启docker服务
startDocker(){
	service  docker start
}


#安装docker
installDocker_bakup(){
	#安装 docker
	yum install docker -y
	#设置自动启动
	chkconfig docker on
}


#更新docker
installDocker(){
#卸载与更新
	yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine	
	#设置稳定库	
	yum install -y yum-utils device-mapper-persistent-data lvm2
	#设置源
	# yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
	#设置阿里源
	yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
	#允许边缘库
	yum-config-manager --enable docker-ce-edge
	#安装docker
	yum install -y docker-ce docker-ce-cli containerd.io
	#设置自动启动
	chkconfig docker on
}


#安装释放内存
installFreeMem(){
	tee /opt/freemem.sh <<-'EOF'
	#!/bin/sh 
	#释放缓存
	function freemem {
		used=`free -m | awk 'NR==2' | awk '{print $3}'`
		free=`free -m | awk 'NR==2' | awk '{print $4}'`
		echo "===========================" >> /var/log/mem.log
		date >> /var/log/mem.log
		echo "Memory usage | [Use：${used}MB][Free：${free}MB]" >> /var/log/mem.log
		sync && echo 1 > /proc/sys/vm/drop_caches
		sync && echo 2 > /proc/sys/vm/drop_caches
		sync && echo 3 > /proc/sys/vm/drop_caches
		echo "OK" >> /var/log/mem.log

	}
	freemem 
	echo "freemem finish"
	EOF
	chmod 777 /opt/freemem.sh
	if [ `grep -c "/opt/freemem.sh" /etc/crontab` -eq '0' ] ;then
		echo "*/30 * * * * root /opt/freemem.sh" >> /etc/crontab
	fi
	sh /opt/freemem.sh
}


#设置防火墙
openFireWall(){
	#允许防火墙
	callFun "firewall-cmd --add-port=2376/tcp --permanent"
	callFun "firewall-cmd --add-port=2377/tcp --permanent"
	callFun "firewall-cmd --add-port=7946/tcp --permanent"
	callFun "firewall-cmd --add-port=7946/udp --permanent"
	callFun "firewall-cmd --add-port=4789/udp --permanent"
		
	callFun "firewall-cmd --reload"
	#禁用SELINUX：
	setenforce 0
	echo "SELINUX=disabled" > /etc/selinux/config
	echo "SELINUXTYPE=targeted" >> /etc/selinux/config
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




#设置同步时区
installUpdateTimeService(){
	yum -y install ntp ntpdate
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	tee /opt/updateTime.sh <<-'EOF'
	#!/bin/sh 
	#释放缓存
	function updateTime {
		ntpdate cn.pool.ntp.org
		hwclock --systohc
		echo "OK" >> /var/log/updateTime.log
	}
	updateTime 
	echo "updateTime finish"
	EOF
	chmod 777 /opt/updateTime.sh
	if [ `grep -c "/opt/updateTime.sh" /etc/crontab` -eq '0' ] ;then
		echo "* */12 * * * root /opt/updateTime.sh" >> /etc/crontab
	fi
	sh /opt/updateTime.sh
}


installCrond(){
	yum install -y vixie-cron crontabs 
	service crond start
	chkconfig crond on
}

#更新docker默认的保存位置
updateDockerStore(){
	dockerStore=`df -k | awk '{print $2 " " $6}' | sort -n -r | head -1 | awk '{print $2}'`
	if [  -d $dockerStore"/docker" ];then
		mv $dockerStore/docker $dockerStore/docker.bak
		rm -rf $dockerStore/docker
	fi
	
	#备份
	cp -rf /var/lib/docker $dockerStore/docker
	mv /var/lib/docker /var/lib/docker.bak
	ln -sf $dockerStore/docker /var/lib/docker

}

#更新docker主机的ip
updateDockerHostIp(){
	yum install -y hostname
	hostname -I | awk '{print $1}' > /etc/docker_host_ip
}




#打印docker日志
printInfo(){
	docker info
}



#动态执行方法
callFun(){
	echo "call : "$1 && $1
}


#安装调度器-释放内存与时间同步
callFun "installCrond"
callFun "installFreeMem"
callFun "installUpdateTimeService"

#安装dockert
callFun "installDocker"

callFun "startDocker"

callFun "stopDocker"


#防火墙
callFun "openFireWall"

#更新docker配置
callFun "updatePullImagesUrl"
callFun "updateDockerStore"


#设置主机内网ip
callFun "updateDockerHostIp"

#启动docker并打印
callFun "startDocker"
callFun "printInfo"








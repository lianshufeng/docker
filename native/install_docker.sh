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
	systemctl stop docker
}


#开启docker服务
startDocker(){
	systemctl start docker
}


#安装docker
installDocker(){
	yum install docker -y
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
	yum install vixie-cron -y
	yum install crontabs -y 
	service crond start
	if [ `grep -c "/opt/freemem.sh" /etc/crontab` -eq '0' ] ;then
		echo "*/30 * * * * root /opt/freemem.sh" >> /etc/crontab
	fi
	chkconfig crond on
	sh /opt/freemem.sh
}


#安装docker
openFireWall(){
	callFun "firewall-cmd --add-port=2376/tcp --permanent"
	callFun "firewall-cmd --add-port=2377/tcp --permanent"
	callFun "firewall-cmd --add-port=7946/tcp --permanent"
	callFun "firewall-cmd --add-port=7946/udp --permanent"
	callFun "firewall-cmd --add-port=4789/udp --permanent"
	callFun "firewall-cmd --reload"
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




#设置同步时区
setUpdateTimeService(){
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	yum -y install ntp ntpdate
	ntpdate cn.pool.ntp.org
	hwclock --systohc
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

#打印docker日志
printInfo(){
	docker info
}



#动态执行方法
callFun(){
	echo "call : "$1 && $1
}




callFun "installFreeMem"
callFun "setUpdateTimeService"
callFun "installDocker" 
callFun "openFireWall" 
callFun "stopDocker" 
callFun "updatePullImagesUrl"
callFun "updateDockerStore"
callFun "startDocker"
callFun "printInfo"





#安装docker
installDocker(){
	#卸载
	yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine	
	#设置稳定库	
	yum install -y yum-utils device-mapper-persistent-data lvm2
	#设置阿里源
	yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
	#安装docker
	yum install -y docker-ce docker-ce-cli containerd.io
}


installDocker
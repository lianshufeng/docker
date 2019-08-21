#安装docker
installDocker(){
	#安装 docker
	yum install docker -y
	#设置自动启动
	chkconfig docker on
}



installDocker
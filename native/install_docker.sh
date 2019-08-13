#!/bin/sh


#安装docker
install_docker(){
	echo "install docker "
	curl -fsSL https://raw.githubusercontent.com/lianshufeng/docker/master/native/install_docker_no_compose.sh | sh
}




#安装docker
install_compose(){
	#安装 docker-compose
	sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
}



#动态执行方法
callFun(){
	echo "call : "$1 && $1
}


callFun "install_compose"
callFun "install_docker"





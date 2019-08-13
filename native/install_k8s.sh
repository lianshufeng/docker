#!/bin/sh
# 暂只兼容 centos7 以上
#
#


#安装docker
install_docker(){
	echo "install docker "
	curl -fsSL https://raw.githubusercontent.com/lianshufeng/docker/master/native/install_docker_no_compose.sh | sh
}


#安装k8s
install_k8s(){
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
# 阿里源
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/

enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

systemctl enable --now kubelet
}


#设置防火墙
set_Firewall(){
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
}


#系统配置
config_os(){

	#禁用 swap
	swapoff -a
	sed -ri 's/.*swap.*/#&/' /etc/fstab


	#防火墙
	firewall-cmd --add-port=6443/tcp --permanent
	firewall-cmd --add-port=2379-2380/tcp --permanent
	firewall-cmd --add-port=10250/tcp --permanent
	firewall-cmd --add-port=10251/tcp --permanen
	firewall-cmd --add-port=10252/tcp --permanent

	firewall-cmd --add-port=1025/tcp --permanent
	firewall-cmd --add-port=30000-32767/tcp --permanent
	firewall-cmd --reload

	#禁用SELINUX：
	setenforce 0
	echo "SELINUX=disabled" > /etc/selinux/config
	echo "SELINUXTYPE=targeted" >> /etc/selinux/config


}

#更新本地镜像
pull_image(){
	#获取镜像列表
	#kubeadm config images list

	images=(
	kube-apiserver:v1.15.2
	kube-controller-manager:v1.15.2
	kube-scheduler:v1.15.2
	kube-proxy:v1.15.2
	pause:3.1
	etcd:3.3.10
	coredns:1.3.1
	)

	for imageName in ${images[@]};do
		docker pull gcr.azk8s.cn/google-containers/$imageName  
		docker tag  gcr.azk8s.cn/google-containers/$imageName k8s.gcr.io/$imageName  
		docker rmi  gcr.azk8s.cn/google-containers/$imageName
	done
	
}


set_Firewall
config_os
install_docker
install_k8s
pull_image
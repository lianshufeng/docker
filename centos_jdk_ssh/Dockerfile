#
# 安装： docker build -t jdk_ssh   ./ 
# 运行： docker run -d -p 8822:22 -e ROOT_PASSWORD="root" jdk_ssh
# 例子： docker run -d -p 8822:22 -v /opt/jars:/opt/jars -w /opt/jars/ jdk
# 备注 : -p 端口映射 ; -v 挂载目录 ; -w 工作空间 ; -e 环境变量  ; --restart always 随docker服务启动 
#


FROM lianshufeng/jdk
MAINTAINER lianshufeng <251708339@qq.com>


#运行变量 -e
ENV ROOT_PASSWORD "root"
ENV ENTRYPOINT ""

#安装openssh和unzip工具
RUN rpm --rebuilddb
RUN yum install openssh-server -y


#配置ssh的登陆证书
RUN set -xe \
	#配置 ssh-server
	&& ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N '' \
	&& ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' \
	&& ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N '' \
	&& ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N '' \
	&& sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config \
	&& sed -i "s/#UseDNS yes.*/UseDNS no/g" /etc/ssh/sshd_config \
	&& sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config 

	
#外部端口22
EXPOSE 22


#创建修改密码的脚本，通过传递参数修改
RUN set -xe \
	#修改密码脚本，仅执行一次
	&& echo "#!/bin/bash" > /tmp/pass.sh \
	&& echo "echo root:"\$ROOT_PASSWORD"| chpasswd" >> /tmp/pass.sh \
	&& echo "echo "" > /tmp/pass.sh" >> /tmp/pass.sh \
	#引导程序
	&& echo "sh /tmp/pass.sh" >> /opt/bootstrap.sh \
	&& echo "/usr/sbin/sshd -D" >> /opt/bootstrap.sh 
	

	







#
# 安装： docker build -t springboot --build-arg JAVA_HOME="/opt/jdk"  ./ 
# 运行： docker run -d -p 8822:22 -e ROOT_PASSWORD="root" springboot
# 例子： docker run -d -p 8822:22 -v /opt/jars:/opt/jars -w /opt/jars/ -e ENTRYPOINT="nohup java -jar Idea.jar" --restart always springboot
# 备注 : -p 端口映射 ; -v 挂载目录 ; -w 工作空间 ; -e 环境变量 ($ENTRYPOINT 启动命令) ; --restart always 随docker服务启动 
#


FROM centos:7.5.1804
MAINTAINER lianshufeng <251708399@qq.com>

#构建参数 --build-arg
ARG JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u172-b11/a58eab1ec242421181065cdc37240b08/jdk-8u172-linux-x64.tar.gz"
ARG JAVA_HOME="/opt/jdk"


#运行变量 -e
ENV ROOT_PASSWORD "root"
ENV ENTRYPOINT ""

#安装openssh和unzip工具
RUN rpm --rebuilddb
RUN yum install unzip openssh-server wget -y


#配置ssh的登陆证书
RUN set -xe \
	#配置 ssh-server
	&& ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N '' \
	&& ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' \
	&& ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N '' \
	&& ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N '' \
	&& sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config \
	&& sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config 

	
#下载 JDK
RUN wget -O /opt/jdk.tar.gz --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" $JDK_URL

#解压并设置环境
RUN set -xe \
	&& tar -xvzf /opt/jdk.tar.gz -C /opt \
	&& rm -rf /opt/jdk.tar.gz \
	&& mkdir -p $JAVA_HOME \
	&& rm -rf $JAVA_HOME \
	&& mv /opt/$(ls /opt/ | grep jdk) $JAVA_HOME \
	#环境变量
	&& echo "" >> /etc/profile \
	&& echo "JAVA_HOME="$JAVA_HOME >> /etc/profile \
	&& echo "PATH="$JAVA_HOME"/bin:$PATH" >> /etc/profile \
	&& echo "CLASSPATH=.:"$JAVA_HOME"/lib/dt.jar:"$JAVA_HOME"/lib/tools.jar" >> /etc/profile \
	&& echo "export JAVA_HOME" >> /etc/profile \
	&& echo "export PATH" >> /etc/profile \
	&& echo "export CLASSPATH" >> /etc/profile \
	#刷新环境变量
	&& source /etc/profile \
	#设置时区
	&& cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 

	
	
	
#设置读写权限
RUN chmod -R 777 $JAVA_HOME

#外部端口22
EXPOSE 22


#创建修改密码的脚本，通过传递参数修改
RUN set -xe \
	#修改密码脚本
	&& echo "#!/bin/bash" > /tmp/pass.sh \
	&& echo "echo root:"\$1"| chpasswd" >> /tmp/pass.sh \
	#引导程序
	&& echo "#!/bin/bash" > /opt/bootstrap.sh \
	&& echo "source /etc/profile" >> /opt/bootstrap.sh \
	&& echo "sh /tmp/pass.sh \$ROOT_PASSWORD" >> /opt/bootstrap.sh \
	&& echo "echo "" > /tmp/pass.sh" >> /opt/bootstrap.sh \
	#依次执行
	&& echo "echo \${ENTRYPOINT}|awk '{run=\$0;system(run)}'" >> /opt/bootstrap.sh 
	
	
#启动项
ENTRYPOINT  sh /opt/bootstrap.sh & /usr/sbin/sshd -D

	







#
# 安装： docker build -t jdk --build-arg JAVA_HOME="/opt/jdk"  ./ 
# 运行： docker run -d -p 8822:22 -e ROOT_PASSWORD="root" jdk
# 例子： docker run -d -p 8822:22 -v /opt/jars:/opt/jars -w /opt/jars/ jdk
# 备注 : -p 端口映射 ; -v 挂载目录 ; -w 工作空间 ; -e 环境变量  ; --restart always 随docker服务启动 
#


FROM centos:latest
MAINTAINER lianshufeng <251708339@qq.com>

#构建参数 --build-arg
ARG JDK_URL="https://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jdk-8u201-linux-x64.tar.gz"
ARG JAVA_HOME="/opt/jdk"


#运行变量 -e
ENV ROOT_PASSWORD "root"
ENV ENTRYPOINT ""

#安装wget和unzip工具
RUN rpm --rebuilddb
RUN yum install unzip  wget -y

	
#下载 JDK
RUN wget -O /tmp/jdk.tar.gz --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" $JDK_URL
#解压并设置环境
RUN set -xe \
	&& mkdir /tmp/jdk \
	&& tar -xvzf /tmp/jdk.tar.gz -C /tmp/jdk \
	&& rm -rf /tmp/jdk.tar.gz \
	&& mkdir -p $JAVA_HOME \
	&& rm -rf $JAVA_HOME \
	&& mv /tmp/jdk/$(ls /tmp/jdk/) $JAVA_HOME \
	&& rm -rf /tmp/jdk \
	&& chmod -R 777 $JAVA_HOME \
	#环境变量
	&& echo "" >> /etc/profile \
	&& echo "JAVA_HOME="$JAVA_HOME >> /etc/profile \
	&& echo "PATH="\$JAVA_HOME"/bin:\$PATH" >> /etc/profile \
	&& echo "CLASSPATH=.:"\$JAVA_HOME"/lib/dt.jar:"\$JAVA_HOME"/lib/tools.jar" >> /etc/profile \
	&& echo "export JAVA_HOME" >> /etc/profile \
	&& echo "export PATH" >> /etc/profile \
	&& echo "export CLASSPATH" >> /etc/profile \
	#刷新环境变量
	&& source /etc/profile \
	#设置时区
	&& cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 



#创建修改密码的脚本，通过传递参数修改
RUN set -xe \
	#引导程序
	&& echo "#!/bin/bash" > /opt/bootstrap.sh \
	&& echo "source /etc/profile" >> /opt/bootstrap.sh \
	&& echo "export LANG=en_US.UTF-8" >> /opt/bootstrap.sh 
	
	
#启动项
ENTRYPOINT  sh /opt/bootstrap.sh 

	







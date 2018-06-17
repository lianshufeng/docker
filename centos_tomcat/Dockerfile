#
# centos7.5 + ssh-server + jdk1.8(sun) + tomcat8.5
#
# build : 
# docker build -t tomcat --build-arg JAVA_HOME="/opt/runtime/jdk"  --build-arg TOMCAT_HOME="/opt/runtime/tomcat"  ./ 
#
# run :
# docker run -d -p 8822:22 -p 8080:8080  tomcat
#
# setVM (JAVA_OPTS) :
# docker run -d -p 8822:22 -p 8080:8080 -e TOMCAT_VM="-Xms300m -Xmx600m" tomcat
#


FROM centos:7.5.1804
MAINTAINER lianshufeng <251708339@qq.com>

#构建参数 --build-arg
ARG JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u172-b11/a58eab1ec242421181065cdc37240b08/jdk-8u172-linux-x64.tar.gz"
ARG JAVA_HOME="/opt/jdk"
ARG TOMCAT_URL="http://mirror.bit.edu.cn/apache/tomcat/tomcat-8/v8.5.31/bin/apache-tomcat-8.5.31.tar.gz"
ARG TOMCAT_HOME="/opt/tomcat"



#运行变量 -e
ENV ROOT_PASSWORD "root"
ENV TOMCAT_VM "-Xms1024m -Xmx2048m -Duser.timezone=GMT+8 -Djava.security.egd=file:/dev/./urandom"


#安装openssh
RUN rpm --rebuilddb
RUN yum install openssh-server wget -y


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
RUN wget -O /tmp/jdk.tar.gz --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" $JDK_URL
#解压并设置环境
RUN set -xe \
	&& mkdir /tmp/jdk \
	&& tar -xvzf /tmp/jdk.tar.gz -C /tmp/jdk \
	&& rm -rf /tmp/jdk.tar.gz \
	&& mkdir -p $JAVA_HOME \
	&& rm -rf $JAVA_HOME \
	&& mv /tmp/jdk/$(ls /tmp/jdk/ | grep jdk) $JAVA_HOME \
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



	
	
#下载 tomcat
RUN wget -O /tmp/tomcat.tar.gz --no-cookies --no-check-certificate  $TOMCAT_URL
#解压并设置环境
RUN set -xe \
	&& mkdir /tmp/tomcat \
	&& tar -xvzf /tmp/tomcat.tar.gz -C /tmp/tomcat \
	&& rm -rf /tmp/tomcat.tar.gz \
	&& mkdir -p $TOMCAT_HOME \
	&& rm -rf $TOMCAT_HOME \
	&& mv /tmp/tomcat/$(ls /tmp/tomcat/ | grep tomcat) $TOMCAT_HOME \
	&& chmod -R 777 $TOMCAT_HOME \
	&& rm -rf /tmp/tomcat \
	#环境变量
	&& echo "" >> /etc/profile \
	&& echo "TOMCAT_HOME="$TOMCAT_HOME >> /etc/profile \
	&& echo "PATH="\$TOMCAT_HOME"/bin:\$PATH" >> /etc/profile \
	&& echo "export TOMCAT_HOME" >> /etc/profile \
	&& echo "export PATH" >> /etc/profile \
	#刷新环境变量
	&& source /etc/profile \




#ssh-server
EXPOSE 22
#tomcat
EXPOSE 8080


#创建修改密码的脚本，通过传递参数修改
RUN set -xe \
	#修改密码脚本,仅支持一次
	&& echo "#!/bin/bash" > /tmp/pass.sh \
	&& echo "echo root:"\$ROOT_PASSWORD"| chpasswd" >> /tmp/pass.sh \
	&& echo "echo "" > /tmp/pass.sh" >> /tmp/pass.sh \
	
	#修改tomcat启动命令行
	&& echo "#!/bin/bash" > /tmp/tomcat.sh \
	&& echo "echo JAVA_OPTS=\'\$TOMCAT_VM\' > /tmp/tomcat.run" >> /tmp/tomcat.sh \
	&& echo "cat /tmp/tomcat.run \$TOMCAT_HOME/bin/catalina.sh > \$TOMCAT_HOME/bin/catalina.sh.bak" >> /tmp/tomcat.sh \
	&& echo "rm -rf /tmp/tomcat.run" >> /tmp/tomcat.sh \
	&& echo "rm -rf \$TOMCAT_HOME/bin/catalina.sh" >> /tmp/tomcat.sh \
	&& echo "mv \$TOMCAT_HOME/bin/catalina.sh.bak \$TOMCAT_HOME/bin/catalina.sh" >> /tmp/tomcat.sh \
	&& echo "chmod -R 777 \$TOMCAT_HOME/bin/catalina.sh" >> /tmp/tomcat.sh \
	&& echo "echo "" > /tmp/tomcat.sh" >> /tmp/tomcat.sh \
	
	#引导程序
	&& echo "#!/bin/bash" > /opt/bootstrap.sh \
	&& echo "source /etc/profile" >> /opt/bootstrap.sh \
	&& echo "sh /tmp/pass.sh" >> /opt/bootstrap.sh \
	&& echo "sh /tmp/tomcat.sh" >> /opt/bootstrap.sh \
	&& echo "sh $TOMCAT_HOME/bin/startup.sh" >> /opt/bootstrap.sh 
	
	
#启动项
ENTRYPOINT  sh /opt/bootstrap.sh & /usr/sbin/sshd -D

	







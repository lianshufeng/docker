#
# centos7.5 + ssh-server + jdk1.8(sun) + tomcat8.5
#
# build : 
# docker build -t tomcat --build-arg JAVA_HOME="/opt/runtime/jdk"  --build-arg TOMCAT_HOME="/opt/runtime/tomcat"  ./ 
#
# run :
# docker run -d -p 8822:22 -p 8080:8080  lianshufeng/tomcat
#
# setVM (JAVA_OPTS) :
# docker run -d -p 8822:22 -p 8080:8080 -e TOMCAT_VM="-Xms300m -Xmx600m" lianshufeng/tomcat
#


FROM lianshufeng/jdk
MAINTAINER lianshufeng <251708339@qq.com>

#构建参数 --build-arg
ARG TOMCAT_URL="http://mirror.bit.edu.cn/apache/tomcat/tomcat-8/v8.5.31/bin/apache-tomcat-8.5.31.tar.gz"
ARG TOMCAT_HOME="/opt/tomcat"



#运行变量 -e
ENV TOMCAT_VM "-Xms1024m -Xmx2048m -Duser.timezone=GMT+8 -Djava.security.egd=file:/dev/./urandom"

		
#下载 tomcat
RUN wget -O /tmp/tomcat.tar.gz --no-cookies --no-check-certificate  $TOMCAT_URL
#解压并设置环境
RUN set -xe \
	&& mkdir /tmp/tomcat \
	&& tar -xvzf /tmp/tomcat.tar.gz -C /tmp/tomcat \
	&& rm -rf /tmp/tomcat.tar.gz \
	&& mkdir -p $TOMCAT_HOME \
	&& rm -rf $TOMCAT_HOME \
	&& mv /tmp/tomcat/$(ls /tmp/tomcat/ ) $TOMCAT_HOME \
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
	&& echo "sh /tmp/tomcat.sh" >> /opt/bootstrap.sh \
	&& echo "sh $TOMCAT_HOME/bin/startup.sh" >> /opt/bootstrap.sh 
	
	

	






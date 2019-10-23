#
# centos7.5 + ssh-server + jdk1.8(sun) + tomcat9.0
#
# build : 
# docker build -t lianshufeng/tomcat ./
#
# run :
# docker run -d -p 8822:22 -p 8080:8080  lianshufeng/tomcat
#
# setVM (JAVA_OPTS) :
# docker run -d -p 8822:22 -p 8080:8080 -e TOMCAT_VM="-Xms300m -Xmx600m" lianshufeng/tomcat
#
# -v
# docker run  --privileged=true -d -p 8822:22 -p 8080:8080 -v /opt/tomcat/conf:/opt/tomcat/conf -v /opt/tomcat/webapps:/opt/tomcat/webapps  lianshufeng/tomcat
# 


FROM lianshufeng/jdk_ssh
MAINTAINER lianshufeng <251708339@qq.com>

#构建参数 --build-arg
ARG TOMCAT_URL="http://build.dzurl.top/apache-tomcat-9.0.27.tar.gz"
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

#备份配置文件
RUN cp -rf $TOMCAT_HOME/conf $TOMCAT_HOME/conf.backup
RUN set -xe \
	#修改tomcat启动命令行
	&& echo "#!/bin/bash" > /tmp/tomcat_conf.sh \	
	#若配置文件为空则自动恢复配置文件的备份
	&& echo "if [[ \$(ls \$TOMCAT_HOME/conf -l |grep '^-'|wc -l) -eq 0 ]] ; then cp -rf  \$TOMCAT_HOME/conf.backup/. \$TOMCAT_HOME/conf/; fi" >> /tmp/tomcat_conf.sh \
	&& echo "rm -rf \$TOMCAT_HOME/conf.backup " >> /tmp/tomcat_conf.sh \
	&& echo "echo "" > /tmp/tomcat_conf.sh" >> /tmp/tomcat_conf.sh 

	
#创建修改密码的脚本，通过传递参数修改
RUN set -xe \
	#修改tomcat启动命令行
	&& echo "#!/bin/bash" > /tmp/tomcat.sh \
	#修改vm
	&& echo "echo JAVA_OPTS=\'\$TOMCAT_VM\' > /tmp/tomcat.run" >> /tmp/tomcat.sh \
	&& echo "cat /tmp/tomcat.run \$TOMCAT_HOME/bin/catalina.sh > \$TOMCAT_HOME/bin/catalina.sh.bak" >> /tmp/tomcat.sh \
	&& echo "rm -rf /tmp/tomcat.run" >> /tmp/tomcat.sh \
	&& echo "rm -rf \$TOMCAT_HOME/bin/catalina.sh" >> /tmp/tomcat.sh \
	&& echo "mv \$TOMCAT_HOME/bin/catalina.sh.bak \$TOMCAT_HOME/bin/catalina.sh" >> /tmp/tomcat.sh \
	&& echo "chmod -R 777 \$TOMCAT_HOME/bin/catalina.sh" >> /tmp/tomcat.sh \
	&& echo "echo "" > /tmp/tomcat.sh" >> /tmp/tomcat.sh \
	
	#引导程序
	&& echo "sh /tmp/tomcat_conf.sh" >> /opt/run.sh \
	&& echo "sh /tmp/tomcat.sh" >> /opt/run.sh \
	&& echo "nohup $TOMCAT_HOME/bin/startup.sh" >> /opt/run.sh 
	
	

	







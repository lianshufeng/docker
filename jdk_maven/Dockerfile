#依赖镜像
FROM registry.cn-chengdu.aliyuncs.com/1s/jdk
MAINTAINER lianshufeng <251708339@qq.com>


#依赖的环境变量
ARG MAVEN_FOLDER="apache-maven-3.6.3"
ARG MAVEN_URL="http://mirror.metrocast.net/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.zip"
ARG MAVEN_HOME="/opt/maven/"


#下载 tomcat
RUN wget -O /tmp/maven.zip --no-cookies --no-check-certificate  $MAVEN_URL


#解压并设置环境
RUN set -xe \
	&& mkdir -p $MAVEN_HOME
	&& unzip -o /tmp/maven.zip -d $MAVEN_HOME \
	&& rm -rf /tmp/maven.zip \
	&& chmod -R 777 $MAVEN_HOME \
	#环境变量
	&& echo "" >> /etc/profile \
	&& echo "MAVEN_HOME="$MAVEN_HOME >> /etc/profile \
	&& echo "PATH="\$MAVEN_HOME"/bin:\$PATH" >> /etc/profile \
	&& echo "export MAVEN_HOME" >> /etc/profile \
	&& echo "export PATH" >> /etc/profile \
	#刷新环境变量
	&& source /etc/profile 



	
	

	







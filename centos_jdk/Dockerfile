#
# 安装： docker build -t lianshufeng/jdk --build-arg JAVA_HOME="/opt/jdk"  ./ 
#


FROM centos:8 as builder
MAINTAINER lianshufeng <251708339@qq.com>


#构建参数 --build-arg
ARG JDK_URL="http://dl.jpy.wang/jdk-11.0.15.1_linux-x64_bin.tar.gz"
ARG JAVA_HOME="/opt/jdk"


#运行变量 -e
ENV ENTRYPOINT ""

# upgrade
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-* &&\
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*
# docker
RUN yum upgrade -y


#安装wget和unzip工具
RUN yum install wget -y
#修改系统默认编码
RUN echo LANG=\"zh_CN.utf8\" > /etc/locale.conf
	
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
	&& chmod -R 777 $JAVA_HOME 

#运行环境
FROM centos:8 as runtime
ARG JAVA_HOME="/opt/jdk"

#运行变量 -e
ENV ENTRYPOINT ""

# upgrade
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-* &&\
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*
# docker
RUN yum upgrade -y


#安装wget和unzip工具
#RUN rpm --rebuilddb ,centos8 不需要
RUN yum install unzip  wget curl fontconfig langpacks-zh_CN jq -y
#修改系统默认编码
RUN echo LANG=\"zh_CN.utf8\" > /etc/locale.conf
	
#编译中拷贝文件
COPY --from=builder $JAVA_HOME $JAVA_HOME
#解压并设置环境
RUN set -xe \
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

#创建启动脚本
COPY ./bootstrap.sh /opt/bootstrap.sh 
COPY ./wait_java_exit.sh /opt/wait_java_exit.sh 

#启动项
ENTRYPOINT ["sh", "/opt/bootstrap.sh"]

	







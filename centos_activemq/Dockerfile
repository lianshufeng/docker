#
# 安装： docker build -t activemq   ./ 
# 运行： docker run -d -p 8822:22 -e ROOT_PASSWORD="root" lianshufeng/activemq
# docker run --privileged=true -d -p 8822:22 -p 8161:8161 -p 61616:61616 -p 5672:5672 -p 61613:61613 -p 1882:1882 -p 61614:61614  -v /opt/activemq/conf:/opt/activemq/conf  -v /opt/activemq/data:/opt/activemq/data lianshufeng/activemq
# 备注 : -p 端口映射 ; -v 挂载目录 ; -w 工作空间 ; -e 环境变量 ; --restart always 随docker服务启动  ; --privileged=true 特权
#


FROM lianshufeng/jdk
MAINTAINER lianshufeng <251708339@qq.com>

#构建参数 --build-arg
ARG ACTIVEMQ_URL="http://mirrors.hust.edu.cn/apache/activemq/5.15.4/apache-activemq-5.15.4-bin.tar.gz"
ARG ACTIVEMQ_HOME="/opt/activemq"



	
#下载
RUN wget -O /tmp/mq.tar.gz --no-cookies --no-check-certificate $ACTIVEMQ_URL
#解压并设置环境
RUN set -xe \
	&& mkdir /tmp/mq \
	&& tar -xvzf /tmp/mq.tar.gz -C /tmp/mq \
	&& rm -rf /tmp/mq.tar.gz \
	&& mkdir -p $ACTIVEMQ_HOME \
	&& rm -rf $ACTIVEMQ_HOME \
	&& mv /tmp/mq/$(ls /tmp/mq/ ) $ACTIVEMQ_HOME \
	&& rm -rf /tmp/mq \
	&& chmod -R 777 $ACTIVEMQ_HOME \
	#环境变量
	&& echo "" >> /etc/profile \
	&& echo "ACTIVEMQ_HOME="$ACTIVEMQ_HOME >> /etc/profile \
	&& echo "PATH="\$ACTIVEMQ_HOME"/bin:\$PATH" >> /etc/profile \
	&& echo "export ACTIVEMQ_HOME" >> /etc/profile \
	&& echo "export PATH" >> /etc/profile \
	#刷新环境变量
	&& source /etc/profile


#外部端口22
EXPOSE 22
EXPOSE 8161
EXPOSE 61616
EXPOSE 5672
EXPOSE 61613
EXPOSE 1883
EXPOSE 61614


#自动启动脚本
RUN echo "$ACTIVEMQ_HOME/bin/activemq start" >> /opt/bootstrap.sh




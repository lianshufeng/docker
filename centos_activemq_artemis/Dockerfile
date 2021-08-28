#
# 安装： docker build -t activemq   ./ 
# 运行： docker run -d -p 8822:22 -e ROOT_PASSWORD="root" lianshufeng/activemq

# 备注 : -p 端口映射 ; -v 挂载目录 ; -w 工作空间 ; -e 环境变量 ; --restart always 随docker服务启动  ; --privileged=true 特权
#


FROM lianshufeng/jdk_ssh as builder
MAINTAINER lianshufeng <251708339@qq.com>

#构建参数 --build-arg
ARG ACTIVEMQ_URL="https://dlcdn.apache.org/activemq/activemq-artemis/2.18.0/apache-artemis-2.18.0-bin.tar.gz"
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
	&& chmod -R 777 $ACTIVEMQ_HOME



FROM lianshufeng/jdk_ssh as runtime
#构建参数 --build-arg
ARG Broker_Store="/opt/broker"

ARG ACTIVEMQ_HOME="/opt/activemq"
ARG Broker_User="admin"
ARG Broker_Password="admin"
ARG Broker_Role="admins"



#编译中拷贝文件
COPY --from=builder $ACTIVEMQ_HOME $ACTIVEMQ_HOME
	
RUN set -xe \
	#环境变量
	&& echo "" >> /etc/profile \
	&& echo "ACTIVEMQ_HOME="$ACTIVEMQ_HOME >> /etc/profile \
	&& echo "PATH="\$ACTIVEMQ_HOME"/bin:\$PATH" >> /etc/profile \
	&& echo "export ACTIVEMQ_HOME" >> /etc/profile \
	&& echo "export PATH" >> /etc/profile \
	#刷新环境变量
	&& source /etc/profile


#ssh
EXPOSE 22
# Web Server
EXPOSE 8161 
# JMX Exporter
EXPOSE 9404 
# Port for CORE,MQTT,AMQP,HORNETQ,STOMP,OPENWIRE
EXPOSE 61616 
# Port for HORNETQ,STOMP
EXPOSE 5445 
# Port for AMQP
EXPOSE 5672 
# Port for MQTT
EXPOSE 1883 
#Port for STOMP
EXPOSE 61613


#构建 Broker
RUN source /etc/profile && artemis create --user $Broker_User --password $Broker_Password --allow-anonymous –role $Broker_Role $Broker_Store



#允许任何ip访问控制台
RUN sed -i "s/localhost:8161/0.0.0.0:8161/g" $Broker_Store/etc/bootstrap.xml
RUN sed -i "s/localhost\*/\*/g" $Broker_Store/etc/jolokia-access.xml


#备份配置文件
RUN cp -rf $Broker_Store $Broker_Store.backup
RUN set -xe \
	# 修改tomcat启动命令行
	&& echo "#!/bin/bash" > /tmp/mq_conf.sh \	
	# 若配置文件为空则自动恢复配置文件的备份
	&& echo "if [[ \$(ls \\$Broker_Store -l |grep '^-'|wc -l) -eq 0 ]] ; then cp -rf  \\$Broker_Store.backup/. \\$Broker_Store/; fi" >> /tmp/mq_conf.sh \
	&& echo "rm -rf \\$Broker_Store.backup " >> /tmp/mq_conf.sh \
	&& echo "echo "" > /tmp/mq_conf.sh" >> /tmp/mq_conf.sh 
RUN echo "sh /tmp/mq_conf.sh" >> /opt/run.sh

#启动
RUN echo "$Broker_Store/bin/artemis-service start" >> /opt/run.sh





#
# 安装： docker build -t activemq   ./ 
# 运行： docker run -d -p 8822:22 -e ROOT_PASSWORD="root" lianshufeng/activemq

# 备注 : -p 端口映射 ; -v 挂载目录 ; -w 工作空间 ; -e 环境变量 ; --restart always 随docker服务启动  ; --privileged=true 特权
#


FROM lianshufeng/jdk_ssh as builder
MAINTAINER lianshufeng <251708339@qq.com>

#构建参数 --build-arg
ARG ACTIVEMQ_URL="https://www.apache.org/dyn/closer.cgi?filename=activemq/activemq-artemis/2.18.0/apache-artemis-2.18.0-bin.tar.gz&action=download"
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
ARG ACTIVEMQ_HOME="/opt/activemq"
ARG Broker_Store="/opt/broker"


ENV Broker_User="admin"
ENV Broker_Password="admin"
ENV Broker_Role="admins"



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



#生成构建  broker 命令
RUN set -xe \
	&& echo "#!/bin/bash" > /tmp/make_broker.sh \	
    && echo "source /etc/profile" >> /tmp/make_broker.sh \
    && echo "artemis create --require-login --user \$Broker_User --password \$Broker_Password  –role \$Broker_Role $Broker_Store" >> /tmp/make_broker.sh \
    && echo "sed -i \"s/localhost:8161/0.0.0.0:8161/g\" $Broker_Store/etc/bootstrap.xml" >> /tmp/make_broker.sh \
    && echo "sed -i \"s/localhost\*/\*/g\" $Broker_Store/etc/jolokia-access.xml" >> /tmp/make_broker.sh 


#拷贝更新文件
RUN set -xe \
	&& echo "#!/bin/bash" > /tmp/update_broker.sh \	
    && echo "source /etc/profile" >> /tmp/update_broker.sh \
    && echo "cp -f /opt/broker_update.xml $Broker_Store/etc/broker.xml" >> /tmp/update_broker.sh \
	&& echo "hn=\$(eval hostname)" >> /tmp/update_broker.sh \
    && echo "sed -i \"s/{MQHOST}/\$hn/g\" $Broker_Store/etc/broker.xml" >> /tmp/update_broker.sh 




#执行条件
RUN set -xe \
	&& echo "#!/bin/bash" > /tmp/mq_run.sh \	
	&& echo "if [[ \$(ls \\$Broker_Store -l |grep '^-'|wc -l) -eq 0 ]] ; then sh /tmp/make_broker.sh ; fi" >> /tmp/mq_run.sh \
	&& echo "if [[ -f "/opt/broker_update.xml" ]] ; then sh /tmp/update_broker.sh ; fi" >> /tmp/mq_run.sh 
RUN echo "sh /tmp/mq_run.sh" >> /opt/run.sh



#启动
RUN echo "$Broker_Store/bin/artemis-service start" >> /opt/run.sh





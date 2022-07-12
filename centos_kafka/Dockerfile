#
# 安装： docker build -t lianshufeng/kafka   ./ 
# 运行： docker run -d -p 8822:22 -e ROOT_PASSWORD="root" lianshufeng/kafka
# 例子： docker run -d -p 8822:22 -p 2181:2181 -p 9092:9092 lianshufeng/kafka


FROM lianshufeng/jdk as builder
MAINTAINER lianshufeng <251708339@qq.com>

#构建参数 --build-arg
ARG KAFKA_URL="https://dlcdn.apache.org/kafka/3.2.0/kafka_2.13-3.2.0.tgz"
ARG KAFKA_HOME="/opt/kafka"

#下载
RUN wget -O /tmp/kafka.tar.gz --no-cookies --no-check-certificate $KAFKA_URL
#解压
RUN set -xe \
	&& mkdir /tmp/kafka \
	&& tar -xvzf /tmp/kafka.tar.gz -C /tmp/kafka \
	&& rm -rf /tmp/kafka.tar.gz \
	&& mkdir -p $KAFKA_HOME \
	&& rm -rf $KAFKA_HOME \
	&& mv /tmp/kafka/$(ls /tmp/kafka/ ) $KAFKA_HOME \
	&& rm -rf /tmp/kafka \
	&& chmod -R 777 $KAFKA_HOME



FROM lianshufeng/jdk as runtime
ARG KAFKA_HOME="/opt/kafka"
#编译中拷贝文件
COPY --from=builder $KAFKA_HOME $KAFKA_HOME

#解压并设置环境
RUN set -xe \
	#环境变量
	&& echo "" >> /etc/profile \
	&& echo "KAFKA_HOME="$KAFKA_HOME >> /etc/profile \
	&& echo "PATH="\$KAFKA_HOME"/bin:\$PATH" >> /etc/profile \
	&& echo "export KAFKA_HOME" >> /etc/profile \
	&& echo "export PATH" >> /etc/profile \
	#刷新环境变量
	&& source /etc/profile
	
	
#外部端口22
EXPOSE 22
EXPOSE 2181
EXPOSE 9092

RUN cp -rf $KAFKA_HOME/config $KAFKA_HOME/config.backup
RUN set -xe \
	#修改启动命令行
	&& echo "#!/bin/bash" > /tmp/kafka_conf.sh \	
	#若配置文件为空则自动恢复配置文件的备份
	&& echo "if [[ \$(ls \$KAFKA_HOME/config -l |grep '^-'|wc -l) -eq 0 ]] ; then cp -rf  \$KAFKA_HOME/config.backup/. \$KAFKA_HOME/config/; fi" >> /tmp/kafka_conf.sh \
	&& echo "rm -rf \$KAFKA_HOME/config.backup " >> /tmp/kafka_conf.sh \
	&& echo "echo "" > /tmp/kafka_conf.sh" >> /tmp/kafka_conf.sh 


	
# 集群方案
RUN yum install iproute  -y
ENV KAFKA_LISTENERS ""
ENV ZOOKEEPER_HOST ""
ADD kafka_cluster.sh /tmp/kafka_cluster.sh
	

#自动启动脚本
RUN echo "bash /tmp/kafka_conf.sh" >> /opt/bootstrap.sh
RUN echo "bash /tmp/kafka_cluster.sh" >> /opt/bootstrap.sh

# RUN echo "rm -rf /tmp/zookeeper/version-2" >> /opt/bootstrap.sh #删除zk之前的节点，避免第二次启动报错
# RUN echo "rm -rf /tmp/kafka-logs/meta.properties" >> /opt/bootstrap.sh  #删除kafka的集群节点，避免第二次启动报错,2.13-2.4.0 发现的


RUN echo "bash $KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties & " >> /opt/bootstrap.sh
RUN echo "sleep 25 " >> /opt/bootstrap.sh #重要，zk节点的过期时间默认为18秒


RUN echo "sh $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties " >> /opt/bootstrap.sh




#启动
RUN set -xe \
	&& echo "sleep 30" >> /opt/bootstrap.sh \
	&& echo "sh /opt/wait_java_exit.sh" >> /opt/bootstrap.sh 
	


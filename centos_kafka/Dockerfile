#
# 安装： docker build -t kafka   ./ 
# 运行： docker run -d -p 8822:22 -e ROOT_PASSWORD="root" lianshufeng/kafka
# 例子： docker run -d -p 8822:22 -p 2181:2181 -p 9082:9082 lianshufeng/kafka
# 备注 : -p 端口映射 ; -v 挂载目录 ; -w 工作空间 ; -e 环境变量 ; --restart always 随docker服务启动 
#


FROM lianshufeng/jdk
MAINTAINER lianshufeng <251708339@qq.com>

#构建参数 --build-arg
ARG KAFKA_URL="http://mirror.bit.edu.cn/apache/kafka/1.1.0/kafka_2.12-1.1.0.tgz"
ARG KAFKA_HOME="/opt/kafka"



	
#下载
RUN wget -O /tmp/kafka.tar.gz --no-cookies --no-check-certificate $KAFKA_URL
#解压并设置环境
RUN set -xe \
	&& mkdir /tmp/kafka \
	&& tar -xvzf /tmp/kafka.tar.gz -C /tmp/kafka \
	&& rm -rf /tmp/kafka.tar.gz \
	&& mkdir -p $KAFKA_HOME \
	&& rm -rf $KAFKA_HOME \
	&& mv /tmp/kafka/$(ls /tmp/kafka/ ) $KAFKA_HOME \
	&& rm -rf /tmp/kafka \
	&& chmod -R 777 $KAFKA_HOME \
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



#自动启动脚本
RUN echo "sh $KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties &" >> /opt/bootstrap.sh
RUN echo "sh $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties &" >> /opt/bootstrap.sh





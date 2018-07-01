#!/bin/bash

docker network create --subnet=172.172.200.0/24 docker-br0



#docker run --name kafka2 --privileged=true -d \
#--net docker-br0 --ip 172.172.200.2 \
#-p 8822:22 -p 2182:2181 -p 9092:9092 \
#-e CLUSTER_HOST="172.172.200.2,172.172.200.3,172.172.200.4" \
#-v /opt/kafka2/config:/opt/kafka/config -v /opt/kafka2/logs:/opt/kafka/logs -v /opt/kafka2/kafka_logs:/tmp/kafka-logs -v #/opt/kafka2/zookeeper:/tmp/zookeeper \
#kafka



## CLUSTER_HOST
## 集群的ip地址，用英文逗号间隔

## ADVERTISED_LISTENERS
## 若不指定，则端口映射后将无法访问


#集群数量
hostNumber=9
#外网主机IP
ADVERTISED_LISTENERS="192.168.208.131"




#主机
CLUSTER_HOST=""
for((i=1;i<=$hostNumber;i++));
do
	let p=i+1
	CLUSTER_HOST=$CLUSTER_HOST"172.172.200."$p","
	#删除挂载目录
	dirPath="rm -rf /opt/kafka"$p
	($dirPath)
	#删除容器
	rName="docker rm -f kafka"$p
	($rName)
	#允许通过防火墙
	firewall="firewall-cmd --add-port="$(($p+9090))"/tcp"
	($firewall)
done
echo $CLUSTER_HOST

#构建集群命令
for((i=1;i<=$hostNumber;i++));
do 
	let p=1+i
	cmd="docker run --name kafka"$p" --privileged=true -d \
	--net docker-br0 --ip 172.172.200."$p" \
	-p $(($p+8820)):22 -p $(($p+2180)):2181 -p $(($p+9090)):9092 \
	-e CLUSTER_HOST="$CLUSTER_HOST" \
	-e ADVERTISED_LISTENERS="$ADVERTISED_LISTENERS":$(($p+9090)) \
	-v /opt/kafka"$p"/config:/opt/kafka/config -v /opt/kafka"$p"/logs:/opt/kafka/logs -v /opt/kafka"$p"/kafka_logs:/tmp/kafka-logs -v /opt/kafka"$p"/zookeeper:/tmp/zookeeper \
	kafka"
	#echo $cmd
	($cmd)
done






#创建话题
#kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic testKJ1

#生产者客户端命令
#kafka-console-producer.sh --broker-list localhost:9092 --topic testKJ1

#消费者客户端命令
#kafka-console-consumer.sh -zookeeper localhost:2181 --from-beginning --topic testKJ1

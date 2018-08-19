#!/bin/bash


#简单例子
cd /opt/docker
docker build -t kafka ./ 
docker rm -f kafka
docker run -d --name kafka -v /opt/kafka/config:/opt/kafka/config -v /opt/kafka/logs:/opt/kafka/logs -v /opt/kafka/kafka_logs:/tmp/kafka-logs -e KAFKA_LISTENERS="192.168.208.131:9092" -p 2181:2181 -p 9092:9092 lianshufeng/kafka
docker exec -it kafka /bin/bash 
source /etc/profile




#集群例子
sudo firewall-cmd --add-port=2181/tcp --permanent 
sudo firewall-cmd --add-port=2182/tcp --permanent 
sudo firewall-cmd --add-port=2183/tcp --permanent 
sudo firewall-cmd --add-port=9092/tcp --permanent 
sudo firewall-cmd --add-port=9093/tcp --permanent 
sudo firewall-cmd --add-port=9094/tcp --permanent 

firewall-cmd --reload 
docker network create --subnet=172.172.200.0/24 docker-br0


cd /opt/docker
docker build -t kafka ./ 
docker rm -f kafka1 kafka2 kafka3
vmHost=192.168.208.131

docker run -d --name kafka1 \
--net docker-br0 --ip 172.172.200.2 \
-p 2181:2181 -p 9092:9092  \
-e KAFKA_LISTENERS="$vmHost:9092" \
-e ZOOKEEPER_HOST="172.172.200.2,172.172.200.3,172.172.200.4" \
kafka


docker run -d --name kafka2 \
--net docker-br0 --ip 172.172.200.3 \
-p 2182:2181 -p 9093:9092  \
-e KAFKA_LISTENERS="$vmHost:9093" \
-e ZOOKEEPER_HOST="172.172.200.2,172.172.200.3,172.172.200.4" \
kafka


docker run -d --name kafka3 \
--net docker-br0 --ip 172.172.200.4 \
-p 2183:2181 -p 9094:9092  \
-e KAFKA_LISTENERS="$vmHost:9094" \
-e ZOOKEEPER_HOST="172.172.200.2,172.172.200.3,172.172.200.4" \
kafka

docker logs kafka1
docker exec -it kafka1 /bin/bash 
source /etc/profile







#创建话题
kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic testxiaofeng
#生产者客户端命令
kafka-console-producer.sh --broker-list 192.168.208.131:9092 --topic testxiaofeng
#消费者客户端命令
kafka-console-consumer.sh --bootstrap-server 192.168.208.131:9092 --topic testxiaofeng --from-beginning


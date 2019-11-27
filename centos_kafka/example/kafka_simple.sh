#!/bin/bash






#创建话题
kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic testxiaofeng
#生产者客户端命令
kafka-console-producer.sh --broker-list 192.168.208.131:9092 --topic testxiaofeng
#消费者客户端命令
kafka-console-consumer.sh --bootstrap-server 192.168.208.131:9092 --topic testxiaofeng --from-beginning


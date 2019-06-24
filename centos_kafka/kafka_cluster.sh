#!/bin/bash


#### 集群配置
if [ $ZOOKEEPER_HOST != "" ]; then
	zookeeperConnect=""
	ZOOKEEPER_HOST=(${ZOOKEEPER_HOST//,/ })
	i=0
	for host in ${ZOOKEEPER_HOST[@]}
	do
		let i++
		zookeeperConnect=$zookeeperConnect""$host":2181,"
		echo "server.$i=$host:2888:3888" >> $KAFKA_HOME/config/zookeeper.properties
		
		mkdir /tmp/zookeeper
		#zookeeper集群 myid
		echo "$i" > /tmp/zookeeper/myid
		#kafka集群 broker.id
		sed -i "s/broker.id=0/broker.id=$i/g" $KAFKA_HOME/config/server.properties
		
	done
	#### zk 配置
	echo "initLimit=10" >> $KAFKA_HOME/config/zookeeper.properties
	echo "syncLimit=5" >> $KAFKA_HOME/config/zookeeper.properties
	#去掉多余的,
	zookeeperConnect=${zookeeperConnect%,*}
	
	sed -i "s/zookeeper.connect=localhost:2181/zookeeper.connect=$zookeeperConnect/g" $KAFKA_HOME/config/server.properties
	sed -i "s/#listeners=PLAINTEXT:\/\/:9092/listeners=PLAINTEXT:\/\/0.0.0.0:9092/g" $KAFKA_HOME/config/server.properties
fi



#### 外部地址,若不指定，这无法远程访问
if [ $KAFKA_LISTENERS != "" ]; then
	sed -i "s/#advertised.listeners=PLAINTEXT:\/\/your.host.name:9092/advertised.listeners=PLAINTEXT:\/\/$KAFKA_LISTENERS/g" $KAFKA_HOME/config/server.properties
fi


#防止多次被执行
echo "" > $0
#!/bin/bash
if [ -z $CLUSTER_HOST ]; then
	echo localhost
else
	CLUSTER_HOST=(${CLUSTER_HOST//,/ })
	zookeeperConnect=""
	i=0
	for host in ${CLUSTER_HOST[@]}
	do
		zookeeperConnect=$zookeeperConnect""$host":2181,"
		#### zookeeper 集群
		let i++
		echo "server.$i=$host:2888:3888" >> $KAFKA_HOME/config/zookeeper.properties
		#判断当前ip
		ipexist=$(ip a | grep $host )
		if [[ -z $ipexist ]] ;then
			echo $ipexist
		else 
			mkdir /tmp/zookeeper
			#zookeeper集群 myid
			echo "$i" > /tmp/zookeeper/myid
			#kafka集群 broker.id
			sed -i "s/broker.id=0/broker.id=$i/g" $KAFKA_HOME/config/server.properties
		fi
	done
	#### kafka集群
	sed -i "s/zookeeper.connect=localhost:2181/zookeeper.connect=$zookeeperConnect/g" $KAFKA_HOME/config/server.properties
	#### zookeeper集群
	echo "initLimit=10" >> $KAFKA_HOME/config/zookeeper.properties
	echo "syncLimit=5" >> $KAFKA_HOME/config/zookeeper.properties
fi
#防止多次被执行
echo "" > $0
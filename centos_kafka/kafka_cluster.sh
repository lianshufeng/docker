#!/bin/bash
if [ -z $CLUSTER_HOST ]; then
	echo localhost
else
	CLUSTER_HOST=(${CLUSTER_HOST//,/ })
	i=0
	for host in ${CLUSTER_HOST[@]}
	do
		let i++
		#写入zk
		echo "server.$i=$host:2888:3888" >> $KAFKA_HOME/config/zookeeper.properties
		#判断当前ip
		ipexist=$(ip a | grep $host )
		if [[ -z $ipexist ]] ;then
			echo $ipexist
		else 
			#取出对应的序号
			echo "$i" > /tmp/ip
		fi
		
	done 
fi
#防止多次被执行
#echo "" > $0
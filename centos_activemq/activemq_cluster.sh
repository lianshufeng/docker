#!/bin/bash


#### 集群配置
if [ $CLUSTER_HOST != "" ]; then
	
	echo "集群配置---->>>>"

	networkConnector_uri=""
	CLUSTER_HOST=(${CLUSTER_HOST//,/ })
	i=0
	for host in ${CLUSTER_HOST[@]}
	do
		let i++
		broker_host="tcp:\/\/"$host":61616,"
		networkConnector_uri=$networkConnector_uri""$broker_host
	done
	
	networkConnector_uri="<networkConnectors><networkConnector uri=\"static:("$networkConnector_uri")\" duplex=\"true\"\/><\/networkConnectors>"
	
	
	echo $networkConnector_uri
	
	if cat $ACTIVEMQ_HOME/conf/activemq.xml | grep "<networkConnectors>">/dev/null;then
		echo "已配置过 networkConnectors"
	else
		
		#修改网络配置
		update_cmd="sed -i 's/<\/broker>/"$networkConnector_uri"&/' "$ACTIVEMQ_HOME"/conf/activemq.xml"
		echo $update_cmd
		eval $update_cmd
		
		#修改broker的主机名
		
		sed -i "s/brokerName=\"localhost\"/brokerName=\"${Broker_Name}\"/g" $ACTIVEMQ_HOME/conf/activemq.xml
		
		
	fi
	
	
fi






#防止多次被执行
echo "" > $0
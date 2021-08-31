#!/bin/bash
docker-compose down ; docker-compose up -d ; docker-compose down 
sleep 10
cp -f ./broker.xml ./broker1/etc/broker.xml
cp -f ./broker.xml ./broker2/etc/broker.xml
cp -f ./broker.xml ./broker3/etc/broker.xml


sed -i 's/{MQHOST}/mq1/g' ./broker1/etc/broker.xml
sed -i 's/{MQHOST}/mq2/g' ./broker2/etc/broker.xml
sed -i 's/{MQHOST}/mq3/g' ./broker3/etc/broker.xml

docker-compose up -d

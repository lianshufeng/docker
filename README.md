# install docker (china): 
````shell
curl -fsSL https://raw.githubusercontent.com/lianshufeng/docker/master/native/install_docker.sh | sh
````

# base :  
- Centos(7.6) + JDK (oracle - 8u211) 


#### bootstrap:
- /opt/bootstrap.sh : boot auto run


#### update jdk version
```shell
docker build -t springboot --build-arg JDK_URL="http://download.oracle.com/otn-pub/java/jdk/10.0.1+10/fb4372174a714e6b8c52526dc134031e/jdk-10.0.1_linux-x64_bin.tar.gz"  ./ 
```

#### mount
- -- privileged=true

#### springboot ( ENTRYPOINT  boot auto run )
```shell
docker run --privileged=true -d  -v /opt/jars:/opt/jars -w /opt/jars -e ENTRYPOINT="mkdir /opt/logs/ & nohup java -Xmx600m -Xms300m -Duser.timezone=GMT+8 -Dspring.profiles.active=prod -jar eureka.jar > /opt/logs/out.log" --restart always lianshufeng/springboot
```

#### tomcat ( TOMCAT_VM )
```shell
docker run --privileged=true -d -p 8822:22 -p 8080:8080 -e TOMCAT_VM="-Xms300m -Xmx600m" lianshufeng/tomcat
```

#### activemq 
```shell
docker run --name activemq --privileged=true -d -p 8822:22 -p 8161:8161 -p 61616:61616 -p 5672:5672 -p 61613:61613 -p 1883:1883 -p 61614:61614  -v /opt/activemq/conf:/opt/activemq/conf  -v /opt/activemq/data:/opt/activemq/data lianshufeng/activemq
```


#### kafka 
- simple
```shell
docker run -d --name kafka -v /opt/kafka/config:/opt/kafka/config -v /opt/kafka/logs:/opt/kafka/logs -v /opt/kafka/kafka_logs:/tmp/kafka-logs -e KAFKA_LISTENERS="192.168.208.131:9092" -p 2181:2181 -p 9092:9092 lianshufeng/kafka
```
- cluster
```shell
sh example_cluster.sh
```




#### firewall
```shell
sudo firewall-cmd --add-port=2181/tcp --permanent 
sudo firewall-cmd --add-port=9092/tcp --permanent 
firewall-cmd --reload 
```


#### docker-compose.yml 
````shell
version: "3"

services:
  springboot:
    image: lianshufeng/springboot
    ports:
      - "8761:8761"
    volumes:
      - "/opt/jar:/opt/jar"
    working_dir: /opt/jar
    container_name: applicationserver
    environment:
      - ENTRYPOINT=nohup java -Xmx600m -Xms300m -Duser.timezone=GMT+8 -Dspring.profiles.active=local -jar ApplicationServer-1.0.0-SNAPSHOT.jar
````
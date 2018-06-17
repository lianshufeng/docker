# base :  Centos + JDK (SUN) + ssh-server

#### ENV :
ROOT_PASSWORD : init root's password


#### bootstrap:
/opt/bootstrap.sh : boot auto run


#### update jdk version
docker build -t springboot --build-arg JDK_URL="http://download.oracle.com/otn-pub/java/jdk/10.0.1+10/fb4372174a714e6b8c52526dc134031e/jdk-10.0.1_linux-x64_bin.tar.gz"  ./ 




### demo

tomcat ( TOMCAT_VM )
docker run -d -p 8822:22 -p 8080:8080 -e TOMCAT_VM="-Xms300m -Xmx600m" lianshufeng/tomcat


springboot ( ENTRYPOINT  boot auto run )
docker run -d -p 8822:22 -v /opt/jars:/opt/jars -w /opt/jars -e ENTRYPOINT="mkdir /opt/logs/ & nohup java -Xmx600m -Xms300m -Duser.timezone=GMT+8 -Dspring.profiles.active=prod -jar eureka.jar > /opt/logs/out.log" --restart always lianshufeng/springboot



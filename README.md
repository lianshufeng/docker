# Centos + JDK (SUN)


####  自定义密码 (ROOT_PASSWORD)
docker run -d -p 8822:22 -e ROOT_PASSWORD="bigroot" lianshufeng/springboot

#### 启动 (ENTRYPOINT) 
docker run -d -p 8822:22 -v /opt/jars:/opt/jars -w /opt/jars -e ENTRYPOINT="nohup java -Xmx600m -Xms300m -Duser.timezone=GMT+8 -Dspring.profiles.active=prod -jar eureka.jar" --restart always springboot

#### 升级JDK
docker build -t springboot --build-arg JDK_URL="http://download.oracle.com/otn-pub/java/jdk/10.0.1+10/fb4372174a714e6b8c52526dc134031e/jdk-10.0.1_linux-x64_bin.tar.gz"  ./ 


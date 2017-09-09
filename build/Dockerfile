#
# 安装： docker build -t tomcat ./ 
# 运行： docker run -d -p 8822:22 -p 8888:8080  tomcat
# 挂载： docker run -d -p 8822:22 -p 8888:8080 -v /mnt/data/vr:/opt/tomcat/webapps/ROOT  tomcat
#

#安装本地Centos
FROM scratch
MAINTAINER The CentOS Project <cloud-ops@centos.org>
ADD centos-7.2.1511-docker.tar.xz /
LABEL name="CentOS Base Image"
LABEL vendor="CentOS"
LABEL license=GPLv2
CMD ["/bin/bash"]
#安装openssh和unzip工具
RUN yum install unzip -y
RUN yum install openssh-server -y
#生成ssh的登陆证书
RUN ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ''
RUN ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N '' 
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N '' 
#修改ssh-server的配置
RUN sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
RUN sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config
#修改当前系统的ROOT密码
RUN echo "root:root" > /tmp/tmp.pass
RUN chpasswd < /tmp/tmp.pass
#外部工具相关
ADD apache-tomcat-8.5.20.zip /tmp/apache-tomcat-8.5.20.zip
ADD jdk-8u144-linux-x64.tar.gz /tmp/jdk-8u144-linux-x64.tar.gz
#解压相关项目
RUN unzip /tmp/apache-tomcat-8.5.20.zip -d /tmp
#tar.gz不需要解压,在Docker里自动为目录
#RUN tar -xzvf /tmp/jdk-8u144-linux-x64.tar.gz -C /tmp
#移动到目标路径
RUN mv /tmp/apache-tomcat-8.5.20 /opt/tomcat
RUN mv /tmp/jdk-8u144-linux-x64.tar.gz/jdk1.8.0_144 /opt/jdk
#删除相关文件
RUN rm -rf /tmp/apache-tomcat-8.5.20.zip
RUN rm -rf /tmp/jdk-8u144-linux-x64.tar.gz
#删除tomcat多余文件
RUN rm -rf /opt/tomcat/webapps
RUN mkdir -p /opt/tomcat/webapps/ROOT
RUN echo "hello world" > /opt/tomcat/webapps/ROOT/index.html
#设置Tomcat内存
RUN echo "JAVA_OPTS='-Xms1024m -Xmx2048m'" > /tmp/javaOpts.txt
RUN cat /tmp/javaOpts.txt /opt/tomcat/bin/catalina.sh > /opt/tomcat/bin/catalina.sh.new
RUN mv /opt/tomcat/bin/catalina.sh /opt/tomcat/bin/catalina.sh.bak
RUN mv /opt/tomcat/bin/catalina.sh.new /opt/tomcat/bin/catalina.sh
RUN rm -rf /tmp/javaOpts.txt
#设置环境变量
RUN echo "" >> /etc/profile
RUN echo "JAVA_HOME=/opt/jdk" >> /etc/profile
RUN echo "PATH=/opt/jdk/bin:$PATH" >> /etc/profile
RUN echo "CLASSPATH=.:/opt/jdk/lib/dt.jar:/opt/jdk/lib/tools.jar" >> /etc/profile
RUN echo "export JAVA_HOME" >> /etc/profile
RUN echo "export PATH" >> /etc/profile
RUN echo "export CLASSPATH" >> /etc/profile
#设置系统时区
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ENV JAVA_HOME /opt/jdk
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/jdk/bin:/opt/tomcat/bin
#设置读写权限
RUN chmod -R 777 /opt
#设置进入启动项
ENTRYPOINT /opt/tomcat/bin/startup.sh & /usr/sbin/sshd -D 







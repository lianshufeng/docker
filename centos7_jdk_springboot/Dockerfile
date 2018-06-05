#
# 安装： docker build -t centos7_spring_boot  ./
# 运行： docker run -d -p 8822:22 -p 8888:8080  centos7_spring_boot
# 挂载： docker run -d -p 8822:22 -p 8888:8080 -v /mnt/jars:/opt/jars  centos7_spring_boot
#

#安装centos [可升级]
FROM centos:7.5.1804
CMD ["/bin/bash"]
#安装openssh和unzip工具
RUN rpm --rebuilddb
RUN yum install unzip openssh-server wget -y
#生成ssh的登陆证书
RUN ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ''
RUN ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N '' 
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N '' 
#修改ssh-server的配置
RUN sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
RUN sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config
#修改当前系统的ROOT密码,默认为 root
RUN echo "root:root" > /tmp/tmp.pass
RUN chpasswd < /tmp/tmp.pass
#下载jdk [可升级]
RUN wget -O /opt/jdk.tar.gz --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u172-b11/a58eab1ec242421181065cdc37240b08/jdk-8u172-linux-x64.tar.gz
#解压
RUN tar -xvzf /opt/jdk.tar.gz -C /opt
#删除下载过的文件
RUN rm -rf /opt/jdk.tar.gz
#获取环境变量
RUN mv /opt/$(ls /opt/ | grep jdk) /opt/jdk
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
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/jdk/bin
#设置读写权限
RUN chmod -R 777 /opt
#设置进入启动项
ENTRYPOINT /usr/sbin/sshd -D 







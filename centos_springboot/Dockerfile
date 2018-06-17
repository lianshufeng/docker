#
# 安装： docker build -t springboot --build-arg JAVA_HOME="/opt/jdk"  ./ 
# 运行： docker run -d -p 8822:22 -e ROOT_PASSWORD="root" springboot
# 例子： docker run -d -p 8822:22 -v /opt/jars:/opt/jars -w /opt/jars/ -e ENTRYPOINT="nohup java -jar Idea.jar" --restart always springboot
# 备注 : -p 端口映射 ; -v 挂载目录 ; -w 工作空间 ; -e 环境变量 ($ENTRYPOINT 启动命令) ; --restart always 随docker服务启动 
#


FROM lianshufeng/jdk
MAINTAINER lianshufeng <251708339@qq.com>

#运行变量 -e
ENV ENTRYPOINT ""

#springboot 启动
RUN echo "echo \${ENTRYPOINT}|awk '{run=\$0;system(run)}'" >> /opt/bootstrap.sh 
	







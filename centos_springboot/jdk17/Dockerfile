#
# 安装： docker build -t lianshufeng/springboot  ./ 
# 运行： docker run -d  lianshufeng/springboot
# 例子： docker run -d -v /opt/jars:/opt/jars -w /opt/jars/ -e ENTRYPOINT="nohup java -jar Idea.jar" --restart always lianshufeng/springboot
# 备注 : -p 端口映射 ; -v 挂载目录 ; -w 工作空间 ; -e 环境变量 ($ENTRYPOINT 启动命令) ; --restart always 随docker服务启动 
#


FROM lianshufeng/jdk:17
MAINTAINER lianshufeng <251708339@qq.com>
ENV JAVA_HOME="/opt/jdk"
ENV PATH=$PATH:$JAVA_HOME/bin

#运行变量, 外部执行的命令行
ENV ENTRYPOINT ""

#缓存的资源，存在则不重新下载，多个资源用,间隔
ENV CacheResources ""

#更新的资源,每次启动重新下载，多个资源用,间隔
ENV UpdateResources ""

RUN rm -rf /opt/bootstrap.sh 
ADD ./bootstrap.sh /opt/bootstrap.sh 
RUN chmod -R 777 /opt/bootstrap.sh 









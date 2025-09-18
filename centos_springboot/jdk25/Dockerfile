#
# 安装： docker build -t lianshufeng/springboot  ./ 
# 运行： docker run -d  lianshufeng/springboot
# 例子： docker run -d -v /opt/jars:/opt/jars -w /opt/jars/ -e ENTRYPOINT="nohup java -jar Idea.jar" --restart always lianshufeng/springboot
# 备注 : -p 端口映射 ; -v 挂载目录 ; -w 工作空间 ; -e 环境变量 ($ENTRYPOINT 启动命令) ; --restart always 随docker服务启动 
#

FROM lianshufeng/jdk:25
LABEL maintainer="lianshufeng <251708339@qq.com>"

ENV JAVA_HOME="/opt/jdk" \
    PATH="$PATH:/opt/jdk/bin" \
    ENTRYPOINT="" \
    CacheResources="" \
    UpdateResources=""

RUN rm -rf /opt/bootstrap.sh 
COPY ./bootstrap.sh /opt/bootstrap.sh 
RUN chmod 777 /opt/bootstrap.sh 

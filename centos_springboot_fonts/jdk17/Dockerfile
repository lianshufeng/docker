#
# 安装： docker build -t lianshufeng/springboot  ./ 
# 运行： docker run -d  lianshufeng/springboot
# 例子： docker run -d -v /opt/jars:/opt/jars -w /opt/jars/ -e ENTRYPOINT="nohup java -jar Idea.jar" --restart always lianshufeng/springboot
# 备注 : -p 端口映射 ; -v 挂载目录 ; -w 工作空间 ; -e 环境变量 ($ENTRYPOINT 启动命令) ; --restart always 随docker服务启动 
#


FROM lianshufeng/jdk:17 as builder
MAINTAINER lianshufeng <251708339@qq.com>

# 字体
RUN set -xe \
	&& curl -k https://download.jpy.wang/Fonts.zip -o /tmp/Fonts.zip \
	&& unzip -d /usr/share/fonts/dejavu /tmp/Fonts.zip \
	&& rm -rf /tmp/Fonts.zip


FROM lianshufeng/springboot:jdk17 as runtime
COPY --from=builder /usr/share/fonts/dejavu/ /usr/share/fonts/dejavu/
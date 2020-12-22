#依赖镜像
FROM lianshufeng/jdk as builder
MAINTAINER lianshufeng <251708339@qq.com>


#依赖的环境变量
ARG MAVEN_URL="https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.zip"
ARG MAVEN_HOME="/opt/maven/"


#下载 tomcat
RUN wget -O /tmp/maven.zip --no-cookies --no-check-certificate  $MAVEN_URL

#解压
RUN set -xe \
	&& mkdir -p $MAVEN_HOME \
	&& unzip -o /tmp/maven.zip -d $MAVEN_HOME \
	&& rm -rf /tmp/maven.zip \
	&& chmod -R 777 $MAVEN_HOME 



FROM lianshufeng/jdk as runtime
ARG MAVEN_FOLDER="apache-maven-3.6.3"
ARG MAVEN_HOME="/opt/maven/"
#编译中拷贝文件
COPY --from=builder $MAVEN_HOME $MAVEN_HOME

#设置环境
RUN set -xe \
	&& echo "" >> /etc/profile \
	&& echo "MAVEN_HOME="$MAVEN_HOME$MAVEN_FOLDER >> /etc/profile \
	&& echo "PATH="\$MAVEN_HOME"/bin:\$PATH" >> /etc/profile \
	&& echo "export MAVEN_HOME" >> /etc/profile \
	&& echo "export PATH" >> /etc/profile \
	#刷新环境变量
	&& source /etc/profile 



# maven 简易工具
COPY ./mvn_package.sh /mvn_package.sh
COPY ./mvn_remove_repository.sh /mvn_remove_repository.sh

RUN set -xe \
	&& chmod -R 777 /mvn_package.sh \
	&& chmod -R 777 /mvn_remove_repository.sh








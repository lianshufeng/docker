#
# 推荐构建命令：
# docker build -t lianshufeng/jdk --build-arg JAVA_HOME="/opt/jdk" .
#

# ------ 第一阶段: 构建 JDK ------
FROM quay.io/centos/centos:stream10 AS builder

LABEL maintainer="lianshufeng <your@email.com>"

ARG JDK_URL="https://download.oracle.com/java/25/latest/jdk-25_linux-x64_bin.tar.gz"
ARG JAVA_HOME="/opt/jdk"

RUN yum clean all && yum makecache

RUN yum install -y wget tar && yum clean all

ENV JAVA_HOME=${JAVA_HOME}
ENV PATH=${JAVA_HOME}/bin:${PATH}

RUN echo 'LANG="zh_CN.utf8"' > /etc/locale.conf

RUN wget -O /tmp/jdk.tar.gz --no-cookies --no-check-certificate \
    --header "Cookie: oraclelicense=accept-securebackup-cookie" "$JDK_URL" \
    && mkdir /tmp/jdk \
    && tar -xzf /tmp/jdk.tar.gz -C /tmp/jdk \
    && rm -f /tmp/jdk.tar.gz \
    && rm -rf "$JAVA_HOME" \
    && mv /tmp/jdk/* "$JAVA_HOME" \
    && rm -rf /tmp/jdk \
    && chmod -R 755 "$JAVA_HOME"

# ------ 第二阶段: 运行环境 ------
FROM quay.io/centos/centos:stream10 AS runtime

ARG JAVA_HOME="/opt/jdk"

RUN yum clean all && yum makecache

RUN yum install -y unzip wget curl fontconfig langpacks-zh_CN jq && yum clean all

ENV JAVA_HOME=${JAVA_HOME}
ENV PATH=${JAVA_HOME}/bin:${PATH}

RUN echo 'LANG="zh_CN.utf8"' > /etc/locale.conf

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

COPY --from=builder ${JAVA_HOME} ${JAVA_HOME}

RUN set -eux; \
    echo "" >> /etc/profile; \
    echo "JAVA_HOME=${JAVA_HOME}" >> /etc/profile; \
    echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile; \
    echo "CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /etc/profile; \
    echo "export JAVA_HOME" >> /etc/profile; \
    echo "export PATH" >> /etc/profile; \
    echo "export CLASSPATH" >> /etc/profile;

COPY ./bootstrap.sh /opt/bootstrap.sh
COPY ./wait_java_exit.sh /opt/wait_java_exit.sh

ENTRYPOINT ["sh", "/opt/bootstrap.sh"]

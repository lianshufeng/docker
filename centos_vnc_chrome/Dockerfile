#
#  docker run -d -p 5901:5901 -p 6901:6901 lianshufeng/centos_vnc
# 

#FROM lianshufeng/centos_vnc
FROM registry.cn-chengdu.aliyuncs.com/1s/centos_vnc
MAINTAINER "251708339@qq.com"
ARG Chrome_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"


# install chrome
COPY ./src/centos/script/ $INST_SCRIPTS/chrome
RUN sh $INST_SCRIPTS/chrome/install_chrome.sh


#install to desktop
COPY ./src/centos/Desktop $HOME/Desktop
RUN chmod -R 777 $HOME/Desktop


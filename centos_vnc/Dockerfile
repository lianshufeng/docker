#
#  docker run -d -p 5901:5901 -p 6901:6901 lianshufeng/centos_vnc
# 

FROM centos:8
MAINTAINER "251708339@qq.com"

# upgrade
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-* &&\
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*
RUN yum upgrade -y

# install tools
RUN yum install wget curl fontconfig langpacks-zh_CN -y
#修改系统默认编码
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN set -xe \
	&& echo LANG=\"en_US.UTF-8\" >> /etc/locale.conf \
	&& echo LANGUAGE=\"en_US:en\" >> /etc/locale.conf \
	&& echo LC_ALL=\"en_US.UTF-8\" >> /etc/locale.conf  
	 
## Connection ports for controlling the UI:
# VNC port:5901
# noVNC webport, connect via http://IP:6901/?password=vncpassword
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT

### Envrionment config
ENV HOME=/headless \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/headless/install \
    NO_VNC_HOME=/headless/noVNC \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1024 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false
WORKDIR $HOME

### Add all install scripts for further steps
ADD ./src/common/install/ $INST_SCRIPTS/
ADD ./src/centos/install/ $INST_SCRIPTS/
RUN find $INST_SCRIPTS -name '*.sh' -exec chmod a+x {} +

 
RUN cat $INST_SCRIPTS/tools.sh
 
### Install some common tools
RUN $INST_SCRIPTS/tools.sh


### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN $INST_SCRIPTS/tigervnc.sh
RUN $INST_SCRIPTS/no_vnc.sh
#更新脚本
RUN rm -rf /usr/bin/vncserver
COPY ./src/other/vncserver.pl /usr/bin/vncserver
RUN chmod -R 777 /usr/bin/vncserver


### Install firefox and chrome browser
#RUN $INST_SCRIPTS/firefox.sh
#RUN $INST_SCRIPTS/chrome.sh


### Install xfce UI
RUN $INST_SCRIPTS/xfce_ui.sh
ADD ./src/common/xfce/ $HOME/

### configure startup
RUN $INST_SCRIPTS/libnss_wrapper.sh
ADD ./src/common/scripts $STARTUPDIR
RUN $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME



ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]
FROM seleniarm/standalone-chromium


# vnc 密码
ENV VNC_PW=secret

# 启动后要执行的chrome 命令行
ENV CHROME_CMD=""

#启动后要执行的命令
ENV RUN_CMD=""


#屏幕
ENV SCREEN_WIDTH=1360
ENV SCREEN_HEIGHT=1020
ENV SCREEN_DEPTH=24

# 剪贴板
ENV NOVNC_CLIPBOARD_ENCODING=UTF-8

USER root


#安装依赖库
# RUN apt update -y && apt upgrade -y && apt install -y --no-install-recommends  \
    # git \
# && rm -rf /var/lib/apt/lists/*


#拷贝启动代码
COPY ./boot /boot

#增加启动项,第一行为 #!/bin/bash
RUN sed -i '2i sh /boot/run_before.sh' /opt/bin/entry_point.sh

# 在wait前增加一行
RUN sed -i '$i\sh /boot/run_after.sh'  /opt/bin/entry_point.sh


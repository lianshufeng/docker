#!/bin/sh

# sh install_docker_proxy.sh ${ssserver} ${ssport} ${mode} ${pwd}
# eq: sh install_docker_proxy.sh 47.242.201.220 8756 xchacha20-ietf-poly1305 xiaofengfeng

# test proxy: curl -x socks5://127.0.0.1:1080 -L https://api.dzurl.top/ip

proxyName=ssclient


# 启动代理服务
docker rm -f ${proxyName}
docker run -dt --name ${proxyName} --restart=always -p 1080:1080 registry.cn-chengdu.aliyuncs.com/1s/shadowsocks -m "ss-local" -s "-s $1 -p $2 -b 0.0.0.0 -l 1080 -m $3 -k $4"

# 写配置
mkdir -p /etc/systemd/system/docker.service.d
echo "[Service]" > /etc/systemd/system/docker.service.d/socks5-proxy.conf
echo "Environment=\"ALL_PROXY=socks5://127.0.0.1:1080\"" >> /etc/systemd/system/docker.service.d/socks5-proxy.conf





# 重启
systemctl daemon-reload
systemctl restart docker
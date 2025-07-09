#!/bin/bash
set -e
source /etc/profile
source /etc/locale.conf
export LANG=zh_CN.utf8

downloadResources(){
	url=$1
	foreUpdate=$2
		
	#文件名
	fileName=${url##*/} 
	
	#缓存与强制更新的判断
	if [ ! -f "$fileName" ]||[[ "$foreUpdate" == true ]] ; then
		echo "update:" $url
		curl $url -o $fileName
	else
		echo "cache:" $fileName
	fi
	
}



#更新资源
downResources(){
	urls=$1
	urls=(${urls//,/ }) 
	foreUpdate=$2

	for url in ${urls[@]} 
	do 
		downloadResources $url $foreUpdate
	done

}


#下载依赖资源
loadResources(){

	if [ "$CacheResources" != "" ];then
		downResources $CacheResources false
	fi
	
	if [ "$UpdateResources" != "" ];then
		downResources $UpdateResources true
	fi

}


loadResources


# 执行命令
if [ "$ENTRYPOINT" != "" ];then
	 $ENTRYPOINT
fi


# execute command line
if [ -n "$1" ] ;then
	cmd="$*"
	$cmd
fi


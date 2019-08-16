#!/bin/bash


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
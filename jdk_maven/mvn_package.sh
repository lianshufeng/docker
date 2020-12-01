#!/bin/bash
# cmd : <maven_project> [src/target/jar] [/opt/project/jar] 

echo project : ${1}
echo source  : ${2}
echo target  : ${3}

#加载环境变量
source /etc/profile

cd ${1}
mvn clean package
cp ${2} ${3}
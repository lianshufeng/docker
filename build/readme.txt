1、拷贝 apache-tomcat-8.5.20.zip 和 jdk-8u144-linux-x64.tar.gz 到本目录下(版本可调整,但前缀与扩展名不能改变, apache-tomcat-*.zip 和 jdk-*.tar.gz ).
2、执行 Make进行编译.
3、拷贝目录所有文件到 服务器上，进行 Docker build .

唯一的用处，也是最大的用处：兼容多版本的JDK和Tomcat,并设置JDK环境变量,最后生成 DockerFile

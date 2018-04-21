//通用配置功能
var config = {
    passWord : 'root',
    installPath : '/opt',
    javaOpts:'-Xms1024m -Xmx2048m -Duser.timezone=GMT+8 -Djava.security.egd=file:/dev/./urandom'
};








var path = require('path'),
    tar = require('./node_modules/tar'),
    zipLocal = require('./node_modules/zip-local');
    exec = require("child_process").execSync,
    fs = require('fs');
    

var _DockerfilePath =  path.join(__dirname,'images','_Dockerfile');
var buildPath = path.join(__dirname,'build'),
    runTimePath = path.join(__dirname,'runtime'),
    imagesPath = path.join(__dirname,'images');

//内容
var DockerfileContent = fs.readFileSync(_DockerfilePath).toString();


//拷贝文件
var copyFile = function (src, dst) {
  fs.writeFileSync(dst, fs.readFileSync(src));
}


//获取组件
var getComponent = function( findPath , preName){
    var arr = new Array();
    var files = fs.readdirSync(findPath);
    for(var i in files){
        if (files[i].toLowerCase().indexOf(preName)>-1){
            return path.join( findPath , files[i] );
        }
    }
    return null;
}

//替换内容
var replaceContent = function(content , map){
    var result = content;
    for (var key in map){
        result = result.split('${'+key+'}').join(map[key]);
    }
    return result;
}

//读取Tar的文件名
var readTarFileName=function( fileName ){
    var fileList =new Array();
    tar.list({ 
        file: fileName, 
        sync: true,
        onentry:  entry => fileList.push(entry.path),
        });
    return fileList.length > 0 ? fileList[0].split('/')[0] : null;
}

//读取Zip的文件名
var readZipFileName = function(fileName){
    var unzippedfs = zipLocal.sync.unzip(fileName).memory();
    return unzippedfs.files_list[0].split('/')[0]
}


//获取依赖包路径 
var OSImagePath = getComponent( imagesPath ,'centos-');
var jdkComponent = getComponent( runTimePath , 'jdk-');
var tomcatComponent = getComponent( runTimePath , 'apache-tomcat-');


//读取顶级目录
var tomcatWorkName = readZipFileName(tomcatComponent);
var jdkWorkName = readTarFileName(jdkComponent)




//替换模版
var m = {
    'CentosName':path.basename(OSImagePath),
    'passWord':config.passWord,
    'tomcat':path.basename(tomcatComponent),
    'tomcatWork':tomcatWorkName,
    'jdkWork':jdkWorkName,
    'jdk':path.basename(jdkComponent),
    'installPath':config.installPath,
    'javaOpts':config.javaOpts
}

//build ....
if ( ! fs.existsSync (buildPath) ) {
    fs.mkdirSync(buildPath);
}

//替换内容
DockerfileContent = replaceContent(DockerfileContent,m);
//写出 Dockerfile 文件
fs.writeFileSync(path.join(buildPath,'Dockerfile'), DockerfileContent);
//拷贝系统镜像到编译目录
copyFile(OSImagePath,path.join(buildPath,path.basename(OSImagePath)));
//拷贝运行环境
copyFile(jdkComponent,path.join(buildPath,path.basename(jdkComponent)));
copyFile(tomcatComponent,path.join(buildPath,path.basename(tomcatComponent)));



console.log('Make finish .');

//ͨ�����ù���
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

//����
var DockerfileContent = fs.readFileSync(_DockerfilePath).toString();


//�����ļ�
var copyFile = function (src, dst) {
  fs.writeFileSync(dst, fs.readFileSync(src));
}


//��ȡ���
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

//�滻����
var replaceContent = function(content , map){
    var result = content;
    for (var key in map){
        result = result.split('${'+key+'}').join(map[key]);
    }
    return result;
}

//��ȡTar���ļ���
var readTarFileName=function( fileName ){
    var fileList =new Array();
    tar.list({ 
        file: fileName, 
        sync: true,
        onentry:  entry => fileList.push(entry.path),
        });
    return fileList.length > 0 ? fileList[0].split('/')[0] : null;
}

//��ȡZip���ļ���
var readZipFileName = function(fileName){
    var unzippedfs = zipLocal.sync.unzip(fileName).memory();
    return unzippedfs.files_list[0].split('/')[0]
}


//��ȡ������·�� 
var OSImagePath = getComponent( imagesPath ,'centos-');
var jdkComponent = getComponent( runTimePath , 'jdk-');
var tomcatComponent = getComponent( runTimePath , 'apache-tomcat-');


//��ȡ����Ŀ¼
var tomcatWorkName = readZipFileName(tomcatComponent);
var jdkWorkName = readTarFileName(jdkComponent)




//�滻ģ��
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

//�滻����
DockerfileContent = replaceContent(DockerfileContent,m);
//д�� Dockerfile �ļ�
fs.writeFileSync(path.join(buildPath,'Dockerfile'), DockerfileContent);
//����ϵͳ���񵽱���Ŀ¼
copyFile(OSImagePath,path.join(buildPath,path.basename(OSImagePath)));
//�������л���
copyFile(jdkComponent,path.join(buildPath,path.basename(jdkComponent)));
copyFile(tomcatComponent,path.join(buildPath,path.basename(tomcatComponent)));



console.log('Make finish .');

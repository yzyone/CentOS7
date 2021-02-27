测试环境：Centos 7.8

第一步：下载SRS3.0版本：

SRS下载列表：http://ossrs.net/srs.release/releases/download.html

    wget http://ossrs.net/srs.release/releases/files/SRS-CentOS7-x86_64-3.0.153.zip

git获取太慢，建议直接使用wget进行下载，若服务器上没有wget，则用`yum -y install wget`命令进行安装；

第二步：解压SRS

    unzip SRS-CentOS7-x86_64-1.0.153.zip

第三步：安装SRS

    cd SRS-CentOS7-x86_64-1.0.153
    bash INSTALL

第四步：安装依赖环境

    yum install -y redhat-lsb

第五步：更新Yum

    yum install epel-release -y
    yum update -y

第六步：安装FFmpeg 和 FFmpeg开发包

    rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
    rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
    yum install ffmpeg ffmpeg-devel -y

第七步：启动SRS

    /etc/init.d/srs start

第八步：推流测试


    ./ffmpeg -re -i source.200kbps.768x320.flv -vcodec copy -acodec copy -f flv -y rtmp://srs_server_ip/zclh/livestream

注意：Centos防火墙需要关闭，安全组放开端口。

不忘初心，方的始终！！！
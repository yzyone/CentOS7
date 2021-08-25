
# 记录CENTOS感染KDEVTMPFSI病毒, 百度无效后, 自我查杀 #

标签： Centos  反病毒  centos


特征1: 中了病毒后,疯狂运行CPU


运行用户是apache


用户资料:

    $ cat /etc/passwd
    apache:x:48:48:Apache:/usr/share/httpd:/sbin/nologin

 

//查看PID对应进程操作

    $ strace -p PID  
 

第一次尝试: 先不急着kill掉程序,因为对于病毒kill是没用的

第一直觉肯定是

    crontab -l //查看定时任务
     
    crontab -e //修改定时任务

看到第一句就是被恶意修改的定时任务 从xxx.xxx.xx.xxx IP地址获取

马上删掉定时任务,

下一步就是查看该进程中的依赖文件

    systemctl status PID

依赖文件分别为

    /var/tmp/kinsing
     
    /tmp/kdevtmpfsi

进行删除,删除文件后又被创建

 

第二次尝试: 清除用户, 因为是apache用户, 只能对apache这个软件进行卸载,该用户进行手动删除,重装apache

第三次尝试: 占位文件, 有效但是并不彻底解决

第四次尝试: 找出所有apache用户创建的文件

    $ find / -user apache

找到所有文件下, 带有cron关键字的文件

如下一个可疑的: `/var/spool/cron/apache`

vi 打开马上看见一句 定时任务, 可以确定

 

版权声明：本文为oDream122原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。

本文链接：https://blog.csdn.net/oDream122/article/details/104821067
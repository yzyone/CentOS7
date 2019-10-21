#Centos7安装Redis

原文链接: https://www.jianshu.com/p/f4e27cf54f60
余炳高笔记


一、安装redis 

        yum install redis

        出现选择就一直 y

安装完成
二、启动redis服务 

       /bin/systemctl  start  redis.service

三、测试redis

       redis-cli

       set  'test'  'hello'

       get  'test'

测试redis
四、修改配置

        1.找配置文件 

            whereis  redis.config     

找配置文件
       2.打开配置文件  

           vi /etc/redis.conf



允许外部访问
        允许远程访问

        #bind 127.0.0.1

        端口号

        port 8888

        设置密码

        requirepass FA86D6708231EACC2EC22F0_20190624

        关闭保护

        protected-mode no

          ESC  :wq  保存

         /bin/systemctl  restart  redis.service

常用命令

    启动  /bin/systemctl  start  redis.service

    重启  /bin/systemctl  restart  redis.service

    关闭  /bin/systemctl  stop  redis.service
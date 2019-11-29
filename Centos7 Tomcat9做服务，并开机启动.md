﻿﻿
# Centos7 tomcat做服务，并开机启动（亲测可用）

原文链接：[https://blog.csdn.net/Rain_xiaolong/article/details/80569972](https://blog.csdn.net/Rain_xiaolong/article/details/80569972)

---

系统版本：CentOS Linux release 7.6.1810 (Core)

Tomcat版本：9.0.27

Jdk版本：11.0.1

tomcat安装目录：/usr/local/tomcat9

jdk目录：/usr/java/jdk-11.0.1

### 设置jdk的环境变量 
```
#vi /etc/profile
...
JAVA_HOME=/usr/java/jdk-11.0.1
CLASSPATH=.:$JAVA_HOME/lib.tools.jar
PATH=$JAVA_HOME/bin:$PATH
export JAVA_HOME CLASSPATH PATH
```

### 设置CATALINA_PID

catalina.sh在执行的时候会调用同级路径下的setenv.sh来设置额外的环境变量，因此在/usr/local/tomcat9/bin路径下创建setenv.sh文件，内容如下：

```
#vim /usr/local/tomcat/bin/setenv.sh
...
export CATALINA_HOME=/usr/local/tomcat9
export CATALINA_BASE=/usr/local/tomcat9
#设置Tomcat的PID文件
CATALINA_PID="$CATALINA_BASE/tomcat.pid"
#添加JVM选项
JAVA_OPTS="-XX:PermSize=256M -XX:MaxPermSize=1024m -Xms512M -Xmx1024M -XX:MaxNewSize=256m"
```

### 配置服务文件tomcat.service

编写tomcat.service文件,在/usr/lib/systemd/system路径下添加tomcat.service文件，内容如下：

```
[Unit]
Description=Tomcat
After=syslog.target network.target remote-fs.target nss-lookup.target
 
[Service]
Type=forking
PIDFile=/usr/local/tomcat9/tomcat.pid
ExecStart=/usr/local/tomcat9/bin/startup.sh
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true
 
[Install]
WantedBy=multi-user.target
```
 
 
```
[unit]配置了服务的描述，规定了在network启动之后执行，
[service]配置服务的pid，服务的启动，停止，重启
[install]配置了使用用户
```

### 将Tomcat加入服务管理

```
开机启动
systemctl enable tomcat.service
开机禁止启动
systemctl disable tomcat.service
启动tomcat
systemctl start tomcat.service
关闭tomcat
systemctl stop tomcat.service
重启
systemctl restart tomcat.service
```




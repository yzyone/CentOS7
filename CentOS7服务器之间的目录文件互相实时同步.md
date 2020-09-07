通过lsyncd 设置两个linux（centOS7）服务器之间的目录文件互相实时同步

---

官网开源地址

https://github.com/axkibe/lsyncd

官网配置手册

https://axkibe.github.io/lsyncd/

注意：Lsyncd存在数据被替换风险，操作前请做好数据备份！

Lsyncd 是一个简单高效的文件同步工具，通过lua语言封装了 inotify 和 rsync 工具，采用了 Linux 内核（2.6.13 及以后）里的 inotify 触发机制，然后通过rsync去差异同步，达到实时的效果。

我们最终目的是配置A和B服务器的/home/data/目录文件互相同步

A服务器 192.168.101.56

B服务器 192.168.101.58

1、安装lsyncd

1.1 安装epel仓库

CentOS 7内置的源并没有包括Lsyncd，可以自行编译安装Lsyncd，不过更简单的办法是先安装epel源，就可以直接yum安装了，以下命令再A服务器执行。

	yum -y install epel-release

1.2 安装lsyncd

安装依赖（主要是lua和lua-devel，其他的可以先不安装，有需要在安装）

	yum -y install lua lua-devel
	yum -y install pkgconfig gcc asciidoc

安装lsyncd

	yum -y install lsyncd

lsyncd基于rsync，安装lsyncd时会自动安装rsync

查看lsyncd版本

lsyncd --version

2、修改lsyncd配置文件

将A和B服务器的/etc/lsyncd.conf分别修改为如下（建议直接下载下来修改后再上传，而不是vim）：

修改后如下

A服务器配置文件/etc/lsyncd.conf的内容

```
----
-- User configuration file for lsyncd.
--
-- Simple example for default rsync, but executing moves through on the target.
--
-- For more examples, see /usr/share/doc/lsyncd*/examples/
-- 
-- sync{default.rsyncssh, source="/var/www/html", host="localhost", targetdir="/tmp/htmlcopy/"}
 
 
settings {
    logfile      = "/var/log/lsyncd/lsyncd.log",
    statusFile   = "/var/log/lsyncd/lsyncd.status",
    inotifyMode  = "CloseWrite",
    nodaemon     = false,
    insist       = true,
    maxProcesses = 6,
    maxDelays    = 50000,  -- 不能设置很小，防止文件还没同步完就反向同步了，我设置很大值
    statusInterval = 5,
}
 
sync {
    default.rsync,
    source = "/home/data/",
    target = "root@192.168.101.58:/home/data/",
    delay  = 30,  -- 不能设置很小，防止文件还没同步完就反向同步了，我设置很大值
    -- excludeFrom = "/home/data/cache/",
    exclude = { "*.bak", "*.tmp" },
    rsync = {
        binary = "/usr/bin/rsync",
        archive = true,
        compress = false,
        verbose = true,
    }  
}
```

B服务器配置文件/etc/lsyncd.conf的内容

```
----
-- User configuration file for lsyncd.
--
-- Simple example for default rsync, but executing moves through on the target.
--
-- For more examples, see /usr/share/doc/lsyncd*/examples/
-- 
-- sync{default.rsyncssh, source="/var/www/html", host="localhost", targetdir="/tmp/htmlcopy/"}
 
 
settings {
    logfile      = "/var/log/lsyncd/lsyncd.log",
    statusFile   = "/var/log/lsyncd/lsyncd.status",
    inotifyMode  = "CloseWrite",
    nodaemon     = false,
    insist       = true,
    maxProcesses = 6,
    maxDelays    = 50000,  -- 不能设置很小，防止文件还没同步完就反向同步了，我设置很大值
    statusInterval = 5,
}
 
sync {
    default.rsync,
    source = "/home/data/",
    target = "root@192.168.101.56:/home/data/",
    delay  = 30,  -- 不能设置很小，防止文件还没同步完就反向同步了，我设置很大值
    -- excludeFrom = "/home/data/cache/",
    exclude = { "*.bak", "*.tmp" },
    rsync = {
        binary = "/usr/bin/rsync",
        archive = true,
        compress = false,
        verbose = true,
    }  
}
```

lsyncd 配置说明

settings 部分 关于lsyncd工具自身的一些选项设置

```
--: 注释, 因为是lua 语言,所以 --是注释
logfile : 指定lsyncd工具本身运行所产生的日志文件存放位置
statusFile : 定义lsyncd监控目录状态文件的存放位置
statusInterval : 隔多少秒记录一次被监控目录的状态，默认好像是10秒
nodaemon=true : 默认是不启用守护模式的
inotifyMode : 指定要监控的事件,如,CloseWrite,Modify,CloseWrite or Modify, 默认是CloseWrite

insist：继续运行，即使有失败的目标。
maxProcesses : 指定同步时进程的最大个数
maxDelays : 当事件被命中累计多少次后才进行一次同步
```

sync 部分 主要用来定义同步时的一些设置,可以同时同步多个目录,只需要在该代码块中事先定义好多个sync即可

```
default.rsync : 指定lsyncd运行模式,另外,还有>default.direct,default.rsyncssh模式
source : 指定要监控的目录,务必全部用绝对路径
target : 要同步到的目标目录,一般为rsync服务端模块下指定的目录,说明: 'rsyncuser@192.168.10.20::bak' , 'rsyncuser':同步的用户在备服务器上设置 ,'192.168.10.20':备服务器地址, '::backup':模块名称,同步路径在备服务器上设置
init : 为false时表示只同步lsyncd进程启动以后发生改动事件的文件,否则,反之,默认为true
delay : 当有命中的事件后多少秒后触发同步
exclude : 通过此选项排除掉不需要同步的文件,可用它自己的正则进行匹配
delete 为了保持target与souce完全同步，Lsyncd默认会delete = true来允许同步删除。它除了false，还有startup、running值，请参考 Lsyncd 2.1.x ‖ Layer 4 Config ‖ Default Behavior。
delete = true 默认。 Lsyncd将在目标上删除不在源代码中的任何东西。在启动时以及在正常操作过程中被删除的内容
delete = false Lsyncd不会删除目标上的任何文件。不在启动或正常运行。 （虽然可以覆盖）
delete = 'startup' Lsyncd将在启动时删除目标上的文件，但不会进行正常操作。
delete = 'running' Lsyncd在启动时不会删除目标上的文件，但会删除那些在正常操作期间被删除的文件
```

3、设置A/B两服务器相互免密登录

很简单，直接参考这个：https://blog.csdn.net/lishuoboy/article/details/89853331

4、启动lsyncd(A、B服务器都启动完成可以互相同步了，启动一个可以单向同步)

	启动 systemctl start lsyncd
	停止 systemctl stop lsyncd
	重启 systemctl restart lsyncd
	查看状态 systemctl status lsyncd
	查看日志 tail -f /var/log/lsyncd/lsyncd.log


5、设置开机自启动

	在开机时启用一个服务：systemctl enable lsyncd
	在开机时禁用一个服务：systemctl disable lsyncd
	查看服务是否开机启动：systemctl is-enabled lsyncd

开机启动参考文章  https://blog.csdn.net/lishuoboy/article/details/89676041

6、验证开机自启动成功

重启reboot

	reboot now

通过查看日志验证

	tail -f /var/log/lsyncd/lsyncd.log

通过查看进程验证

	ps -ef|grep lsyncd


传个文件验证一下（略）

7、防火墙调整、调整SELinux安全策略

这一步也可以放到最后，如果同步不成功，再看是不是防火墙或者SELinux的问题

7.1 关闭防火墙

	systemctl stop firewalld

查看防火墙状态

	systemctl status firewalld

你也可以不关闭防火墙，而是添加例外端口。防火墙的命令参考https://blog.csdn.net/lishuoboy/article/details/88301273

7.2 将SELinux策略改为警告

SELinux知识参考：https://blog.51cto.com/13570193/2093299

7.2.1 先临时改了

	setenforce 0

ps：setenforce 0|1  分别代表permissive（放纵的）、enforcing（强制） 

查看SELinux状态

	getenforce

7.2.2 设置SELinux永久为disabled

为防止服务器重启后SELinux模式改变，需要设置SELINUX=disabled。

	vim /etc/selinux/config

重启后验证一下

	reboot
	getenforce

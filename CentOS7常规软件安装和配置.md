CentOS7常规软件安装和配置

一、编译环境

安装gcc8.3.0

二、安装数据库

1、Postgresql

三、安装常规软件

1、宝塔

2、Oracle-JDK11

	java -version
	rpm -qa|grep java
	rpm -e --nodeps java-1.8.0-openjdk*
	rpm -e --nodeps java-1.7.0-openjdk*
	rpm -ivh jdk-11.0.4_linux-x64_bin.rpm

3、Redis

    yum install redis
    systemctl  enable  redis.service
    systemctl  start  redis.service
    redis-cli
    set  'test'  'hello'
    get  'test'

4、VNC

    yum install tigervnc-server 
    firewall-cmd --zone=public --add-port=5900-5999/tcp --permanent

5、Wireshark

    yum install wireshark

6、DarwinServer

7、Screen

    yum -y install screen
    screen -S xydeb
    screen -ls

四、优化系统配置

1、修改文件/etc/sysctl.conf

	vi /etc/sysctl.conf

添加下面的行：

	#禁用ipv6
	net.ipv6.conf.all.disable_ipv6 =1
	net.ipv6.conf.default.disable_ipv6 =1

	#修改swappiness
	vm.swappiness = 1

	#修改用户最大打开文件数
	fs.file-max = 265535

	#允许送到队列的数据包的最大数目
	net.core.netdev_max_backlog = 30000
	#web 应用中listen 函数的backlog 默认会给我们内核参数的net.core.somaxconn 限制
	net.core.somaxconn = 65535
	
	#接收套接字缓冲区大小的最大值
	net.core.rmem_max=16777216
	#发送套接字缓冲区大小的最大值
	net.core.wmem_max=16777216
	
	#TCP接收缓冲区
	net.ipv4.tcp_rmem=4096 87380 16777216
	#TCP发送缓冲区
	net.ipv4.tcp_wmem=4096 87380 16777216
	
	#修改系統默认的 TIMEOUT 时间
	net.ipv4.tcp_fin_timeout = 20
	#这个限制仅仅是为了防止简单的DoS 攻击
	net.ipv4.tcp_max_orphans = 262144
	#表示SYN队列的长度,默认为1024
	net.ipv4.tcp_max_syn_backlog = 262144
	
	#表示用于向外连接的端口范围,缺省情况下很小：32768到61000
	net.ipv4.ip_local_port_range = 10000 65000

还可以在目录中/etc/sysctl.d/新增配置文件

保存并退出文件。
执行下面的命令来使设置生效。

    sysctl -p

2、修改somaxconn参数

	echo 65535 >/proc/sys/net/core/somaxconn

3、修改文件/etc/security/limits.conf

　 在Linux平台上，无论编写客户端程序还是服务端程序，在进行高并发TCP连接处理时，最高的并发数量都要受到系统对用户单一进程同时可打开文件数量的限制(这是因为系统为每个TCP连接都要创建一个socket句柄，每个socket句柄同时也是一个文件句柄)，这个数字可以设的更大。

	Ulimit –n 265535

   此命令是临时更改，也可以通过修改文件/etc/security/limits.conf

添加如下行：

	root             soft    nproc           655350
	root             hard    nproc           655350
	root             soft    nofile          655350
	root             hard    nofile          655350
	
	dell             soft    nproc           655350
	dell             hard    nproc           655350
	dell             soft    nofile          655350
	dell             hard    nofile          655350
	
	*                soft    nproc           655350
	*                hard    nproc           655350
	*                soft    nofile          655350
	*                hard    nofile          655350

还可以在/etc/security/limits.d/20-nproc.conf 修改或注释

	*          soft    nproc     655350
	root       soft    nproc     unlimited

用户还可以修改/etc/systemd/system.conf 或者 /etc/systemd/user.conf

    [Manager]
    #LogLevel=info
    #LogTarget=console
    #LogColor=yes
    #LogLocation=no
    #SystemCallArchitectures=
    #TimerSlackNSec=
    #DefaultTimerAccuracySec=1min
    #DefaultStandardOutput=inherit
    #DefaultStandardError=inherit
    #DefaultTimeoutStartSec=90s
    #DefaultTimeoutStopSec=90s
    #DefaultRestartSec=100ms
    #DefaultStartLimitInterval=10s
    #DefaultStartLimitBurst=5
    #DefaultEnvironment=
    #DefaultLimitCPU=
    #DefaultLimitFSIZE=
    #DefaultLimitDATA=
    #DefaultLimitSTACK=
    DefaultLimitCORE=infinity
    #DefaultLimitRSS=
    DefaultLimitNOFILE=655350
    #DefaultLimitAS=
    DefaultLimitNPROC=655350
    #DefaultLimitMEMLOCK=
    #DefaultLimitLOCKS=
    #DefaultLimitSIGPENDING=
    #DefaultLimitMSGQUEUE=
    #DefaultLimitNICE=
    #DefaultLimitRTPRIO=
    #DefaultLimitRTTIME=

最后，重启生效

    netstat -lnpt
    reboot

五、网络配置

1、配置文件

	#修改主机名称
    /etc/hostname
    #设置网卡参数
    /etc/sysconfig/network-scripts/ifcfg-enoXXX
    #设置DNS相关信息
    /etc/resolv.conf
    #设置IP对应的主机名
    /etc/hosts
    #选择DNS解析优先还是本地配置优先
    /etc/nsswitch.conf

2、配置Linux的IP地址

修改文件ifcfg-enoXXX

	service network restart

3、设置主机名

	hostname XXX

4、设置默认网关

	route add default gw xxx.xxx.xxx.xxx

或者
修改文件/etc/sysconfig/network-scripts/ifcfg-enoXXX，添加如下字段：

	GATEWAY=xxx.xxx.xxx.xxx

最后执行命令

	service network restart

5、设置DNS服务器

修改文件/etc/resolv.conf

    #cat /etc/resolv.conf
    nameserver xxx.xxx.xxx.xxx
    nameserver xxx.xxx.xxx.xxx
    options rotate
    options timeout:1 attempts:2

6、补充命令

    # ip link show # 显示网络接口信息
    # ip link set eth0 upi # 开启网卡
    # ip link set eth0 down # 关闭网卡
    # ip link set eth0 promisc on # 开启网卡的混合模式
    # ip link set eth0 promisc offi # 关闭网卡的混个模式
    # ip link set eth0 txqueuelen 1200 # 设置网卡队列长度
    # ip link set eth0 mtu 1400 # 设置网卡最大传输单元
    # ip addr show # 显示网卡IP信息
    # ip addr add 192.168.0.1/24 dev eth0 # 设置eth0网卡IP地址192.168.0.1
    # ip addr del 192.168.0.1/24 dev eth0 # 删除eth0网卡IP地址
    
    # ip route list # 查看路由信息
    # ip route add 192.168.4.0/24 via 192.168.0.254 dev eth0 # 设置192.168.4.0网段的网关为192.168.0.254,数据走eth0接口
    # ip route add default via 192.168.0.254 dev eth0 # 设置默认网关为192.168.0.254
    # ip route del 192.168.4.0/24 # 删除192.168.4.0网段的网关
    # ip route del default # 删除默认路由

六、防火墙设置

关闭并禁用firewalld

    #systemctl stop firewalld
    #systemctl disable firewalld

关闭并禁用iptables

    #systemctl stop iptables
    #systemctl disable iptables

关闭并禁用ip6tables

    #systemctl stop ip6tables
    #systemctl disable ip6tables

七、关闭SELinux

查看是否开启了SELinux

	sestatus -v

可以通过修改SELinux的配置开启或关闭它：

	vim /etc/selinux/config

关闭SELinux

	SELINUX=disabled

开启

	SELINUX=enforcing

修改完成以后重启系统


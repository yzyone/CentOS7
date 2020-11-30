
优化系统的相关命令
    
1）查看当前进程的最大可以打开的文件数
 
     cat /proc/进程ID/limits
 
2）查看当前进程实时打开的文件数
 
     lsof -p PID |wc -l
 
3）查看系统总限制打开文件的最大数量
 
     cat /proc/sys/fs/file-max
 
注：若设置不生效，查看包含的目录下的配置文件是否覆盖，如/etc/security/limits.d/下的文件是否覆盖了/etc/security/limits.conf设置的值 

优化系统配置

1）修改文件/etc/sysctl.conf

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

2）修改somaxconn参数

	echo 65535 >/proc/sys/net/core/somaxconn

注：对于一个TCP连接，Server与Client需要通过三次握手来建立网络连接.当三次握手成功后,我们可以看到端口的状态由LISTEN转变为ESTABLISHED,接着这条链路上就可以开始传送数据了.每一个处于监听(Listen)状态的端口,都有自己的监听队列.监听队列的长度与如somaxconn参数和使用该端口的程序中listen()函数有关

somaxconn参数:定义了系统中每一个端口最大的监听队列的长度,这是个全局的参数,默认值为128，对于一个经常处理新连接的高负载 web服务环境来说，默认的 128 太小了。大多数环境这个值建议增加到 1024 或者更多。大的侦听队列对防止拒绝服务 DoS 攻击也会有所帮助。

3）修改文件/etc/security/limits.conf

　 在Linux平台上，无论编写客户端程序还是服务端程序，在进行高并发TCP连接处理时，最高的并发数量都要受到系统对用户单一进程同时可打开文件数量的限制(这是因为系统为每个TCP连接都要创建一个socket句柄，每个socket句柄同时也是一个文件句柄)，这个数字可以设的更大。

	ulimit –n 265535

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

    reboot

4）在程序启动脚本中加入下面两句，注意值不能太大，太大反而变成4096了。

    LimitNOFILE=655350
    LimitNPROC=655350
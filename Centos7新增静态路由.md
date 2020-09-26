
### Centos7新增静态路由 ###

一、临时方式

1. 查看路由和ip

查看路由

	[root@centos7 ~]# route -n

查看ip

	[root@centos7 ~]# ip a

2. 新增静态路由

新增到目的地址1的静态路由

	[root@centos7 ~]# ip route add 172.28.105.0/24 via 172.27.9.254 dev ens33
 
新增到目的地址2的静态路由

	[root@centos7 ~]# ip route add 172.28.214.17/32 via 172.27.9.254 dev ens33

查看路由信息

	[root@centos7 ~]# route -n

二、永久方式

实现的形式有两种

1. 实现形式1

新增或编辑配置文件route-interfacename，interfacename为网卡名，本文为ens33

	[root@centos7 ~]# view /etc/sysconfig/network-scripts/route-ens33
	ADDRESS0=172.28.105.0
	NETMASK0=255.255.255.0
	GATEWAY0=172.27.9.254
	ADDRESS1=172.28.214.17
	NETMASK1=255.255.255.255
	GATEWAY1=172.27.9.254

注意序号为0和1
 
重启网络

	[root@centos7 ~]# systemctl restart network


2. 实现形式2

	[root@centos7 ~]# view /etc/sysconfig/network-scripts/route-ens33 
	172.28.105.0/24 via 172.27.9.254 dev ens33
	172.28.214.17/32 via 172.27.9.254 dev ens33

重启网络

	[root@centos7 ~]# systemctl restart network


三、删除静态路由

1. 删除路由

	[root@centos7 ~]# ip route del 172.28.105.0/24
	[root@centos7 ~]# ip route del 172.28.214.17/32
	[root@centos7 ~]# route -n
	Kernel IP routing table
	Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
	0.0.0.0         172.27.9.254    0.0.0.0         UG    100    0        0 ens33
	10.244.0.0      10.244.0.0      255.255.255.0   UG    0      0        0 flannel.1
	10.244.1.0      0.0.0.0         255.255.255.0   U     0      0        0 cni0
	10.244.2.0      10.244.2.0      255.255.255.0   UG    0      0        0 flannel.1
	172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
	172.27.9.0      0.0.0.0         255.255.255.0   U     100    0        0 ens33

该方式会立即删除静态路由

2. 清除配置
3. 
rm route-ens33或者echo > route-ens33或者注释该配置文件的路由条目

	#ADDRESS0=172.28.105.0
	#NETMASK0=255.255.255.0
	#GATEWAY0=172.27.9.254
	#ADDRESS1=172.28.214.17
	#NETMASK1=255.255.255.255
	#GATEWAY1=172.27.9.254

下次重启时，静态路由永久删除

四、注意事项

添加永久静态路由方式一中要注意序号，由0开始依次新增，序号不能跳，若只有一条路由则序号为0；

两种永久方式不可以混用，否则配置的路由条目不会完全生效；

通过编辑配置文件/etc/rc.local，开机自启动方式新增静态路由方式不生效；
centos7配置IP地址
 

有关于centos7获取IP地址的方法主要有两种，1：动态获取ip；2：设置静态IP地址

在配置网络之前我们先要知道centos的网卡名称是什么，centos7不再使用ifconfig命令，可通过命令 IP addr查看，如图，网卡名为ens33，是没有IP地址的

```
[dell@localhost ~]$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:0c:29:59:f2:a7 brd ff:ff:ff:ff:ff:ff
3: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 52:54:00:18:44:ef brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0
       valid_lft forever preferred_lft forever
4: virbr0-nic: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast master virbr0 state DOWN group default qlen 1000
    link/ether 52:54:00:18:44:ef brd ff:ff:ff:ff:ff:ff
```


1、动态获取ip（前提是你的路由器已经开启了DHCP）

修改网卡配置文件 vi /etc/sysconfig/network-scripts/ifcfg-ens33    (最后一个为网卡名称)

```
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=dhcp
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens33
UUID=3c7714c5-6a5c-42c3-bb19-59ffb50d16da
DEVICE=ens33
ONBOOT=no
```

动态获取IP地址需要修改两处地方即可

（1）bootproto=dhcp

（2）onboot=yes

修改后重启一下网络服务即可

    systemctl restart network

这样动态配置IP地址就设置好了，这个时候再查看一下ip addr 就可以看到已经获取了IP地址，且可以上网

```
[root@localhost dell]# ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:0c:29:59:f2:a7 brd ff:ff:ff:ff:ff:ff
    inet 192.168.153.131/24 brd 192.168.153.255 scope global noprefixroute dynamic ens33
       valid_lft 1754sec preferred_lft 1754sec
    inet6 fe80::feb4:11bb:a261:37eb/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```

2、配置静态IP地址

设置静态IP地址与动态iIP差不多，也是要修改网卡配置文件 vi /etc/sysconfig/network-scripts/ifcfg-ens32    (最后一个为网卡名称)

（1）bootproto=static

（2）onboot=yes

（3）在最后加上几行，IP地址、子网掩码、网关、dns服务器

    IPADDR=192.168.101.5
    NETMASK=255.255.255.0
    GATEWAY=192.168.101.1
    DNS1=119.29.29.29
    DNS2=8.8.8.8

（4）重启网络服务

    systemctl restart network

查看一下ip addr 就可以看到已经获取了IP地址，且可以上网

```
[root@mini ~]# ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:0c:29:59:f2:a7 brd ff:ff:ff:ff:ff:ff
    inet 192.168.101.5/24 brd 192.168.101.255 scope global noprefixroute ens33
       valid_lft forever preferred_lft forever
    inet6 fe80::feb4:11bb:a261:37eb/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
[root@mini ~]# ping www.baidu.com
PING www.a.shifen.com (163.177.151.109) 56(84) bytes of data.
64 bytes from 163.177.151.109 (163.177.151.109): icmp_seq=1 ttl=55 time=27.5 ms
64 bytes from 163.177.151.109 (163.177.151.109): icmp_seq=2 ttl=55 time=35.2 ms
^C
--- www.a.shifen.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1008ms
rtt min/avg/max/mdev = 27.570/31.425/35.281/3.859 ms
```
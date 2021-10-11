
# QEMU网络模式(一)——bridge #

## 网络配置 ##

**QEMU支持的网络模式**

qemu-kvm主要向客户机提供了4种不同模式的网络。

　　1)基于网桥(bridge)的虚拟网卡;

　　2)基于NAT的虚拟网络

　　3)QEMU内置的用户模式网络(user mode networking)

　　4)直接分配网络设备的网络(包括VT-d和SR-IOV)

**一、使用网桥模式**

在qemu-kvm命令行中，关于bridge模式的网络参数如下：

```
-net tap[,vlan=n][,name=str][,fd=h][,ifname=name][,script=file][,downscript=dfile][,sndbuf=nbytes][,vnet_hdr=on|off][,vhost=on|off][,vhostfd=h][,vhostforce=on|off]
```

1) 安装bridge-utils和tunctl软件包

```
# yum -y install bridge-utils tunctl
```

2) 查看tun模块是否被加载

```
# lsmod | grep tun
```

如果没有加载,则运行modprobe tun进行加载。如果已经将tun编译到内核(可查看内核config文件中是否有"CONFIG=y"选项)，则不需要加载了。如果内核完全没有配置TUN模块，则需要重新编译内核才行。

```
# grep 'CONFIG_TUN' /boot/config-`uname -r`
```

3) 检查/dev/net/tun的权限,需要让当前用户拥有读写的权限。

```
# ls -lh /dev/net/tun
```

4) 建立一个bridge,将其绑定到一个可正常工作的网络接口上，同时让bridge成为连接本机与外部网络的接口。

```
# brctl addr br0
# brctl addif br0 eth0
# brctl stp br0 on
# route
# ping 192.168.1.254
```

或者编辑配置文件建立网桥

```
# cat /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
ONBOOT=yes
BRIDGE="br0"
[root@kvm ~]# 
# cat /etc/sysconfig/network-scripts/ifcfg-br0
DEVICE="br0"
ONBOOT="yes"
TYPE="Bridge"
BOOTPROTO="none"
IPADDR="192.168.100.10"
NETMASK="255.255.255.0"
STP="on"
DELAY="0"

# service network restart
```
-----

```
# dmesg
…………
device virbr0-nic entered promiscuous mode
br0: port 1(eth0) entering forwarding state 
…………
```

建立bridge后的状态是让网络接口eth0进入混杂模式(promiscuous mode,接收网络中所有数据包),网桥br0进入转发状态(forwarding state),并且与eth0具有相同的MAC地址，

5)准备qemu-ifup和qemu-ifdown脚本

客户机启动网络前会执行的脚本由"script"选项配置的(默认为/etc/qemu-ifup)。一般在该脚本上创建一个TAP设备并将其中与bridge绑定起来。

```
#!/bin/bash
#filename: /etc/qemu-ifup
switch=br0

if [ -n "$1" ];then
#tunctl -u $(whoami) -t $1 #一些较旧版本中不会自动创建TAP设备
ifconfig $1 up
sleep 0.5s
brctl addif $switch $1
exit 0
else
echo 'Error: no specifed interface.'
exit 1
fi
```

由于qemu-kvm工具在客户机关闭时会解除TAP设备的bridge绑定,也会自动删除已不再使用的TAP设备，所有qemu-ifdown这个脚本不是必需的,最好设置为downscript=no(qemu-kvm的script参数是虚拟机启动时执行的脚本,downscript参数是虚拟机关闭时执行的参数)

```
# cat /etc/qemu-ifdown 
#!/bin/bash

switch=br0

if [ -n $1 ];then
tunctl -d $1
brctl delif ${switch} $1
ip link set $1 down
exit 0
else
echo "Error: no interface specified"
exit 1
fi
```

6)创建一个虚拟机

创建一个稀梳格式的磁盘

```
# dd if=/dev/zero of=/root/centos6.img bs=1M oflag=direct seek=4095 count=1
```

使用镜像安装一个centos6的minimal系统

```
# qemu-kvm -m 768 \
-smp 2 \
--boot order=cd \
--hda /root/centos6.img \
--cdrom /root/CentOS-6.9-x86_64-minimal.iso
```

7)用qemu-kvm命令启动bridge模式的网络
在宿主机中，用命令行启动客户机并检查bridge的状态，如下：

```
# qemu-kvm /root/centos6.img \
-smp 2 \
-m 1024 \
-net nic \
-net tap,ifname=tap1,script=/etc/qemu-ifup,downscript=no \
-vnc :0 \
-daemonize
```

虚拟机启动后，使用下面命令可以看到TAP0被创建了

```
# brctl show
# ls /sys/devices/virtual/net/
# vcnview :0
```

关闭虚拟机后，使用下面可以看到TAP0被删除了

```
# brctl show
# ls /sys/devices/virtual/net/
```

分类: kvm虚拟化

原文链接： https://www.cnblogs.com/fang9045315/p/8964346.html
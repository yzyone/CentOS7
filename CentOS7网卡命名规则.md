
# CentOS7网卡命名规则 #

- CentOS6之前基于传统的命名方式如：eth1，eth0....
- Centos7提供了不同的命名规则，默认是基于固件、拓扑、位置信息来分配。这样做的优点是命名是全自动的、可预知的，缺点是比eth0、wlan0更难读。比如enp5s0

一、网卡命名的策略

systemd对网络设备的命名方式

- 规则1：如果Firmware或者BIOS提供的设备索引信息可用就用此命名。比如eno1。否则使用规则2
- 规则2：如果Firmware或Bios的PCI-E扩展插槽可用就用此命名。比如ens1，否则使用规则3
- 规则3：如果硬件接口的位置信息可用就用此命名。比如enp2s0
- 规则4：根据MAC地址命名，比如enx7d3e9f。默认不开启。
- 规则5：上述均不可用时回归传统命名方式

上面的所有命名规则需要依赖于一个安装包：biosdevname

二、前两个字符的含义

|en	|以太网	|Ethernet|
|wl	|无线局域网	|WLAN|
|ww	|无线广域网	|WWLAN|

三、第三个字符根据设备类型来选择

|format	|description|
|o<index>	|集成设备索引号|
|s<slot>	|扩展槽的索引号|
|x<MAX> s<slot>	|基于MAC进行命名|
|p<bus> s<slot>	|PCI扩展总线|

四、配置回归传统命名方式

1.编辑内核参数

在GRUB_CMDLINE_LINUX中加入`net.ifnames=0`即可

    [root@centos7 ~]$vim /etc/default/grub
    GRUB_CMDLINE_LINUX="crashkernel=auto net.ifnames=0 rhgb quiet"

2.为grub2生成配置文件
编辑完grub配置文件以后不会立即生效，需要生成配置文件。

    [root@centos7 ~]$grub2-mkconfig -o /etc/grub2.cfg

3.操作系统重启

    [root@centos7 ~]$reboot

4.验证



作者：Aubin
链接：https://www.jianshu.com/p/ef841a0f3c8b
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
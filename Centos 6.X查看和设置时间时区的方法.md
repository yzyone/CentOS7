方法/步骤

一、查看Centos的时区和时间

1、使用date命令查看Centos时区

    [root@VM_centos ~]# date -RMon, 26 Mar 2018 19:14:03 +0800

2、查看clock系统配置文件

[root@VM_centos ~]# cat /etc/sysconfig/clockZONE="Asia/Shanghai"

3、查看系统的硬件时间，即BIOS时间

    [root@VM_centos ~]# hwclock -rMon 26 Mar 2018 07:19:54 PM CST  -0.310338 seconds


二、修改Centos的时区

通常通过以下方法修改系统的时区就可以了，不必修改硬件时间。将时区信息文件拷贝至/etc/localtime下，将上海时区拷贝至/etc下。具体操作方式为：

    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime -R

三、Centos系统修改BIOS硬件时间

通常上述方法修改系统时区就可以了，但是如果硬件的时间本身不正确，可能需要修改BIOS的硬件时间，方法也很简单，先把系统时间设置正确后，把系统时间写入BIOS时间里。执行命令hwclock -w保存软件时间至硬件时间。

    hwclock -w

四、Linux系统时间同步

    ntpdate time.windows.com

END

经验内容仅供参考，如果您需解决具体问题(尤其法律、医学等领域)，建议您详细咨询相关领域专业人士。
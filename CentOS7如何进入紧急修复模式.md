centos7如何进入紧急修复模式?

centos7如何进入紧急修复模式呢?今天小编将为大家带来centos7进入紧急修复模式的方法！希望对大家会有帮助；有需要的朋友一起去看看吧

打开centos7页面出现： 


    welcome to emergency mode！after logging in ，type “journalctl -xb” to view system logs，
    “systemctl reboot” to reboot ，“systemctl default” to try again to boot into default mode。
    
    give root password for maintenance
    
    （？？ Control-D？？？）：


解决方法：

执行 runlevel 显示unknown

修改默认启动级别

a. 先删除: `mv /etc/systemd/system/default.target /etc/systemd/system/default.target.back` #将文件重命名即可 

b. 创建软连接文件： `ln -sf /lib/systemd/system/multi-user.target /etc/systemd/system/default.target` 

或者 `ln -sf /lib/systemd/system/runlevel3.target /etc/systemd/system/default.target` 

也可以使用systemctl命令： 

    systemctl set-default graphical.target 
    systemctl isolate multi-user.target

执行过程中报错：Error getting authority: Error initializing authority: Could not connect: Resource temporarily unavailable (g-io-error-quark, 1)

查看日志 `journalctl -xb`

发现日志中挂载出错：



可以看出是挂载问题，是/home文件没有挂载上

编辑自动挂载的文件 vi /etc/fstab

把挂载/home的那行注释掉（先备份）

    #/dev/mapper/centos-home  /home   xfs  default  0 0

重启服务器 `reboot`

启动成功后，页面卡在白条不动了，可以按esc键查看启动详情，是在`/etc/rc.d/rc.local`卡住了，重启进入单用户模式：

(1).开机时在默认项选e



(2).找到ro的那一行



(3)把ro改成 `rw init=/sysroot/bin/sh` ,按ctrl+x启动



(4)进入单用户页面后，要执行`chroot /sysroot`,获取root权限

进入单用户模式后编辑rc.local文件，把跟/home有关的启动项都注释掉，重启服务器

重启成功后进入正常模式，这时可以查看/home挂载的问题

(1).`lvs -a -o +devices`查看磁盘详细信息，可以看到home的attr参数没有a(激活)未激活状态

(2).`lvchange -a y /dev/mapper/centos-home` 激活home

(3).挂载home,`mount /dev/mapper/centos-home /home`

(4).挂载成功，把原来fstab和rc.local里注释的在改回去



重启成功，问题解决
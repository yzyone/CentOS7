在操作中，我们都会用SSH协议来远程控制虚拟机，但是在输入用户名时候，会有一段时间的卡顿，此时正在进行SSH协议的DNS解析，我们为了快速的连接到虚拟机上，就要关闭这个解析过程，如下是具体配置：

修改sshd配置：vim /etc/ssh/sshd_config

    [root@work1 ~]# vim /etc/ssh/sshd_config


# 关闭SSH的DNS解析

    UseDNS no

重启sshd服务：

    systemctl restart sshd
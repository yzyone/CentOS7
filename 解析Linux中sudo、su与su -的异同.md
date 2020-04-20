# 解析Linux中sudo,su与su -的异同 #

在linux系统中，由于root的权限过大，一般情况都不使用它。只有在一些特殊情况下才采用登录root执行管理任务，一般情况下临时使用root权限多采用su和sudo命令。

## 前言 ##

su命令就是切换用户的工具，怎么理解呢？比如我们以普通用户tom登录的，但要添加用户任务，执行useradd ，tom用户没有这个权限，而这个权限恰恰由root所拥有。解决办法无法有两个，一是退出tom用户，重新以root用户登录，但这种办法并不是最好的；二是我们没有必要退出tom用户，可以用su来切换到root下进行添加用户的工作，等任务完成后再退出root。

我们可以看到当然通过su切换是一种比较好的办法；通过su可以在用户之间切换，而超级权限用户root向普通或虚拟用户切换不需要密码，而普通用户切换到其它任何用户都需要密码验证。


## sudo ##

sudo是一种权限管理机制，依赖于/etc/sudoers，其定义了授权给哪个用户可以以管理员的身份能够执行什么样的管理命令；

    sudo -u USERNAME COMMAND

默认情况下，系统只有root用户可以执行sudo命令。需要root用户通过使用visudo命令编辑sudo的配置文件/etc/sudoers，才可以授权其他普通用户执行sudo命令。


## su ##

su为switch user，即切换用户的简写。

格式为两种：

    su -l USERNAME（-l为login，即登陆的简写）
    
    su USERNAME

如果不指定USERNAME（用户名），默认即为root，所以切换到root的身份的命令即为：su -root或su -，su root 或su。

su USERNAME，与su - USERNAME的不同之处如下：

su - USERNAME切换用户后，同时切换到新用户的工作环境中。

su USERNAME切换用户后，不改变原用户的工作目录，及其他环境变量目录。


## su - ##

su -，su -l或su --login 命令改变身份时，也同时变更工作目录，以及HOME，SHELL，USER，LOGNAME。此外，也会变更PATH变量。用su -命令则默认转换成成root用户了。

而不带参数的“su命令”不会改变当前工作目录以及HOME,SHELL,USER,LOGNAME。只是拥有了root的权限而已。

> 注意：su -使用root的密码,而sudo su使用用户密码
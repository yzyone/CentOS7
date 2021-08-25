
# /etc/systemd/system和/lib/systemd/system的区别 #

 发表于 2019-06-22  更新于 2021-02-21  分类于 2-linux系统 ， 系统  阅读次数： 553  Valine： 0
 本文字数： 1.6k  阅读时长 ≈ 1 分钟

1.目录

1.1 [/usr]/lib/systemd/system/

(软件包安装的单元)

The expectation is that /lib/systemd/system is a directory that should only contain systemd unit files which were put there by the package manager (YUM/DNF/RPM/APT/etc).

1.2 /etc/systemd/system/

(系统管理员安装的单元, 优先级更高)

Files in /etc/systemd/system are manually placed here by the operator of the system for ad-hoc software installations that are not in the form of a package. This would include tarball type software installations or home grown scripts.

2. 优先级

systemd的使用大幅提高了系统服务的运行效率, 而unit的文件位置一般主要有三个目录：

Table 1.  Load path when running in system mode (--system).

|Path                    | Description                 |
|/etc/systemd/system     | Local configuration         |
|/run/systemd/system     | Runtime units               |
|/lib/systemd/system     | Units of installed packages |

这三个目录的配置文件优先级依次从高到低，如果同一选项三个地方都配置了，优先级高的会覆盖优先级低的。

系统安装时，默认会将unit文件放在/lib/systemd/system目录。如果我们想要修改系统默认的配置，比如nginx.service，一般有两种方法：

在/etc/systemd/system目录下创建nginx.service文件，里面写上我们自己的配置。

在/etc/systemd/system下面创建nginx.service.d目录，在这个目录里面新建任何以.conf结尾的文件，然后写入我们自己的配置。推荐这种做法。

/run/systemd/system这个目录一般是进程在运行时动态创建unit文件的目录，一般很少修改，除非是修改程序运行时的一些参数时，即Session级别的，才在这里做修改。

3. 参考资料

https://unix.stackexchange.com/questions/206315/whats-the-difference-between-usr-lib-systemd-system-and-etc-systemd-system

https://wiki.archlinux.org/index.php/Systemd
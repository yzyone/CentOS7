# Centos 7.3 设置 max open files


查看当前系统限制：

	ulimit -a

可以看到如下信息：

```
core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
file size               (blocks, -f) unlimited
pending signals                 (-i) 1024
max locked memory       (kbytes, -l) 32
max memory size         (kbytes, -m) unlimited
max open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
stack size              (kbytes, -s) 10240
cpu time               (seconds, -t) unlimited
max user processes              (-u) 4096
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited
```

其中max open files就是要修改的数值。
临时修改可以直接使用 ulimit -n 524228修改，如果要永久修改，则需要修改配置文件：

	sudo vi /etc/security/limits.conf

在末尾修改如下两项：

```
*      hard    nofile      524288
*      soft    nofile      524288
```

  然后重新登录系统查询就可以发现数值已经修改了。

  ————————————————

  版权声明：本文为CSDN博主「sunzq55」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。

  原文链接：https://blog.csdn.net/weixin_41474364/article/details/104973764

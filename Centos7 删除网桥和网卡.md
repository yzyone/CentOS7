brctl命令可以管理网桥，我们创建了网桥之后如何删除呢？
首先，你要将这个网桥上的port卸下来

```
brctl show
#查看网桥状态
brctl delif <网桥名> <端口名>
#卸载网桥上的端口
ifconfig
#查看是否有网桥网卡名
ifconfig <网桥名> down
#关闭此网卡
brctl delbr <网桥名>
#删除网桥
```

————————————————

版权声明：本文为CSDN博主「cuigelasi」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。

原文链接：https://blog.csdn.net/cuigelasi/article/details/78417027
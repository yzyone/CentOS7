
# 修改VNCServer的默认端口5900 #

VNCServer的默认端口是从5901开始的，这样经常会有人试图暴力破解，不安全，也会触发vnc的黑名单保护机制给自己登录带来麻烦。

下面说下修改默认端口的方法

1、编辑 /usr/bin/vncserver

    vi /usr/bin/vncserver

2、查找关键词 vncPort, 输入命令 `?vncPort`，定位到截图中的位置，如果没有定位到，输入大写的N，查找下一个位置就能找到 


```
} else {
    $displayNumber = &GetDisplayNumber();
}

$vncPort = 5900 + $displayNumber;
```

3. 把5900改成自己的端口，比如15900，保存退出，重启vnc就可以了
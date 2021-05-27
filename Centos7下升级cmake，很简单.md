
# centos7下升级cmake，很简单 #

1.下载cmake（看看自己版本对不对）

```
wget https://cmake.org/files/v3.6/cmake-3.6.2.tar.gz    
tar xvf cmake-3.6.2.tar.gz && cd cmake-3.6.2/
./bootstrap
```

2.解压，编译安装

	gmake

	gmake install（需要在su命令下执行，或者直接使用root账户安装）

3.查看新版本

	/usr/local/bin/cmake --version

4.删除原来cmake版本，建立软连接，测试

```
yum remove cmake -y
ln -s /usr/local/bin/cmake /usr/bin/
cmake --version
```
cmake更新成功！


注：ubuntu下直接使用make 即可

————————————————

版权声明：本文为CSDN博主「bemyself24_1」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。

原文链接：https://blog.csdn.net/u013714645/article/details/77002555
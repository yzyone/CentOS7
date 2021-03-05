
# CentOS7升级gdb #

手动编译升级

1、获取安装包并解压

```
地址是：
wget https://ftp.gnu.org/gnu/gdb/gdb-8.3.tar.xz
https://mirrors.ustc.edu.cn/gnu/gdb/gdb-8.3.tar.xz(国内)
或者
wget https://ftp.gnu.org/gnu/gdb/gdb-8.3.tar.gz
https://mirrors.ustc.edu.cn/gnu/gdb/gdb-8.3.tar.gz(国内)

解压缩
tar -Jxvf gdb-8.3.tar.xz
或者
tar -zxvf gdb-8.3.tar.gz

这两个版本选择下载时的版本进行不同的解压操作
```

2、安装一些依赖

    yum install texinfo libncurses5-dev

3.编译安装

```
cd gdb-8.3
./configure --prefix=/usr/local/gdb8
make && make install
```

4.更新gdb

```
rm -f /usr/bin/gdb
ln -s /usr/local/gdb8/bin/gdb /usr/bin/gdb
```

作者：YuWenHaiBo

链接：https://www.jianshu.com/p/49fffd5ca63a

来源：简书

著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
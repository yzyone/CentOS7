﻿# Centos7.5下源码编译安装gcc-8.3.0

Centos7.5yum安装的默认gcc版本为4.8.5，如果需要使用gcc的最新特性，需要源码安装gcc最新版。本文经过实际检测过。

原文链接：[https://www.jianshu.com/p/444169a3721a](https://www.jianshu.com/p/444169a3721a)

##### 1、yum 安装依赖包

```
yum install -y epel-release
yum install -y gcc gcc-c++ gcc-gnat libgcc libgcc.i686 glibc-devel bison flex texinfo build-essential 
```

##### 2、下载最新的gcc源码包


```
cd /usr/local/src
wget http://ftp.gnu.org/gnu/gcc/gcc-8.3.0/gcc-8.3.0.tar.xz
tar -xJvf gcc-8.3.0.tar.xz
```

##### 3、提前手动下载依赖库（节省步骤4时间）

```
cd /usr/local/src/gcc-8.3.0
wget http://ftp.gnu.org/gnu/gmp/gmp-6.1.0.tar.xz
wget http://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz
wget http://ftp.gnu.org/gnu/mpfr/mpfr-3.1.4.tar.xz
wget http://isl.gforge.inria.fr/isl-0.18.tar.xz

tar -xJvf gmp-6.1.0.tar.xz
tar -zxvf mpc-1.0.3.tar.gz
tar -xJvf mpfr-3.1.4.tar.xz
tar -xJvf isl-0.18.tar.xz
```

##### 4、检查和下载gcc依赖库

```
cd /usr/local/src/gcc-8.3.0
./contrib/download_prerequisites
```


##### 5、编译安装依赖包

```
cd /usr/local/src/gcc-8.3.0
cd gmp-6.1.0
./configure --prefix=/usr/local/gmp-6.1.0
make && make install
./configure
make && make install
cd ..
cd mpfr-3.1.4
./configure --prefix=/usr/local/mpfr-3.1.4 --with-gmp=/usr/local/gmp-6.1.0
make && make install
cd ..
cd mpc-1.0.3
./configure --prefix=/usr/local/mpc-1.0.3 --with-gmp=/usr/local/gmp-6.1.0 --with-mpfr=/usr/local/mpfr-3.1.4
make && make install
cd ..
cd isl-0.18
./configure --prefix=/usr/local/isl-0.18  --with-gmp=/usr/local/gmp-6.1.0
make && make install
```


##### 6、添加动态链接库

```
vim /etc/ld.so.conf
```

编辑如下

```
include ld.so.conf.d/*.conf
/lib
/lib64
/usr/lib
/usr/lib64
/usr/local/lib
/usr/local/lib64
/usr/local/gmp-6.1.0/lib
/usr/local/mpc-1.0.3/lib
/usr/local/mpfr-3.1.4/lib
/usr/local/isl-0.18/lib
```


备注： 重新搜索当前系统上所有库文件搜索路径下的库文件,并生成缓存

```
ldconfig -v 
```

##### 7、创建编译目录

```
cd /usr/local/src/gcc-8.3.0
mkdir build && cd build
../configure --prefix=/usr/local/gcc-8.3.0 --with-gmp=/usr/local/gmp-6.1.0 --with-mpfr=/usr/local/mpfr-3.1.4 --with-mpc=/usr/local/mpc-1.0.3 --enable-checking=release --enable-languages=c,c++ --disable-multilib
make -j 4 && make install
```
备注： 4为当前服务器每颗物理CPU中的核心数，以实际为准。

##### 8、配置环境变量

```
vim /etc/profile
```

结尾加入一行

```
export PATH=/usr/local/gcc-8.3.0/bin:$PATH
```

保存退出，然后输入 exit 命令退出当前终端窗口。

```
source /etc/profile
```

##### 9、检查gcc版本

重新登录后检查当前gcc版本

```
gcc -v
```

大功告成OK



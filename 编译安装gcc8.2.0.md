# Centos7.5下源码编译安装gcc-8.3.0

Centos7.5yum安装的默认gcc版本为4.8.5，如果需要使用gcc的最新特性，需要源码安装gcc最新版。本文经过实际检测过。

```
[root@i-97fl2lnj build]# gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/4.8.5/lto-wrapper
Target: x86_64-redhat-linux
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared --enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-linker-hash-style=gnu --enable-languages=c,c++,objc,obj-c++,java,fortran,ada,go,lto --enable-plugin --enable-initfini-array --disable-libgcj --with-isl=/builddir/build/BUILD/gcc-4.8.5-20150702/obj-x86_64-redhat-linux/isl-install --with-cloog=/builddir/build/BUILD/gcc-4.8.5-20150702/obj-x86_64-redhat-linux/cloog-install --enable-gnu-indirect-function --with-tune=generic --with-arch_32=x86-64 --build=x86_64-redhat-linux
Thread model: posix
gcc version 4.8.5 20150623 (Red Hat 4.8.5-44) (GCC) 
```

原文链接：[https://www.jianshu.com/p/444169a3721a](https://www.jianshu.com/p/444169a3721a)

参考链接：[https://blog.csdn.net/chenjia6605/article/details/82757568](https://blog.csdn.net/chenjia6605/article/details/82757568)

##### 1、yum 安装依赖包

```
yum install -y epel-release
yum install -y gcc gcc-c++ gcc-gnat libgcc libgcc.i686 glibc-devel bison flex texinfo build-essential 
```

也可以采用如下安装方式：
```
yum groupinstall -y 'Development Tools'
yum install -y texinfo bison flex gcc-gnat glibc-devel.i686 libgcc.i686
```

安装 i686 的包是为了安装32位的头文件和库，如果不安装i686的包，请在 configure 时加入--disable-multilib，取消对32位的支持。

##### 2、下载最新的gcc源码包


```
cd /usr/local/src
wget http://ftp.gnu.org/gnu/gcc/gcc-8.3.0/gcc-8.3.0.tar.xz
tar -Jxvf gcc-8.3.0.tar.xz
```

##### 3、提前手动下载依赖库（节省步骤4时间）

```
cd /usr/local/src/gcc-8.3.0
wget http://ftp.gnu.org/gnu/gmp/gmp-6.1.0.tar.bz2
wget http://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz
wget http://ftp.gnu.org/gnu/mpfr/mpfr-3.1.4.tar.bz2
wget http://isl.gforge.inria.fr/isl-0.18.tar.bz2
```

##### 4、检查和下载GCC需要的依赖：gmp、mpfr、mpc、isl

```
cd /usr/local/src/gcc-8.3.0
./contrib/download_prerequisites
```

正常情况会自动解压缩，如果有问题再手工执行以下步骤

```
tar -jxvf gmp-6.1.0.tar.bz2
tar -zxvf mpc-1.0.3.tar.gz
tar -jxvf mpfr-3.1.4.tar.bz2
tar -jxvf isl-0.18.tar.bz2
```

##### 5、编译安装依赖包（可选步骤）

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

注意：

可以不用单独编译gmp、mpfr、mpc和isl四个包，放在gcc源码下面一起编译（事实上这也是gcc-8.3.0/contrib/download_prerequisites脚本的做法，个人感觉更简洁些）

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
../configure --prefix=/usr/local/gcc-8.3.0 \
			--with-gmp=/usr/local/gmp-6.1.0 \
			--with-mpfr=/usr/local/mpfr-3.1.4 \
			--with-mpc=/usr/local/mpc-1.0.3 \
			--enable-checking=release \
			--enable-languages=c,c++ \
			--disable-multilib
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

附录：
如果提前编译了gmp、mpfr、mpc、isl可能会出现如下错误，清除目录重新编译即可。

    configure: error: source directory already configured; run "make distclean" there first
    
    make[2]: *** [configure-stage1-gmp] 错误1
    make[2]: 离开目录“/usr/local/src/gcc-8.3.0/build”
    make[1]: *** [stage1-bubble] 错误2
    make[1]: 离开目录“/usr/local/src/gcc-8.3.0/build”
    make: *** [all] 错误2

如果找不到gmp.h和libgmp,单独编译一次默认安装即可。（不要带--prefix=/usr/local/gmp-6.1.0）

```
cd gmp-6.1.0
./configure
make && make install
```

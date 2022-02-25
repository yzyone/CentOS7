# CentOS7升级OpenSSL到1.1.1 #

首先下载解压最新的 OpenSSL

```
wget https://github.com/openssl/openssl/archive/OpenSSL_1_1_1-stable.zip
unzip 
OpenSSL_1_1_1-stable.zip
```

然后就是编译安装了

```
./config --prefix=/usr/local/openssl // 指定安装路径
或者 ./config shared zlib // 安装成.so共享库
make && make install
```

最后替换当前系统的旧版本 openssl 「先保存原来的」

```
mv /usr/bin/openssl /usr/bin/openssl.old
mv /usr/lib64/openssl /usr/lib64/openssl.old
mv /usr/lib64/libssl.so /usr/lib64/libssl.so.old
ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/openssl/include/openssl /usr/include/openssl
ln -s /usr/local/openssl/lib/libssl.so /usr/lib64/libssl.so
echo "/usr/local/openssl/lib" >> /etc/ld.so.conf
ldconfig -v 
```

最后查看当前系统 openssl 版本

	openssl version


作者：iSakura

链接：https://www.jianshu.com/p/05810dbe129b

来源：简书

简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
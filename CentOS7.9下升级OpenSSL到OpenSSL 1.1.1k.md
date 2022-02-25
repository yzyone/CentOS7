# CentOS7.9下升级OpenSSL到OpenSSL 1.1.1k #

## 系统环境介绍以及准备 ##

**查看系统版本**

```
[root@xmg-hk ~]# cat /etc/redhat-release
CentOS Linux release 7.9.2009 (Core)
```

**查看openssl版本**

```
[root@xmg-hk ~]# openssl version 
OpenSSL 1.0.2k-fips  26 Jan 2017
```

**官网下载openssl-1.1.1k**

其他版本可参考下载：  https://www.openssl.org/source/openssl-1.1.1k.tar.gz

## 详细操作步骤 ##

**先备份**

```
mv /usr/bin/openssl /usr/bin/openssl.bak
mv /usr/include/openssl /usr/include/openssl.bak
```

**进入目录并编译**

```
cd /usr/local/openssl-1.1.1k
./config --prefix=/usr/local/openssl
make && make install
```

**建立链接**

```
ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/openssl/include/openssl /usr/include/openssl
echo "/usr/local/openssl/lib" >> /etc/ld.so.conf
ldconfig -v
```

**查看是否升级成功**

```
[root@xmg-hk ~]# openssl version 
OpenSSL 1.1.1k  25 Mar 2021
```

> 说明：需要先进行备份，备份需要在"建立链接"操作以前完成。

本文由 小马哥 创作，采用 知识共享署名4.0 国际许可协议进行许可
本站文章除注明转载/出处外，均为本站原创或翻译，转载前请务必署名
最后编辑时间为:             2021/11/28 14:21         

# Centos7.5安装Keepalived #

1、 创建依赖环境

    yum -y install openssl-devel gcc gcc-c++
    mkdir /etc/keepalived
    wget https://www.keepalived.org/software/keepalived-2.0.18.tar.gz


2、安装keepalived

    tar -zxvf keepalived-2.0.18.tar.gz
    mv keepalived-2.0.18 /usr/local/keepalived
    cd /usr/local/keepalived
    ./configure && make && make install



3、创建启动文件

    cp  -a /usr/local/etc/keepalived   /etc/init.d/
    cp  -a /usr/local/etc/sysconfig/keepalived /etc/sysconfig/
    cp  -a /usr/local/sbin/keepalived /usr/sbin/


4、创建配置文件

master

    cat > /etc/keepalived/keepalived.conf << EOF

内容如下：

```
! Configuration File for keepalived
global_defs {
        router_id 31
} 
vrrp_instance VI_1 {
        state MASTER
        interface ens33
        virtual_router_id 3
        mcast_src_ip 10.1.1.132
        priority 200
        advert_int 1 
        authentication {
                auth_type PASS
                auth_pass 123456
        }
        virtual_ipaddress {
                10.1.1.111/24
        }
}
EOF
```

slave

    cat > /etc/keepalived/keepalived.conf << EOF

内容如下：

```
! Configuration File for keepalived
global_defs {
        router_id 32
} 
vrrp_instance VI_1 {
        state BACKUP
        interface ens33
        virtual_router_id 3
        mcast_src_ip 10.1.1.132
        priority 90 
        advert_int 1 
        authentication {
                auth_type PASS
                auth_pass 123456
        }
        virtual_ipaddress {
                10.1.1.111/24
        }
}
EOF
```

5、启动keepalived

    systemctl start keepalived
    systemctl enable keepalived


四、测试
1、在两台服务器上测试

master

    $ curl localhost
    this is master
    root@centos7[14:46:07]:~
    $ curl 10.1.1.111
    this is master
    root@centos7[15:03:29]:~


slave

    $ curl localhost
    this is slave
    root@centos7[15:03:59]:/etc/keepalived
    $ curl 10.1.1.111
    this is master


2、关闭master的keepalived模仿down机

master关闭keepalived

    $ systemctl stop keepalived 


在slave上面进行测试

    $  curl localhost
    this is slave
    root@centos7[15:10:29]:/etc/keepalived
    $ curl 10.1.1.111
    this is slave


到此keepalived完成
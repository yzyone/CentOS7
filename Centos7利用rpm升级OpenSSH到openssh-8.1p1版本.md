Centos7利用rpm升级OpenSSH到openssh-8.1p1版本

由于近期安全事故频发，打算把机器OpenSSH升级到最新版本，找了一圈，发现分享的rpm包就到7.4版本，最新版已经到8.1.p1，所以博客自编译一个openssh-8.1p1的rpm包进行分享。

检查环境：

    [root@test]# ssh -V
    OpenSSH_7.4p1, OpenSSL 1.0.2k-fips 26 Jan 2017

为保证顺利升级：

请务必确定系统版本为：CentOS7。

请确定openssh版本为7.x，openssl版本为 OpenSSL 1.0.2k及以上。（正常来说，系统都为以上版本。）

下载：

    wget https://cikeblog.com/s/openssh8.1.tar.gz
    tar -zxvf openssh8.1.tar.gz

安装方法一：

    rpm -Uvh *.rpm

安装方法二（此方法会自动处理依懒关系）：

    yum install ./*.rpm

安装后会如下提示：

```
[root@test ~]# rpm -Uvh *.rpm
Preparing...                          ################################# [100%]
Updating / installing...
   1:openssh-8.1p1-1.el7              ################################# [ 14%]
   2:openssh-clients-8.1p1-1.el7      ################################# [ 29%]
   3:openssh-server-8.1p1-1.el7       ################################# [ 43%]
   4:openssh-debuginfo-8.1p1-1.el7    ################################# [ 57%]
Cleaning up / removing...
   5:openssh-server-7.4p1-16.el7      ################################# [ 71%]
   6:openssh-clients-7.4p1-16.el7     ################################# [ 86%]
   7:openssh-7.4p1-16.el7             ################################# [100%]
[root@test ~]# ssh -V
OpenSSH_8.1p1, OpenSSL 1.0.2k-fips  26 Jan 2017
[root@768 ~]#
```

至此，升级完成，因为OPENSSH升级后，/etc/ssh/sshd_config会还原至默认状态，我们需要进行相应配置：

```
cd /etc/ssh/
chmod 400 ssh_host_ecdsa_key ssh_host_ed25519_key ssh_host_rsa_key
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes"  >> /etc/ssh/sshd_config
systemctl restart sshd
```

并且，/etc/pam.d/sshd也文件会被覆盖，我们进行还原：
先清空：

    >/etc/pam.d/sshd;
    >
再还原：

```
echo '#%PAM-1.0
auth       required     pam_sepermit.so
auth       include      password-auth
account    required     pam_nologin.so
account    include      password-auth
password   include      password-auth
# pam_selinux.so close should be the first session rule
session    required     pam_selinux.so close
session    required     pam_loginuid.so
# pam_selinux.so open should only be followed by sessions to be executed in the user context
session    required     pam_selinux.so open env_params
session    optional     pam_keyinit.so force revoke
session    include      password-auth'>/etc/pam.d/sshd
```

至此，升级完成，先别关闭终端，直接新开一个终端，连接到服务器测试。

注意：如果新开终端连接的时，root密码报错，并且已经根据上面后续操作，那可能就是SElinux的问题，我们进行临时禁用：

    setenforce 0

即可正常登录，然后修改/etc/selinux/config 文件：

    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

进行永久禁用SElinux即可。

注意：

如果Centos7默认openssl版本不为OpenSSL 1.0.2k，就需要先进行升级：

    yum install openssl -y

然后回到第一步进行安装即可。

    » 本文链接：[Centos7利用rpm升级OpenSSH到openssh-8.1p1版本](https://cikeblog.com/update-openssh-8-1p1.html)
    » 转载请注明来源：刺客博客
    » 如果文章失效或者安装失败，请留言进行反馈。
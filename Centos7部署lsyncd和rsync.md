
Centos7部署lsyncd+rsync

---

本教程目的：

本地源目录的增删改查即时自动备份到远程服务器。

rsync是什么？

是远程同步(remote sync)的程序。

lsyncd是什么？

可以监控文件改变的程序。

简言之，二者结合可以监控某目录下文件改动，lsyncd监控到的改动可以触发rsync备份文件。

前提

本教程术语：

主服务器：就是本地的文件所在的服务器

远程服务器：文件需要备份到的服务器

远程备份文件需要ssh，为了自动备份，需要让远程服务器（Slave Server）来记住主服务器（Master Server）的公钥：

在主服务器上获取公钥：

	ssh-keygen -t rsa

结果是你会得到两个文件：

	~/.ssh/ id_rsa 和 id_rsa.pub

然后用ftp或sftp将id_rsa.pub上传到你的远程服务器，改名为master.pub，执行以下命令：

	cat ~/.ssh/master.pub >> ~/.ssh/authorized_keys

这样就可以让远程服务器信任本地主服务器了。

如果，你没有发现~/.ssh这个目录，用以下命令创建：

	mkdir -p ~/.ssh

对于远程服务器：

编辑rsync.conf

	vim /etc/rsyncd.conf

如下：

    [backup]
    # destination directory for copy
    path = /home/backup
    # hosts you allow to access
    hosts allow = 1.1.1.1
    hosts deny = *
    list = true
    uid = root
    gid = root
    read only = false

启动rsync服务

	/usr/bin/rsync --daemon

对于主服务器：

安装lua：

	yum -y install lua lua-devel

安装lsyncd：

	yum -y install lsyncd

配置文件的例子在：

	/usr/share/doc/lsyncd*/examples/

配置lsyncd:

	vim /etc/lsyncd.conf

```
settings{
    --logfile = "/var/log/lsyncd/lsyncd.log",
    statusFile = "/tmp/lsyncd.stat",
    statusInterval = 1,
}

servers = {
 "2.2.2.2",
 "x.x.x.x"
}

for _, server in ipairs(servers) do
sync {
    default.rsyncssh,
    source="/home/backup/",
    host=server,
    targetdir="/home/backup/",
    --excludeFrom="/etc/lsyncd-excludes.txt",
    rsync = {
        compress = true,
        archive = true,
        verbose = true,
        rsh = "/usr/bin/ssh -p 22 -o StrictHostKeyChecking=no"
    }
}
end
```

注意这里没有考虑需要排除的目录，需要时用注释掉的excludeFrom命令。

运行

	systemctl start lsyncd.service

测试

现在可以测试增删改查了~

作者：田七西西

链接：https://www.jianshu.com/p/0ecac4f6baf2

来源：简书

著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
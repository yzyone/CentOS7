
### linux服务器之间设置免密登录 ###

两台服务器都是root用户为例：

1、本地机器生成密钥

	ssh-keygen -t rsa

公钥在~/.ssh/目录下
 
2、本地机器将公钥文件传输的远程机器，并生效

	ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.61.56

上面命令执行后就将本地机器/root/.ssh/id_rsa.pub文件里的公钥安装到远程机器/root/.ssh/authorized_keys文件里面了，完成了

我们可以对比一下

	cat /root/.ssh/authorized_keys

3、客户端配置机器名字与ip映射

如果需要ssh 机器名而不是ssh ip

	ssh tg-linux-2

那么新增配置文件/root/.ssh/config

内容如下

	Host tg-linux-2
	    HostName        192.168.61.56
	    Port            22
	    User            root
	    IdentityFile    ~/.ssh/id_rsa
 

参考链接： https://blog.csdn.net/lishuoboy/article/details/89853331
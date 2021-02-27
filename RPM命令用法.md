RMP 是 LINUX 下的一种软件的可执行程序，你只要安装它就可以了。这种软件安装包通常是一个RPM包（Redhat Linux Packet Manager，就是Redhat的包管理器），后缀是.rpm。 

RPM是Red Hat公司随Redhat Linux推出了一个软件包管理器，通过它能够更加轻松容易地实现软件的安装。 

1.安装软件：执行`rpm -ivh rpm包名`，如： 

    #rpm -ivh apache-1.3.6.i386.rpm 

2.升级软件：执行`rpm -Uvh rpm包名`。 

3.反安装：执行`rpm -e rpm包名`。 

4.查询软件包的详细信息：执行`rpm -qpi rpm包名` 

5.查询某个文件是属于那个rpm包的：执行`rpm -qf rpm包名` 

6.查该软件包会向系统里面写入哪些文件：执行`rpm -qpl rpm包名`

7，查看某个包是否被安装 `rpm -qa | grep XXXX(moudle name)`
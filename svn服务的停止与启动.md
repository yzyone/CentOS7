# svn服务的停止与启动 #

**linux 下停止所有的svn服务**

	killall svnserve

**linux 下启动svn服务 ，svn默认端口是3690**

	svnserve -d -r=/opt/svn/repository【仓库地址】


**指定端口号启动服务**

	svnserve -d –listen-port 3691 -r //opt/svn/repository

**windows 下停止svn服务**

	net stop svn 【停止服务】

**windows 下删除svn服务**

	sc delete svn 【删除服务】

————————————————

版权声明：本文为CSDN博主「itcake」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。

原文链接：https://blog.csdn.net/nanshaowei/article/details/52506083
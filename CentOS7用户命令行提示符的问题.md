Postgresql数据库安装用户命令行提示符的修正

	su
	su postgres

用户的命令行提示符是

	bash-4.2$

在root用户下操作如下：

	cp /home/dell/.bashrc /var/lib/pgsql/
	cp /home/dell/.bash_logout /var/lib/pgsql/
	chown postgres:postgres /var/lib/pgsql/.bashrc
	chown postgres:postgres /var/lib/pgsql/.bash_logout
	su postgres
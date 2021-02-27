
# Centos7 添加用户及设置权限 #

一、添加用户

1、登录root 用户

2、#useradd xxx(用户名) 回车

3、#passwd xxx(上面输入的用户名) 回车 此项是设置密码

4、#密码 回车

5、#确认密码 回车


二、给该用户添加root权限

1、#`chmod -v u+w /etc/sudoers` 为sudoers添加可写权限

2、切换到root(#su),输入visudo,进入命令模式 注：vi 有两种模式 ：命令模式和编辑模式

3、按Insert,进入编辑模式

4、在 sudoers 文件添加新用户信息到 ## Allow root to run any commands anywhere 下，修改后的效果为

      ## Allow root to run any commands anywher
      root   ALL=(ALL)    ALL
      xxx    ALL=(ALL)    ALL #xxx为新增用户

5、保存：按Esc 后 输入 :wq 保存并退出

6、取消 sudoers 文件可写权限     # chmod -v u-w /etc/sudoers


三、测试

1、普通用户进入

2、#sudo mkdir test(创建的文件夹名)

3、#ls 查看目录

4、#sudo rm -r test ( 删除文件夹)
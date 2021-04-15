
linux下搭建svn服务器 (多个项目的权限分组管理)

安装步骤如下：

1、`yum install subversion`

2、输入`rpm -ql subversion`查看安装位置

这里写图片描述 

输入 `svn –help`可以查看svn的使用方法 

需求

开发服务器搭建好SVN服务器，不可能只管理一个工程项目，如何做到不在一个项目中的开发人员不能访问其它项目中的代码，做好技术保密工作。 

代码仓库有三个仓库：project1,project2,project3 

假设人员有6个人:eg1,eg2,eg3,eg4,eg5,eg6 

eg1,eg2,只能访问project1； 
eg3,eg4,只能访问project2； 
eg5,eg6,只能访问project3；

3、创建svn版本库目录

    mkdir /var/svn 
    cd /var/svn 

//创建三个代码仓库 

    svnadmin create project1 
    svnadmin create project2 
    svnadmin create project3

执行命令后project1下会生成如下文件 
这里写图片描述

进入conf目录（该svn版本库配置文件） 

    authz文件是权限控制文件 
    passwd是帐号密码文件 
    svnserve.conf SVN服务配置文件

4.新建个目录统一管理用户权限

    mkdir /var/svn/conf 

//把两个权限配置文件复制到 /var/svn/conf路径下统一管理所有代码仓库 

    cd /projcet1/conf 
    cp authz passwd /var/svn/conf

5.修改配置文件

    vi svnserve.conf 

打开下面的几个注释(同时要删除#后面的空格)： 

    anon-access = none 
    auth-access = write #授权用户可写 
    password-db = /var/svn/conf/passwd #使用哪个文件作为账号文件 统一使用密码文件 
    authz-db = /var/svn/conf/authz #使用哪个文件作为权限文件 
    realm = project1 # 认证空间名，版本库所在目录 权限域名，很重要，写你的工程名

同时把project2的svnserve.conf也改了 

    anon-access = none 
    auth-access = write 
    password-db = /var/svn/conf/passwd 
    authz-db = /var/svn/conf/authz 
    realm = project2

同时把project3的svnserve.conf也改了 

    anon-access = none 
    auth-access = write 
    password-db = /var/svn/conf/passwd 
    authz-db = /var/svn/conf/authz 
    realm = project3

6.修改两个权限管理文件：

    vi passwd 

//用户名 ＝ 密码 

    [users] 
    eg1 = 123 
    eg2 = 123 
    eg3 = 123 
    eg4 = 123 
    eg5 = 123 
    eg6 = 123 

保存

注意：对用户配置文件的修改立即生效，不必重启svn服务。

    vi authz 

//组名 = 成员名

    [groups] //分组 
    admin = eg1,eg2 
    guest = eg3,eg4 
    guest1 = eg5,eg6 
    [/] 
    * = #以上没有定义的用户都没有任何权限

    [project1:/] //工程1的访问控制，guest1,2无法访问 
    @admin = rw
    
    [project2:/] 
    @guest = rw
    
    [project3:/] 
    @guest1 = rw

注意：对权限配置文件的修改立即生效，不必重启svn。

7.启动svn服务

    /usr/bin/svnserve -d -r /var/svn/

注意：不要使用系统提供的 /etc/init.d/svnserve start 来启动，因为系统默认的启动脚本中没有使用 –r /svn/project参数指定一个资源。这种情况下启动的svn服务，客户端连接会提示“svn: No repository found in ‘svn://192.168.11.229/project’ ”这样的错误。

默认svn服务器端口是3690。

杀死svn服务：

    ps -ef|grep svn
    
    root 4642 1 0 16:08 ? 00:00:00 svnserve -d -r /var/svn/
    
    root 4692 3676 0 16:13 pts/2 00:00:00 grep svn
    
    kill -9 4642

若要使用`/etc/init.d/svnserve` 脚本，可以修改start（）函数部分，如下：

```
start() {
    [ -x $exec ] || exit 5
    [ -f $config ] || exit 6
    echo -n $"Starting $prog: "
    daemon --pidfile=${pidfile} $exec $args -r /var/svn
    retval=$?
    echo
    [ $retval -eq 0 ] && touch $lockfile
    return $retval
}
```
 
完成

8.、在windows上测试

新建一个测试文件夹，在该文件夹下右键选择 SVN checkout如下图(要事先安装TortoiseSVN)： 

    svn://192.168.1.12/project1 
    svn://192.168.1.12/project2 
    svn://192.168.1.12/project3

问题:不能连接? 

解决办法: 

是因为：修改svnserve.conf 文件时。解开注释时要注意，同时要删除#后面的空格。也就是说要全部顶置。 
然后认证失败是要注意前面的[/]. 然后重启下SVN就好了

问题:svn 日志文件显示时间为1970-01-01 No data 

解决办法: 

此问题主要出现在svnserve文件中的anon-access访问权限的设置问题上。

anon-access 
控制非鉴权用户访问版本库的权限。取值范围为”write”、”read”和”none”。 
即”write”为可读可写，”read”为只读，”none”表示无访问权限。 
缺省值：read

anon-access = none时，按照文档中注释：禁止所有匿名访问，也就是说如果不在authz-db中开放访问的用户，是不会允许读写版本日志的，故系统对日志的读写也纳入禁止访问范围， 

在查看日志时，出现时间日期显示为1970-01-01， 日志信息显示no data。也就是这个原因。 

所以在设置svnserve中的访问权限时，请设置为 anon-access = read，只读模式。这样的话，日志文件即可显示正常。 
但是经过亲测 应该设置为anon-access = none

问题: 命令行方式连接，提示svn: No repository found in ‘svn://192.168.11.229/project’错误？

解决：启动svn服务的时候没有使用-r /var/svn参数，没有指明资源库的具体路径。使用# svnserve -d -r /var/svn/ 命令来启动就可以了，不要使用/etc/init.d/svnserver脚本。

问题: 执行命令# svn co svn://192.168.11.229/project时提示“svn: Authorization failed”错误？

解决：一般这种授权失败的错误原因都来自conf/authz文件的配置
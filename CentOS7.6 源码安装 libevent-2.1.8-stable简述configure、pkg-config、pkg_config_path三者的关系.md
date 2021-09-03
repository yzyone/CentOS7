
# CentOS7.6 源码安装 libevent-2.1.8-stable简述configure、pkg-config、pkg_config_path三者的关系 #

**获取libevent**

libevent官网：https://libevent.org/

GitHub-libevent项目链接：https://github.com/libevent/libevent

要获取libevent源码包，可以在上面两个网址链接上获取到。本人下载的是libevent-2.1.8-stable版本，源码包文件名为：libevent-2.1.8-stable.tar.gz。

《注意》安装需要有root权限，最好是在root用户下进行，如果不是root用户，执行编译安装操作时需要在命令前加上 sudo 。本人是在root用户下进行操作的。

**安装步骤**

一、解压缩源码包。

	tar -xzvf libevent-2.1.8-stable.tar.gz

 二、进入libevent-2.1.8-stable目录，执行 configure 配置脚本

 1、查看configure 脚本的使用帮助及其选项，可以执行命令：./configure --help 查看。

如果直接执行：./configure，那么默认安装路径是/usr/local，对应的头文件、可执行文件和库文件分别对应的目录是：'/usr/local/include'、'/usr/local/bin'，'/usr/local/lib'。

2、我本人设置了自定义安装路径，执行命令如下：

	./configure --prefix=/usr/local/libevent

 3、第2步执行成功后，会生成Makefile文件，然后使用make命令进行源码编译。

	make

 4、编译成功后，执行安装命令。

	make install

 5、进入/usr/local目录下，可以看到一个libevent目录，查看下这个目录的树形结构。

```
[root@centos7 local]# tree -L 3 libevent/
libevent/
├── bin
│   └── event_rpcgen.py
├── include
│   ├── evdns.h
│   ├── event2
│   │   ├── buffer_compat.h
│   │   ├── bufferevent_compat.h
│   │   ├── bufferevent.h
│   │   ├── bufferevent_ssl.h
│   │   ├── bufferevent_struct.h
│   │   ├── buffer.h
│   │   ├── dns_compat.h
│   │   ├── dns.h
│   │   ├── dns_struct.h
│   │   ├── event_compat.h
│   │   ├── event-config.h
│   │   ├── event.h
│   │   ├── event_struct.h
│   │   ├── http_compat.h
│   │   ├── http.h
│   │   ├── http_struct.h
│   │   ├── keyvalq_struct.h
│   │   ├── listener.h
│   │   ├── rpc_compat.h
│   │   ├── rpc.h
│   │   ├── rpc_struct.h
│   │   ├── tag_compat.h
│   │   ├── tag.h
│   │   ├── thread.h
│   │   ├── util.h
│   │   └── visibility.h
│   ├── event.h
│   ├── evhttp.h
│   ├── evrpc.h
│   └── evutil.h
└── lib
    ├── libevent-2.1.so.6 -> libevent-2.1.so.6.0.2
    ├── libevent-2.1.so.6.0.2
    ├── libevent.a
    ├── libevent_core-2.1.so.6 -> libevent_core-2.1.so.6.0.2
    ├── libevent_core-2.1.so.6.0.2
    ├── libevent_core.a
    ├── libevent_core.la
    ├── libevent_core.so -> libevent_core-2.1.so.6.0.2
    ├── libevent_extra-2.1.so.6 -> libevent_extra-2.1.so.6.0.2
    ├── libevent_extra-2.1.so.6.0.2
    ├── libevent_extra.a
    ├── libevent_extra.la
    ├── libevent_extra.so -> libevent_extra-2.1.so.6.0.2
    ├── libevent.la
    ├── libevent_pthreads-2.1.so.6 -> libevent_pthreads-2.1.so.6.0.2
    ├── libevent_pthreads-2.1.so.6.0.2
    ├── libevent_pthreads.a
    ├── libevent_pthreads.la
    ├── libevent_pthreads.so -> libevent_pthreads-2.1.so.6.0.2
    ├── libevent.so -> libevent-2.1.so.6.0.2
    └── pkgconfig
        ├── libevent_core.pc
        ├── libevent_extra.pc
        ├── libevent.pc
        └── libevent_pthreads.pc

5 directories, 56 files
```

 可以看到libevent目录下有3个一级子目录：bin/，include/ 和 lib。下面分别作简要的介绍：

bin/：这个目录下存放的是可执行文件，可以看到是一个event_rpcgen.py脚本文件，具体功能是什么目前还不清楚。

include/：这个目录下存放的是libevent三方库的头文件，它下面还有个子目录：event2/，存放的是支持libevent-2.x版本的头文件，以示区别libevent-1.x版本。因为libevent-1.x版本和libevent-2.x版本的变化有点大，为了向下兼容低版本的libevent，所以添加了event2这个子目录。当在程序中要用到libevent-2.x版本的某些头文件时，使用#include宏命令包含头文件的方式，举例如下：

	#include <event2/bufferevent.h>
	#include <event2/buffer.h>
	#include <event2/listener.h>
	#include <event2/util.h>
	#include <event2/event.h>
	#include <event2/thread.h>

lib/：lib目录存放的是libevent的库文件，包括静态库、动态库文件等文件。lib目录下还有一个子目录pkgconfig/，该子目录下的xxx.pc文件用于pkg-config工具的使用，具体用法这里不作说明了，这个工具可以帮助程序的源码编译工作。对应的环境变量是PKG_CONFIG_PATH，通过配置这个环境变量，在编译的时候编译器就可以找到所依赖的头文件和库文件。配置方法会在下面说明。pkgconfig目录下有4个.pc文件，这四个.pc文件对应着4个libevent库模块。

    libevent_core.pc   # libevent核心模块
    libevent_extra.pc  # libevent扩展模块
    libevent.pc# libevent基础模块
    libevent_pthreads.pc# libevent多线程模块

查看其中一个.pc文件的内容，# more libevent_core.pc

```
#libevent pkg-config source file

prefix=/usr/local/libevent
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: libevent_core
Description: libevent_core
Version: 2.1.8-stable
Requires:
Conflicts:
Libs: -L${libdir} -levent_core
Libs.private:
Cflags: -I${includedir}
```

 至此，libevent-2.1.8三方库安装成功了。但是，要使用libevent库进行应用程序的开发工作，还需要配置libevent三方库的开发环境。

**配置libevent的开发环境**

　　这里，我只说明最常见的配置三方库的使用环境，即通过配置相关环境变量的方式。具体方法是：在当前用户的home目录下的.bashrc 或者 .bash_profile配置文件中配置libevent库的使用环境。本人是在 .bash_profile 文件下配置相关环境变量的值的。

1、配置C语言头文件的搜索路径，对应的环境变量是C_INCLUDE_PATH ，C++头文件的环境变量是CPLUS_INCLUDE_PATH。

	]$ vim ~/.bash_profile    #添加内容如下：
	#Add C header file path
	export C_INCLUDE_PATH=/usr/local/libevent/include:$C_INCLUDE_PATH

 保存成功后，执行：source ~/.bash_profile，令修改生效，下同。查看C_INCLUDE_PATH 环境变量的值：echo $C_INCLUDE_PATH

2、配置库文件的搜索路径，对应的环境变量是：LIBRARY_PATH、LD_LIBRARY_PATH。添加内容如下：

	# Add third_lib path
	export LD_LIBRARY_PATH=/usr/local/libevent/lib:$LD_LIBRARY_PATH
	export LIBRARY_PATH=/usr/local/libevent/lib:$LIBRARY_PATH

 可能有人要问了，为什么 LD_LIBRARY_PATH、LIBRARY_PATH 配置的值是一样的，是不是多此一举呢？这里我解释一下，之前我在安装ZeroMQ三方库的时候，只配置了LD_LIBRARY_PATH这一个环境变量，但是在编译的时候仍然报了错误，错误描述信息如下：

	/usr/bin/ld: cannot find -lzmq
	collect2: error: ld returned 1 exit status

后来，我去技术问答网站寻求帮助，发现还需要配置 LIBRARY_PATH 这个环境变量，配置了这个环境变量之后，编译就通过了。这两个环境变量还是有所区别的，因此建议都加上。

3、尝试编译一个libevent程序，源文件名为：libevent_version.c，源码如下：

	#include <stdio.h>
	#include <event.h>
	 
	int main()
	{
	　　printf("The current libevent version is %s\n",event_get_version());
	　　return 0;
	}

编译命令： 

	gcc libevent_version.c -o libevent_version -levent

运行结果：The current libevent version is 2.1.8-stable

【参考】

 [环境变量：LIBRARY_PATH 和 LD_LIBRARY_PATH的区别](https://www.cnblogs.com/lovychen/p/10911600.html)

**使用 pkg-config 方式配置三方库的搜索路径**

　　在编写多文件项目或者大型项目的软件开发时，我们编译整个项目一般都是通过编写Makefile文件，使用make命令来编译的。在GCC编译阶段需要包含#include宏指令指定的头文件，在链接阶段又需要连接相应的库文件，由于头文件的搜索路径和库文件的搜索路径是相互独立的，这就可能带来一个问题：头文件搜索路径下的头文件和库文件搜索路径下的库文件可能不是对应同一个三方库的版本。比如说，头文件搜索路径下的头文件是libevent-1.14.14b版本的，而库文件搜索路径下的库文件是libevent-2.1.8版本的，这就带来了版本的不一致性了，在编译的时候可能会报错，或者说编译可以通过，但是在程序运行时可能会出现意想不到的错误，这就比较严重了，并且你还不好查错。

　　pkg-config工具正好可以解决上面遇到的编译链接不统一的问题。它的工作原理这里我就不作说明了，下面具体说明如何配置和使用pkg-config工具。以libevent为例来说明。

1、要使用pkg-config工具来设置三方库的搜索路径，需要配置一个环境变量PKG_CONFIG_PATH，配置值是xxx.pc文件的绝对路径。

    ]$ vim ~/.bash_profile
    #Add pkg-config path
    export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

 我这里使用的xxx.pc文件的路径是：/usr/local/lib/pkgconfig，这个路径是可以自定义的。修改保存后，执行：source ~/.bash_profile，令修改生效。

2、上文中我们提到，libevent的安装路径下的bin/pkgconfig目录下有4个.pc文件，我们将这4个.pc文件复制到配置路径下。

    ]# cd /usr/local/libevent/lib/pkgconfig/;ls
    libevent_core.pc  libevent_extra.pc  libevent.pc  libevent_pthreads.pc
    ]# cp *.pc /usr/local/lib/pkgconfig

 3、配置完成后，我们使用pkg-config 的方式来编译一下libevent_version.c这个源程序，编译命令如下：

    gcc `pkg-config --cflags --libs libevent` libevent_version.c -o libevent_version

 <说明> --cflags 参数，可以给出编译时所需的头文件搜索路径。--libs 参数，可以给出编译时所需的库文件搜索路径。libevent 对应的是 /usr/local/lib/pkgconfig目录下的libevent.pc文件。同时，可以注意到我们的编译命令并没有加 -levent 参数，但是加上也无妨。

<Tips> 建议在编写Makefile文件中，使用 pkg-config 的方式来设置三方库的开发环境，这样可以减少和规避潜在的开发风险。

【参考】

 [简述configure、pkg-config、pkg_config_path三者的关系](https://www.cnblogs.com/wliangde/p/3807532.html)

总结

 　　至此，libevent-2.1.8三方库的源码安装和开发环境配置就完成了，接下来就可以使用libevent库来进行应用程序的开发工作了。

原文链接：https://www.cnblogs.com/yunfan1024/p/13039654.html

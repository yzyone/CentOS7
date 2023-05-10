# linux centos7 挂载本地iso yum源

在内网部署的时候需要yum源安装很多依赖，一个一个考好麻烦后来才才知道可以挂载iso镜像文件

### 这是centos7的挂载方法 记录一下挂载iso文件 

1.上传镜像文件iso 到指定目录（找个空间的文件放进去）

2.创建挂载目录

```
mkdir /mnt/centos7
mount -o loop CentOS-7-x86_64-DVD-1810.iso  /mnt/centos7
```

3.备份yum源

```
cd /etc/yum.repos.d
#将 /etc/yum.repos.d目录下的所以*.repo后缀的文件没名备份。
mv CentOS-Base.repo CentOS-Base.repo.bak
```

4.修改配置文件 vi /etc/yum.repos.d/CentOS-Base.repo 

```
[centos7-local]
name=Centos7    ## 源名字
baseurl=file:///mnt/centos7     ## 本地镜像文件路径  
enabled=1    ## 1为启动yum源，0为禁用
gpgcheck=0    ## 1为检查GPG-KEY，0为不检查
#gpgkey=file:///mnt/centos7/RPM-GPG-KEY-redhat-release    ##GPG-KEY文件路径
```

5.修改后清除缓存

```
# yum clean all     ##清除缓存
# yum makecache        ##缓存yum源信息
```

6.测试安装

```
yum install net-tools
yum search jdk   #也可搜素
```

文章知识点与官方知识档案匹配，可进一步学习相关知识

[CS入门技能树](https://app.yinxiang.com/OutboundRedirect.action?dest=https%3A%2F%2Fedu.csdn.net%2Fskill%2Fgml%2Fgml-1c31834f07b04bcc9c5dff5baaa6680c%3Futm_source%3Dcsdn_ai_skill_tree_blog)[Linux入门](https://app.yinxiang.com/OutboundRedirect.action?dest=https%3A%2F%2Fedu.csdn.net%2Fskill%2Fgml%2Fgml-1c31834f07b04bcc9c5dff5baaa6680c%3Futm_source%3Dcsdn_ai_skill_tree_blog)[初识Linux](https://app.yinxiang.com/OutboundRedirect.action?dest=https%3A%2F%2Fedu.csdn.net%2Fskill%2Fgml%2Fgml-1c31834f07b04bcc9c5dff5baaa6680c%3Futm_source%3Dcsdn_ai_skill_tree_blog)29676 人正在系统学习中
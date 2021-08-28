
# 如何查看crontab的日志记录 #

谦杯 2019-06-13 12:01:12  27404  收藏 6
分类专栏： linux操作 文章标签： 如何查看crontab的日志记录

linux操作
专栏收录该内容
121 篇文章0 订阅
订阅专栏

## 如何查看crontab的日志记录 ##

在Unix和类Unix的操作系统之中，crontab命令常用于设置周期性被执行的指令，也可以理解为设置定时任务。

crontab中的定时任务有时候没有成功执行，什么原因呢？这时就需要去日志里去分析一下了，那该如何查看crontab的日志记录呢？

**linux**

看 /var/log/cron.log这个文件就可以，可以用tail -f /var/log/cron.log观察

**unix**

在 /var/spool/cron/tmp文件中，有croutXXX001864的tmp文件，tail 这些文件就可以看到正在执行的任务了。

**mail任务**

在 `/var/spool/mail/root` 文件中，有crontab执行日志的记录，用`tail -f /var/spool/mail/root` 即可查看最近的crontab执行情况。



有朋友问到关于linux的crontab不知道是否到底执行了没有，也算写过一些基本备份的shell脚本，结合自己的实际生产环境简单讲述下如何通过cron执行的日志来分析crontab是否正确执行。

例如服务器下oracle用户有如下的计划任务

```
[oracle@localhost6 ~]$ crontab -l
00 1 * * 0 /home/oracle/backup/hollyipcc.sh
00 1 1 * * /home/oracle/backup/hollyreport_hollycrm.sh
```

关于系统的计划任务都会先在/var/log

```
[root@localhost ~]# cd /var/log/
[root@localhost log]# less cron
Sep 22 04:22:01 localhost crond[32556]: (root) CMD (run-parts /etc/cron.weekly)
Sep 22 04:22:01 localhost anacron[32560]: Updated timestamp for job `cron.weekly' to 2013-09-22
Sep 22 05:01:01 localhost crond[22768]: (root) CMD (run-parts /etc/cron.hourly)
Sep 22 06:01:01 localhost crond[25522]: (root) CMD (run-parts /etc/cron.hourly)
Sep 22 07:01:01 localhost crond[28255]: (root) CMD (run-parts /etc/cron.hourly)
Sep 22 08:01:01 localhost crond[30982]: (root) CMD (run-parts /etc/cron.hourly)
。。。
```

上面的/var/log/cron只会记录是否执行了某些计划的脚本，但是具体执行是否正确以及脚本执行过程中的一些信息则linux会每次都发邮件到该用户下。

如上述oracle的计划任务执行信息，linux会发邮件到/var/spool/mail下面

```
[root@localhost6 log]# cd /var/spool/mail/
[root@localhost6 mail]# less oracle
Date: Sun, 25 Aug 2013 01:00:01 +0800
Message-Id: <201308241700.r7OH01aG016679@localhost6.localdomain6>
From: root@localhost6.localdomain6 (Cron Daemon)
To: oracle@localhost6.localdomain6
Subject: Cron /home/oracle/backup/hollyipcc.sh
Content-Type: text/plain; charset=UTF-8
Auto-Submitted: auto-generated
X-Cron-Env: 
X-Cron-Env: 
X-Cron-Env: 
X-Cron-Env: 
X-Cron-Env:

backup hollyipcc

Export: Release 10.2.0.4.0 - Production on Sunday, 25 August, 2013 1:00:02

Copyright (c) 2003, 2007, Oracle. All rights reserved.

Connected to: Oracle Database 10g Enterprise Edition Release 10.2.0.4.0 - Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options
Starting "SYSTEM"."SYS_EXPORT_SCHEMA_01": system/******** dumpfile=hollyipcc_20130825.dmp logfile=hollyipcc_20130825.log directory
=back schemas=hollyipcc parfile=/home/oracle/backup/parfile.par
Estimate in progress using BLOCKS method...
Processing object type SCHEMA_EXPORT/TABLE/TABLE_DATA
Total estimation using BLOCKS method: 5.932 GB
Processing object type SCHEMA_EXPORT/TABLE/TABLE
Processing object type SCHEMA_EXPORT/TABLE/GRANT/OWNER_GRANT/OBJECT_GRANT
Processing object type SCHEMA_EXPORT/TABLE/INDEX/INDEX
Processing object type SCHEMA_EXPORT/TABLE/CONSTRAINT/CONSTRAINT
Processing object type SCHEMA_EXPORT/TABLE/INDEX/STATISTICS/INDEX_STATISTICS
Processing object type SCHEMA_EXPORT/TABLE/STATISTICS/TABLE_STATISTICS
. . exported "HOLLYIPCC"."BASE_CONTACTSTATE_BAK":"P201203" 1.389 GB 15716014 rows
```

此时我们就能很好的判断crontab脚本是否执行，已经执行过程中是否正确以及一些错误的信息，希望这个可以帮助有些朋友很好的了解crontab的原理和诊断crontab的问题。
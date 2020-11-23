#!/bin/sh
# function:自动监控tomcat进程，挂了就执行重启操作
# author:huanghong
# DEFINE

# 定义tomcat路径
TOMCAT_HOME=/home/apache-tomcat-9.0.27
# 定义要监控的页面地址
WebUrl=http://192.168.101.120:9010

# 获取tomcat PPID
#TomcatID=$(ps -ef |grep tomcat |grep -w '/home/apache-tomcat-9.0.27'|grep -v 'grep'|awk '{print $2}')
TomcatID=$(ps -aux | grep ${TOMCAT_HOME} | grep java | awk '{print $2}')
# tomcat_startup
StartTomcat=$TOMCAT_HOME/bin/startup.sh
# 日志输出
GetPageInfo=$TOMCAT_HOME/logs/visitErro.log
TomcatMonitorLog=$TOMCAT_HOME/logs/TomcatMonitor.log

Monitor()
{
  echo "[info]开始监控tomcat...[$(date +'%F %H:%M:%S')]"
  if [ $TomcatID ];then
    echo "[info]tomcat进程ID为:$TomcatID."
    # 获取返回状态码 302重定向
    TomcatServiceCode=$(curl -s -o $GetPageInfo -m 10 --connect-timeout 10 $WebUrl -w %{http_code})
    if [[ $TomcatServiceCode == 200 ]] || [[ $TomcatServiceCode == 302 ]];then
        echo "[info]返回码为$TomcatServiceCode,tomcat启动成功,页面正常."
    else
        echo "[error]访问出错，状态码为$TomcatServiceCode,错误日志已输出到$GetPageInfo"
        echo "[error]开始重启tomcat"
        kill -9 $TomcatID  # 杀掉原tomcat进程
        sleep 3
        $StartTomcat
    fi
  else
    echo "[error]进程不存在!tomcat自动重启..."
    echo "[info]$StartTomcat,请稍候......"
    $StartTomcat
  fi
  echo "------------------------------"
}
Monitor>>$TomcatMonitorLog

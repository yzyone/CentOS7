
### Tcpdump在Ubuntu和CentOS下的安装和使用 ###

Tcpdump安装

在Ubuntu下安装

	sudo apt-get install tcpdump

在CentOS下安装

	yum install tcpdump

tcpdump使用

安装好以后，运行tcpdump -help查看帮助如下所示：

	[root@luocheng5 ~]# tcpdump -h
	tcpdump version 4.9.2
	libpcap version 1.5.3
	OpenSSL 1.0.2k-fips  26 Jan 2017
	Usage: tcpdump [-aAbdDefhHIJKlLnNOpqStuUvxX#] [ -B size ] [ -c count ]
	                [ -C file_size ] [ -E algo:secret ] [ -F file ] [ -G seconds ]
	                [ -i interface ] [ -j tstamptype ] [ -M secret ] [ --number ]
	                [ -Q|-P in|out|inout ]
	                [ -r file ] [ -s snaplen ] [ --time-stamp-precision precision ]
	                [ --immediate-mode ] [ -T type ] [ --version ] [ -V file ]
	                [ -w file ] [ -W filecount ] [ -y datalinktype ] [ -z postrotate-command ]
	                [ -Z user ] [ expression ]

1、监视指定网络接口的数据包（本机网卡名为ens33)

	tcpdump -i ens33

2、监视指定主机的数据包,例如：抓取所有192.168.1.11主机发送和接收的数据包

	tcpdump -i ens33 host 192.168.1.11

3、抓取192.168.1.11主机发送的数据包

	tcpdump -i ens33 src host 192.168.1.11

4、抓取192.168.1.11主机接收到的数据包

	tcpdump -i ens33 dst 192.168.1.11

5、抓取指定端口的数据包：

	tcpdump -i ens33 udp port 12345

6、抓取回环网口的包：

	tcpdump -i ens33 -i lo

原文出处：csdn -> https://blog.csdn.net/lbc2100/article/details/80838191
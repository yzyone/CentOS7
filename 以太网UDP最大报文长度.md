以太网UDP最大报文长度

---
 
对于以太网环境下UDP传输中的数据包长度问题

首先要看TCP/IP协议，涉及到四层：链路层，网络层，传输层，应用层。

其中以太网（Ethernet）的数据帧在链路层

IP包在网络层

TCP或UDP包在传输层

TCP或UDP中的数据（Data)在应用层

它们的关系是 数据帧｛IP包｛TCP或UDP包｛Data｝｝｝

在应用程序中我们用到的Data的长度最大是多少，直接取决于底层的限制。

我们从下到上分析一下：

在链路层，由以太网的物理特性决定了数据帧的长度为（46＋18）－（1500＋18），其中的18是数据帧的头和尾，也就是说数据帧的内容最大为1500，即MTU（Maximum Transmission Unit）为1500；

在网络层，因为IP包的首部要占用20字节，所以这的MTU为1500－20＝1480；

在传输层，对于UDP包的首部要占用8字节，所以这的MTU为1480－8＝1472；

所以，在应用层，你的Data最大长度为1472。

（当我们的UDP包中的数据多于MTU(1472)时，发送方的IP层需要分片fragmentation进行传输，而在接收方IP层则需要进行数据报重组，由于UDP是不可靠的传输协议，如果分片丢失导致重组失败，将导致UDP数据包被丢弃）。

从上面的分析来看，在普通的局域网环境下，UDP的数据最大为1472字节最好（避免分片重组）。

但在网络编程中，Internet中的路由器可能有设置成不同的值（小于默认值），Internet上的标准MTU值为576，所以Internet的UDP编程时数据长度最好在576－20－8＝548字节以内。

MTU对我们的UDP编程很重要，那如何查看路由的MTU值呢？

对于windows OS: ping -f -l <data_length> <gateway_IP>

如：ping -f -l 1472 192.168.0.1

如果提示：Packets needs to be fragmented but DF set.

则表明MTU小于1500，不断改小data_length值，可以最终测算出gateway的MTU值；

对于linux OS: ping -c <number> -M do -s <data_length> <gateway_IP>

如： ping -c 1 -M do -s 1472 192.168.0.1

如果提示 Frag needed and DF set……

则表明MTU小于1500，可以再测以推算gateway的MTU。

当然要修改MTU的值，那就是网管的事了（一般人没这权限呀），我们只能申请加等待了 ^-^ 
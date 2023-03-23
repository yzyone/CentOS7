# [Elasticsearch集群优化](https://www.cnblogs.com/david-qing/p/8560245.html)

# 系统层面

修改默认文件描述符大小

```
echo '* soft nofile 1048576' >>/etc/security/limits.conf
echo '* hard nofile 1048576' >>/etc/security/limits.conf
echo 'elasticsearch soft memlock unlimited' >>/etc/security/limits.confecho 'elasticsearch hard memlock unlimited' >>/etc/security/limits.conf
```

 关闭swap，如果/etc/fstab里面设置了开机自动挂载注释掉

```
swapoff -a
```

JVM分配为物理内存一半，最多设置不要超过32G

配置文件:/etc/elasticsearch/jvm.options

内核优化配置文件

```
vm.swappiness = 1
vm.max_map_count=262144
net.ipv4.neigh.default.gc_stale_time = 120
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.lo.arp_announce = 2
net.ipv4.conf.all.arp_announce = 2
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 1024
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.core.rmem_max=8388608
net.core.wmem_max=8388608
net.core.rmem_default=65536
net.core.wmem_default=65536
net.ipv4.tcp_rmem='4096 87380 8388608'
net.ipv4.tcp_wmem='4096 65536 8388608'
net.ipv4.tcp_mem='8388608 8388608 8388608'
net.ipv4.route.flush=1
fs.file-max=1048576
net.ipv4.tcp_keepalive_time = 30
net.ipv4.tcp_keepalive_probes = 2
net.ipv4.tcp_keepalive_intvl = 2
net.ipv4.ip_local_port_range = 5000 65000
vm.overcommit_memory = 1
net.ipv4.ip_forward=1
```

# Elasticsearch配置层面

加大refresh_interval参数，增加缓存刷新到磁盘的时间,该配置的代价就是60秒后才把缓存数据刷新到磁盘。

```
curl -XPUT localhost:9200/logstash-*/_settings -d '{
    "index" : {
        "refresh_interval" : "60s"
    } }'
```

修改translog参数

translog是为了保证数据的一致性，默认每隔5s强制刷新translog日志到磁盘上，为了保证不丢数据每次index/bulk/delete/update的时候一定触发刷新translog到磁盘上，才给请求返回200，如果考虑性能优先可以设置以下参数。

```
curl -XPUT 'http://localhost:9200/_all/_settings?preserve_existing=true' -d '{
  "index.translog.durability" : "async"
}'
```

副本分片是可以随时调整的，有些较大的索引，可以在做optimize前，先把副本全部取消掉，登optimize完后，再重新开启副本。

```
curl -XPUT http://127.0.0.1:9200/索引名/_settings -d '
{ "index" : { "number_of_replicas" : 0 }
}'
```

修改primary shard和replica shard数量

默认值为每个indexer5个主分片1个副本分片可根据实际情况进行调整，我的集群目前为6个node，我变成了3个主分片1个副本分片，这样每个node分配一个shard，好处是节省了空间，坏处是冗余少了，

通过脚本每天凌晨1点自动创建indexer，截取部分脚本如下：

```
#!/bin/bash
DATE=`date +%Y.%m.%d`

curl -H "Content-Type: application/json;charset=UTF-8" -XPUT http://elasticsearch:9200/logstash-nginx-error-${DATE} -d '
{
    "settings" : {
        "index" : {
            "number_of_shards" : 3,
            "number_of_replicas" : 1
        }
    }
}'
```

另外附带几个常用的查看集群状态API

```
查看索引配置
curl -XGET http://127.0.0.1:9200/logstash-*/_settings?pretty

检查集群监控状况
curl -XGET http://127.0.0.1:9200/_cluster/health?pretty

检查节点状态
curl -XGET http://127.0.0.1:9200/_nodes/stats
```
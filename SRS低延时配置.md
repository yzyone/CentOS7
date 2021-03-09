**[HOME](Home) > [CN](v3_CN_Home) > [Realtime](#)**

# RTMP低延时配置

![](http://ossrs.net/gif/v1/sls.gif?site=github.com&path=/wiki/v3_CN_SampleRealtime)
[![](https://cloud.githubusercontent.com/assets/2777660/22814959/c51cbe72-ef92-11e6-81cc-32b657b285d5.png)](https://github.com/ossrs/srs/wiki/v3_CN_Contact#wechat)

配置SRS为Realtime模式，使用RTMP可以将延迟降低到0.8-3秒，可以应用到对实时性要求不苛刻的地方，譬如视频会议（其实视频会议，以及人类在开会的时候，正常时候是会有人讲，有人在听在想，然后换别人讲，其实1秒左右延迟没有问题的，除非要吵架，就需要0.3秒左右的延迟）。

配置最低延迟的服务器详细信息可以参考：[LowLatency](v3_CN_LowLatency)，本文举例说明部署的实例步骤。

<strong>假设服务器的IP是：192.168.1.170</strong>

<strong>第一步，获取SRS。</strong>详细参考[GIT获取代码](v3_CN_Git)

```bash
git clone https://github.com/ossrs/srs
cd srs/trunk
```

或者使用git更新已有代码：

```bash
git pull
```

<strong>第二步，编译SRS。</strong>详细参考[Build](v3_CN_Build)

```bash
./configure && make
```

<strong>第三步，编写SRS配置文件。</strong>详细参考[LowLatency](v3_CN_LowLatency)

将以下内容保存为文件，譬如`conf/realtime.conf`，服务器启动时指定该配置文件(srs的conf文件夹有该文件)。

```bash
# conf/realtime.conf
listen              1935;
max_connections     1000;
vhost __defaultVhost__ {
    tcp_nodelay     on
    min_latency     on;

    play {
        gop_cache       off;
        queue_length    10;
        mw_latency      100;
    }

    publish {
        mr off;
    }
}
```

<strong>第四步，启动SRS。</strong>详细参考[LowLatency](v3_CN_LowLatency)

```bash
./objs/srs -c conf/realtime.conf
```

<strong>第五步，启动推流编码器。</strong>详细参考[LowLatency](v3_CN_LowLatency)

使用FFMPEG命令推流：

```bash
    for((;;)); do \
        ./objs/ffmpeg/bin/ffmpeg -re -i ./doc/source.200kbps.768x320.flv \
        -vcodec copy -acodec copy \
        -f flv -y rtmp://192.168.1.170/live/livestream; \
        sleep 1; \
    done
```

或使用FMLE推流：

```bash
FMS URL: rtmp://192.168.1.170/live
Stream: livestream
```

备注：测量延迟，可以使用FMLE推流时，将智能手机的秒表功能打开，用FMLE摄像头对着秒表，然后对比FMLE的摄像头的图像，和服务器分发的头像的延迟，就知道精确的延迟多大。参考：[延迟的测量](http://blog.csdn.net/win_lin/article/details/12615591)，如下图所示：
![latency](http://img.blog.csdn.net/20131011134922187?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2lubGludmlw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

<strong>第六步，观看RTMP流。</strong>详细参考[LowLatency](v3_CN_LowLatency)

RTMP流地址为：`rtmp://192.168.1.170/live/livestream`

注意：不要使用VLC观看，<strong>VLC的延迟会很大</strong>，虽然VLC能看到流。

或者使用在线SRS播放器播放：[http://ossrs.net/srs.release/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream](http://ossrs.net/srs.release/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream)

备注：请将所有实例的IP地址192.168.1.170都换成部署的服务器IP地址。

Winlin 2014.12

[nginx]: http://192.168.1.170:8080/nginx.html
[srs-player]: http://ossrs.net/srs.release/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream&port=1935
[srs-player-19350]: http://ossrs.net/srs.release/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream&port=19350
[srs-player-ff]: http://ossrs.net/srs.release/trunk/research/players/srs_player.html?vhost=__defaultVhost__&autostart=true&server=192.168.1.170&app=live&stream=livestream_ff
[jwplayer]: http://ossrs.net/srs.release/trunk/research/players/srs_player.html?app=live&stream=livestream.m3u8&server=192.168.1.170&port=8080&autostart=true&vhost=192.168.1.170&schema=http&hls_autostart=true&hls_port=8080
[jwplayer-ff]: http://ossrs.net/srs.release/trunk/research/players/srs_player.html?app=live&stream=livestream_ff.m3u8&server=192.168.1.170&port=8080&autostart=true&vhost=192.168.1.170&schema=http&hls_autostart=true&hls_port=8080

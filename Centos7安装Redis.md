#Centos7��װRedis

ԭ������: https://www.jianshu.com/p/f4e27cf54f60
����߱ʼ�


һ����װredis 

        yum install redis

        ����ѡ���һֱ y

��װ���
��������redis���� 

       /bin/systemctl  start  redis.service

��������redis

       redis-cli

       set  'test'  'hello'

       get  'test'

����redis
�ġ��޸�����

        1.�������ļ� 

            whereis  redis.config     

�������ļ�
       2.�������ļ�  

           vi /etc/redis.conf



�����ⲿ����
        ����Զ�̷���

        #bind 127.0.0.1

        �˿ں�

        port 8888

        ��������

        requirepass FA86D6708231EACC2EC22F0_20190624

        �رձ���

        protected-mode no

          ESC  :wq  ����

         /bin/systemctl  restart  redis.service

��������

    ����  /bin/systemctl  start  redis.service

    ����  /bin/systemctl  restart  redis.service

    �ر�  /bin/systemctl  stop  redis.service
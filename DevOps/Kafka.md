

## Kafka

#### 一、Kafka概述

1. 消息队列

   ![1562550374968.png](http://ww1.sinaimg.cn/large/d3f19072gy1gaq7m4e7u3j20e907576a.jpg)

2. 什么是Kafka

   Kafka是一个分布式消息队列，由Scala开发。kafka对消息保存时根据Topic进行分类，发布消息者称为producer，消息接收者成为consumer，此外kafka集群由多个kafka实例组成，每个实例称为broker。

   无论是kafka集群，还是consumer都依赖于zookeeper集群保存一些meta信息，来保证系统可用性。

3. Kafka架构

   ![kafka架构01.png](http://ww1.sinaimg.cn/large/d3f19072gy1gaq7moh9u3j209z06v0tk.jpg)

   

   ![kafka架构02.png](http://ww1.sinaimg.cn/large/d3f19072gy1gaq7n8dynoj20r00dnah4.jpg)

   - producer：消息生产者，就是向kafka broker发消息的客户端
   - Consumer：消息消费者，向kafka broker取消息的客户端
   - Topic：可以理解为一个队列
   - Consumer Group（CG）：这是kafka用来实现一个topic消息的广播（发给所有consumer）和单播（发给任一个consumer）的手段，一个topic可以有多个CG。Topic的消息会复制到所有的CG，但每个Partition只会把消息发给该CG中的一个consumer。如果需要实现广播，只要每个consumer有一个独立的CG就可以了。要实现单播只要所有的consumer在同一个CG，用CG还可以将consumer进行自由的分组而不需要多次发消息到不同的topic。
   - Broker：一台kafka服务器就是一个broker，一个集群由多个broker组成。一个broker可以容纳多个topic
   - Partition：为了实现扩展性，一个非常大的topic可以分布到多个broker上，一个topic可以分为多个partition，每个partition是一个有序的队列。partiton中的每条消息都会被分配一个有序的id（offset）。kafka只保证按一个partition中的顺序将消息发给consumer，不保证一个topic的整体（多个partition间）的顺序。
   - Offset：kafka的存储文件都是按照offset.kafka来命名，用offset做名字的好处是方便查找，例如你想找位于2049的位置，只要找到2048.kafka的文件即可。

#### 二、kafka集群部署

​	zookeeper环境，安装好jdk并配置环境变量

1. 下载安装包

2. 解压

   ```bash
   [root@db02 app]# tar -zxf kafka_2.12-2.1.1.tgz
   [root@db02 app]# mv kafka_2.12-2.1.1/ kafka
   ```

3. 修改配置文件`server.properties`

   ```bash
   # 需要修改的选项
   broker.id=0  #不同节点id不同
   delete.topic.enable=true
   log.dirs=/app/kafka/logs #日志及数据目录
   zookeeper.connect=172.16.100.11:2181 #zookeeper集群信息，多个节点可以用逗号分隔
   listeners=PLAINTEXT://172.16.100.11:9092
   ```

4. 启动kafka

   ```bash
   # 启动zookeeper
   [root@db02 ~]# cd /app/zookeeper-3.4.14/bin/
   [root@db02 bin]# ./zkServer.sh start
   #启动kafka
   bin/kafka-server-start.sh  config/server.properties
   # 启动到后台
   bin/kafka-server-start.sh -daemon config/server.properties &
   ```

5. kafka命令行操作

   1. 创建topic

      使用kafka-topics.sh 创建单分区单副本的topic test

      ```bash
      [root@db02 ~]# cd /app/kafka/
      bin/kafka-topics.sh --create --zookeeper 172.16.100.11:2181 --partitions 1 --replication-factor 1 --topic first
      ```

   2. 查看创建的topic

      ```bash
      [root@db02 kafka]# bin/kafka-topics.sh --list --zookeeper 172.16.100.11:2181
      ```

   3. 发送消息

      ```bash
      [root@db02 kafka]# bin/kafka-console-producer.sh --broker-list 172.16.100.11:9092 --topic first
      ```

   4. 消费消息

      ```bash
      bin/kafka-console-consumer.sh --bootstrap-server 172.16.100.11:9092 --topic first --from-beginning
      ```

   5. 查看topic详细信息

      ```bash
      [root@db02 kafka]# bin/kafka-topics.sh --zookeeper 172.16.100.11:2181 --describe --topic first
      Topic:first	PartitionCount:1	ReplicationFactor:1	Configs:
      	Topic: first	Partition: 0	Leader: 0	Replicas: 0	Isr: 0
      
      ```

   6. 删除topic

      ```bash
      [root@db02 kafka]# bin/kafka-topics.sh --delete --zookeeper 172.16.100.11:2181 --topic first
      ```

#### 三、Kafka工作流程分析

1. Kafka生产过程分析

   - 写入方式

     producer采用推（push）模式将消息发布到broker，每条消息都被追加（append）到分区（parttition）中，属于顺序写磁盘（顺序写磁盘比随机写内存要高，保证kafka吞吐率）

   - 分区（Partition）

     消息发送时都被发送到一个topic，其本质就是一个目录，而topic是由一些Partition Logs组成

     ![partition01.jpg](http://ww1.sinaimg.cn/large/d3f19072gy1gaq7nyk3pwj20ci05vq3m.jpg)

     ![partition02.jpg](http://ww1.sinaimg.cn/large/d3f19072gy1gaq7odfhrqj20e904swer.jpg)

   - 分区原则

     1. 指定了partition，则直接使用
     2. 未指定partition但指定key，则通过key的值hash出一个partition
     3. partition和key都未指定，则随即轮询出一个

   - 副本

   - 写入流程

     ![pruducer写入流程.jpg](http://ww1.sinaimg.cn/large/d3f19072gy1gaq7pbc4ivj20m10ajdie.jpg)

2. Kafka保存消息

   - 存储位置

   - 存储时间

   - zookeeper中存储结构

     ![kafka-zookeeper.jpg](http://ww1.sinaimg.cn/large/d3f19072gy1gaq7pwzspyj20md0f0n4c.jpg)

3. Kafka消费过程分析
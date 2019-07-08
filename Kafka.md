

## Kafka

#### 一、Kafka概述

1. 消息队列

   ![1562550374968](C:\Users\JiangZhiheng\Documents\Typora\img\1562550374968.png)

2. 什么是Kafka

   Kafka是一个分布式消息队列，由Scala开发。kafka对消息保存时根据Topic进行分类，发布消息者称为producer，消息接收者成为consumer，此外kafka集群由多个kafka实例组成，每个实例称为broker。

   无论是kafka集群，还是consumer都依赖于zookeeper集群保存一些meta信息，来保证系统可用性。

3. Kafka架构

   ![1562551545327](C:\Users\JiangZhiheng\Documents\Typora\img\kafka架构01)

   

   ![1562552246114](C:\Users\JiangZhiheng\Documents\Typora\img\kafka架构02)

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


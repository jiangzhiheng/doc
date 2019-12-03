#!/bin/bash
#
# shutdown kafka server
echo "shutdown kafka server..."
/root/app/kafka/bin/kafka-server-stop.sh &> /dev/null
lsof -i:9092 &> /dev/null
if [ $? -ne 0 ];then
	echo "kafka shutdown finished"
fi

# shutdown zookeeper server
/root/app/zookeeper/bin/zkServer.sh stop &> /dev/null
lsof -i:2181 &> /dev/null
if [ $? -ne 0 ];then
        echo "zookeeper shutdown finished"
fi

echo "All finished!"

#!/bin/bash
#
# startup zk Server
echo "starting zkServer..."
/root/app/zookeeper/bin/zkServer.sh start &>/dev/null
while true
do
	lsof -i:2181 &> /dev/null
	if [ $? -eq 0 ];then
		echo "zookeeper is running"
		break
	fi
	sleep 1
done

# startup kafka Server
echo "starting kafka server.."
/root/app/kafka/bin/kafka-server-start.sh -daemon /root/app/kafka/config/server.properties &
while true
do
        lsof -i:9092 &> /dev/null
        if [ $? -eq 0 ];then
                echo "kafka is running"
                break
        fi
        sleep 1
done
echo "All finished!"

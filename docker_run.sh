#!/bin/bash

docker run -d -h spark-docker --name spark -p 50010:50010 -p 50020:50020 -p 50070:50070 -p 50075:50075 -p 50090:50090 -p 2222:22 -p 8020:8020 -p 8080:8080 -p 9000:9000 -p 8030:8030 -p 8031:8031 -p 8032:8032 -p 8033:8033 -p 8040:8040 -p 8042:8042 -p 8088:8088 -p 19888:19888 --mount type=bind,source=/home/hyu/bigdata/data,target=/home/hadoop/data jigi/spark --daemon

#docker exec spark hdfs dfs -put data/AdmissionsCorePopulatedTable.txt data/AdmissionsDiagnosesCorePopulatedTable.txt data/LabsCorePopulatedTable.txt data/PatientCorePopulatedTable.txt data/shakespeare.txt /tmp

#docker exec spark hdfs dfs -chmod -R 777 /

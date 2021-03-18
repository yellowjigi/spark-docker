#!/bin/bash

# Start sshd
sudo /etc/init.d/ssh start

# Default user password
echo hadoop:hadoop | sudo chpasswd

# Start hdfs daemons
${HADOOP_HOME}/sbin/hadoop-daemon.sh start datanode
${HADOOP_HOME}/sbin/hadoop-daemon.sh start namenode

# Start yarn daemons
HADOOP_SSH_OPTS="-o StrictHostKeyChecking=accept-new" ${HADOOP_HOME}/sbin/yarn-daemons.sh start nodemanager
${HADOOP_HOME}/sbin/yarn-daemon.sh start resourcemanager

if [ "${1}" = "-d" ] || [ "${1}" = "--daemon" ]; then
	while true; do
		sleep 1000;
	done
elif [ "${1}" = "bash" ] || [ -z "${1}" ]; then
	bash
else
	echo "Invalid parameters"
fi

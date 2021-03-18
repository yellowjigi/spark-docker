# Base image
FROM ubuntu:18.04

LABEL maintainer="hoyeonjigi17@gmail.com"

# Install dependencies & some utils
RUN apt-get update && apt-get install --yes sudo curl tar ssh pdsh openjdk-8-jdk vim

# Create a user and group named hadoop
RUN useradd --create-home --shell /bin/bash hadoop &&\
	usermod --append --groups sudo hadoop &&\
	passwd -d hadoop

# Default root password
RUN echo root:root | chpasswd

USER hadoop
WORKDIR /home/hadoop

# Download Hadoop & Spark
RUN curl https://downloads.apache.org/spark/spark-3.0.2/spark-3.0.2-bin-hadoop2.7.tgz | tar -zx &&\
	curl http://archive.apache.org/dist/hadoop/common/hadoop-2.7.4/hadoop-2.7.4.tar.gz | tar -zx

## Environment variables

# General env
ENV USER hadoop
ENV HOME /home/hadoop

# Java env
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH ${PATH}:${JAVA_HOME}/bin

# Hadoop env
ENV HADOOP_HOME ${HOME}/hadoop-2.7.4
ENV HADOOP_PREFIX ${HADOOP_HOME}
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop
ENV HADOOP_PID_DIR ${HADOOP_HOME}/pids
ENV HADOOP_IDENT_STRING ${USER}
ENV PATH ${PATH}:${HADOOP_HOME}/bin

# Spark env
ENV SPARK_HOME ${HOME}/spark-3.0.2-bin-hadoop2.7
ENV SPARK_CONF_DIR ${SPARK_HOME}/conf
ENV PATH ${PATH}:${SPARK_HOME}/bin

# Copy the configuration files
COPY --chown=hadoop:hadoop core-site.xml hdfs-site.xml yarn-site.xml hadoop-env.sh ${HADOOP_CONF_DIR}/
COPY --chown=hadoop:hadoop spark-env.sh ${SPARK_CONF_DIR}

## SSH

# To set up login shell environment variables
COPY --chown=hadoop:hadoop hadooprc .hadooprc
RUN echo "\nsource .hadooprc" >> .profile

# For sshd to export envs before executing commands
RUN sed -i 's/return/source \.hadooprc\; return/' .bashrc

# For passphrase-less login to the SSH shell
RUN ssh-keygen -t rsa -P '' -f ${HOME}/.ssh/id_rsa &&\
	cat ${HOME}/.ssh/id_rsa.pub >> ${HOME}/.ssh/authorized_keys &&\
	chmod 600 ${HOME}/.ssh/authorized_keys

# Format the HDFS
RUN hdfs namenode -format

# Copy the entry point shell script
COPY --chown=hadoop:hadoop bootstrap.sh bootstrap.sh
ENTRYPOINT ["/bin/bash", "bootstrap.sh"]

## Ports required to be published

# Master Node
EXPOSE 8080

# Slave (Worker) Node
EXPOSE 8081

# HDFS
EXPOSE 50070

# HDFS NameNode
EXPOSE 8020

# HDFS Master Instance
EXPOSE 7077

# Spark Context
EXPOSE 4040

# History Server
EXPOSE 18080

# SSH
EXPOSE 22

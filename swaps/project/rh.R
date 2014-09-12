Sys.setenv(HADOOP_CMD="/opt/cloudera/parcels/CDH-4.7.0-1.cdh4.7.0.p0.40/lib/hadoop/bin/hadoop")
Sys.setenv(HADOOP_HOME="/opt/cloudera/parcels/CDH-4.7.0-1.cdh4.7.0.p0.40/lib/hadoop")
Sys.setenv(HADOOP_STREAMING="/opt/cloudera/parcels/CDH-4.7.0-1.cdh4.7.0.p0.40/lib/hadoop-mapreduce/hadoop-streaming-2.0.0-cdh4.7.0.jar")
Sys.setenv(HADOOP_COMMON_LIB_NATIVE_DIR="/opt/cloudera/parcels/CDH-4.7.0-1.cdh4.7.0.p0.40/lib/hadoop/lib/native/")


library(rJava)
library(rmr2)
library(rhdfs)
hdfs.init()

x <- hdfs.read.text.file("/user/hdfs/files/20140710052857316_test01_train.csv")
train <- read.table(textConnection(x),sep = ",",header = TRUE)

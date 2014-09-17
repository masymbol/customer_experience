Sys.setenv(HADOOP_CMD="/opt/cloudera/parcels/CDH-4.7.0-1.cdh4.7.0.p0.40/lib/hadoop/bin/hadoop")
Sys.setenv(HADOOP_HOME="/opt/cloudera/parcels/CDH-4.7.0-1.cdh4.7.0.p0.40/lib/hadoop")
Sys.setenv(HADOOP_STREAMING="/opt/cloudera/parcels/CDH-4.7.0-1.cdh4.7.0.p0.40/lib/hadoop-mapreduce/hadoop-streaming-2.0.0-cdh4.7.0.jar")
Sys.setenv(HADOOP_COMMON_LIB_NATIVE_DIR="/opt/cloudera/parcels/CDH-4.7.0-1.cdh4.7.0.p0.40/lib/hadoop/lib/native/")


library(rJava)
library(rmr2)
library(rhdfs)
hdfs.init()

############################################################################### option 1
f = hdfs.file("/user/hdfs/files/20140710052857316_test01_train.csv","r",buffersize=104857600)
f = hdfs.file("/user/hdfs/files/data.txt","r",buffersize=104857600)

m = hdfs.read(f)
c = rawToChar(m)
data = read.table(textConnection(c),sep = ",",header = TRUE)

reader = hdfs.line.reader("/user/hdfs/files/20140710052857316_test01_train.csv")


############################################################################## option 2
start.time <- Sys.time();
repeat {
  m = hdfs.read(f)
  duration <- as.numeric(difftime(Sys.time(), start.time, unit = "secs"))
  print(length(m) /  duration)
  start.time <- Sys.time()
}

############################################################################## option 3

x <- hdfs.read.text.file("/user/hdfs/files/20140710052857316_test01_train.csv")
train <- read.table(textConnection(x),sep = ",",header = TRUE)


############################################################################### option 4
list hdfs files in R
system("hadoop fs -ls /user/hdfs/")

delete file based on timestamp
$HADOOP_HOME/bin/hadoop fs -rm -r  `$HADOOP_HOME/bin/hadoop fs -ls | grep '.*2014.07.25.*' | cut -f 19 -d \ ` 


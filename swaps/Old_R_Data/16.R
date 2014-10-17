7+9
Sys.setenv(HIVE_HOME="/usr/lib/hive/hive-0.10.0")
library(rJava)
library(Rserve)
library(RHive)
library(stats)
library(BiocGenerics)
library(e1071)
library(rpart)

rhive.init()
rhive.connect()
rhive.query("show databases")
1+0
result =tryCatch({
  rhive.query("use bhakti")
}, warning = function(w) {
  1+1
}, error = function(e) {
  4+1
  rhive.query("show tables")
}, finally = {
  2+1
  rhive.query("show tables")
})
rhive.query("show tables")
rhive.query("select * from bhk2")
b1<-rhive.query("select * from bhk2")
rhive.query("DESC bhk2")
rhive.query("select * from bhk4")
b2<-rhive.query("select * from bhk4")
rhive.query("DESC bhk4")

head(b1)
b1$name = paste(b1$name, b1$last, sep=",")
b2$name = paste(b2$name, b2$last, sep=",")
b1=b1[-c(5)]
b2=b2[-c(4)]
View(b1)
View(b2)